#!/bin/sh
set -e

# Start searxng in background with nohup
mkdir -p /var/log/
/usr/local/searxng/entrypoint.sh > /var/log/searxng.log 2>&1 &

# Start MCP server via stdio
exec mcp-searxng
