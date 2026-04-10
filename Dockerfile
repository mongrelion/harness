FROM debian:13-slim

ARG VERSION

# Install dependencies
RUN apt-get update && \
    apt upgrade -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    ripgrep \
    fd-find \
    git \
    && ln -s /usr/bin/fdfind /usr/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# Download and install bun directly
RUN TARGET=linux-x64 && \
    curl -fsSL "https://github.com/oven-sh/bun/releases/latest/download/bun-${TARGET}.zip" -o /tmp/bun.zip && \
    mkdir -p /usr/bin && \
    unzip -oqd /tmp /tmp/bun.zip && \
    mv /tmp/bun-${TARGET}/bun /usr/bin/bun && \
    chmod +x /usr/bin/bun && \
    rm -rf /tmp/bun.zip /tmp/bun-${TARGET}

# Set up bun environment

# Install bun shell completions
RUN bun completions bash > /etc/bash.bashrc.d/bun 2>/dev/null || true

# Create non-root user
RUN useradd -m coder

USER coder

RUN bun install -g @oh-my-pi/pi-coding-agent@${VERSION}

ENV PATH="/home/coder/.bun/bin:$PATH"

ENTRYPOINT ["omp"]
