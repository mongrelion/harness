FROM debian:13-slim

ARG UV_VERSION=0.11.6
ARG OMP_VERSION=latest
ARG PI_VERSION=latest
ARG OPENCODE_VERSION=latest

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
    python3 \
    python3-pip \
    python3-venv \
    jq \
    golang \
    make \
    && ln -s /usr/bin/fdfind /usr/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# Install asdf
RUN cd /tmp && \
    curl -L https://github.com/asdf-vm/asdf/releases/download/v0.18.1/asdf-v0.18.1-linux-amd64.tar.gz -o asdf.tar.gz && \
    tar -xzf asdf.tar.gz && \
    rm asdf.tar.gz && \
    chmod +x asdf && \
    mv asdf /usr/bin

# Set up bun environment
# Download and install bun directly
RUN TARGET=linux-x64 && \
    curl -fsSL "https://github.com/oven-sh/bun/releases/latest/download/bun-${TARGET}.zip" -o /tmp/bun.zip && \
    mkdir -p /usr/bin && \
    unzip -oqd /tmp /tmp/bun.zip && \
    mv /tmp/bun-${TARGET}/bun /usr/bin/bun && \
    chmod +x /usr/bin/bun && \
    rm -rf /tmp/bun.zip /tmp/bun-${TARGET}

# Install bun shell completions
RUN bun completions bash > /etc/bash.bashrc.d/bun 2>/dev/null || true

RUN curl -L https://releases.astral.sh/github/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz -o /tmp/uv.tar.gz && \
    tar -xzf /tmp/uv.tar.gz -C /tmp/ && \
    chmod +x /tmp/uv-x86_64-unknown-linux-gnu/* && \
    mv /tmp/uv-x86_64-unknown-linux-gnu/* /usr/bin/ && \
    rm -r /tmp/uv*

# Create non-root user
RUN useradd -m coder

USER coder

RUN bun install -g @oh-my-pi/pi-coding-agent@${OMP_VERSION}

RUN bun install -g @mariozechner/pi-coding-agent@${PI_VERSION}

RUN bun add -g opencode-ai@${OPENCODE_VERSION}

USER root

ENV PATH="/home/coder/.bun/bin:$PATH"

WORKDIR /home/coder

ENTRYPOINT ["bash"]
