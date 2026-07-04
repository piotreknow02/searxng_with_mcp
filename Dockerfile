FROM ghcr.io/searxng/searxng:latest

# Install Node.js 20+ for MCP server
RUN wget -q -O /tmp/node.tar.xz https://nodejs.org/dist/v24.18.0/node-v24.18.0-linux-x64.tar.xz && \
    mkdir -p /usr/local/lib && \
    mkdir /tmp/node/ && \
    tar -xJf /tmp/node.tar.xz -C /tmp/node/ && \
    mv /tmp/node/node-v24.18.0-linux-x64/* /usr/local/ && \
    rm -rf /tmp/node/ /tmp/node.tar.xz

# Install MCP server
RUN npm install -g mcp-searxng

# Copy customized template (entrypoint creates settings.yml from it)
COPY settings.template.yml /usr/local/searxng/settings.template.yml

# Copy the entrypoint script that launches both searxng and mcp server on stdio
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

# Port 8080 is used by searxng (internal container communication)
ENV SEARXNG_URL=http://localhost:8080

# Override entrypoint to run both searxng and MCP server
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
