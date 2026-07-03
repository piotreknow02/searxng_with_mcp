# searxng with mcp

A self-contained **SearXNG + MCP server** packaged as a single Docker image. Gives AI agents powered by local models a private, on-host web search capability — no API keys, no external services.

## Why this exists

Public AI providers bundle web search, but that search runs on the provider's servers, not yours. If you run a private model (e.g. `llama.cpp`, `Ollama`, `LocalAI`), your agents have no way to browse the web.

This container runs **SearXNG** (the privacy-respecting metasearch engine) and exposes it as an **MCP server** over stdio. Your agent can then call web search just like any other tool, with all queries routed through your local instance.

## Recommended setup

Pull the image from GitHub Container Registry — this image is configured and ready to run out of the box:

```bash
docker pull ghcr.io/piotreknow02/searxng_with_mcp:latest
```

That's it. The container starts both SearXNG and the MCP server automatically.

## How it works

```txt
┌─────────────────────────────┐
│   AI Agent (local model)    │
└──────────┬──────────────────┘
           │ MCP protocol (stdio)
           ▼
┌─────────────────────────────┐
│  MCP Server                  │  ← mcp-searxng (npm package, installed in container)
│    mcp-searxng               │
└──────────┬──────────────────┘
           │ HTTP (localhost)
           ▼
┌─────────────────────────────┐
│  SearXNG                     │  ← runs inside the same container
│  localhost:8080              │
└─────────────────────────────┘
```

Both components live in a single container. The MCP server communicates with SearXNG over localhost, so all search happens on your host — nothing is sent to external services.

## Configuration

### opencode

Place `opencode.json` in `~/.opencode/`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "websearch": {
      "type": "local",
      "command": ["docker", "run", "--rm", "-i", "ghcr.io/piotreknow02/searxng_with_mcp:latest"]
    }
  }
}
```

Sources: [opencode.ai docs — MCP servers](https://opencode.ai/docs/mcp-servers).

### Claude Code (Anthropic)

Place `mcp.json` in the working directory or `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "websearch": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "ghcr.io/piotreknow02/searxng_with_mcp:latest"
      ]
    }
  }
}
```

Sources: [Anthropic plugin-dev docs — stdio configuration](https://github.com/anthropics/claude-code/blob/main/plugins/plugin-dev/skills/mcp-integration/SKILL.md).

### VS Code

Place `mcp.json` in `.vscode/` in your project root:

```json
{
  "mcp": {
    "servers": {
      "websearch": {
        "command": "docker",
        "args": ["run", "--rm", "-i", "ghcr.io/piotreknow02/searxng_with_mcp:latest"]
      }
    }
  }
}
```

Sources: [VS Code docs — MCP configuration](https://code.visualstudio.com/docs/agents/reference/mcp-configuration).

### Generic MCP client (any stdio-compatible tool)

```json
{
  "servers": {
    "websearch": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "ghcr.io/piotreknow02/searxng_with_mcp:latest"]
    }
  }
}
```
