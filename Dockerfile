FROM debian:13-slim

# Ruby and python are more sensible to version changes, so we set those to specific versions. The rest of the tools should be fine with the latest version, so
# we set those to latest.
ARG ASDF_VERSION=0.18.1
ARG RUBY_VERSION=3.4.9
ARG PYTHON_VERSION=3.14.4

# Install dependencies
RUN apt-get update && \
    apt upgrade -y && \
    apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    ca-certificates \
    curl \
    fd-find \
    git \
    jq \
    libbz2-dev \
    libffi-dev \
    libgmp-dev \
    liblzma-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libyaml-dev \
    make \
    ripgrep \
    unzip \
    zlib1g-dev && \
    ln -s /usr/bin/fdfind /usr/bin/fd && \
    rm -rf /var/lib/apt/lists/*

# Install asdf
RUN cd /tmp && \
    curl -L https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v${ASDF_VERSION}-linux-amd64.tar.gz -o asdf.tar.gz && \
    tar -xzf asdf.tar.gz && \
    rm asdf.tar.gz && \
    chmod +x asdf && \
    mv asdf /usr/bin

# Create non-root user
RUN useradd -m coder

USER coder
WORKDIR /home/coder

# This could be written a a single RUN command but should any of the utilities fail to install, that step would have to be run again, reinstalling everything.
# By splitting the installation into multiple steps, if one fails, only that step needs to be rerun.
# Same reason why we install pi, oh-my-pi and opencode separately, if one of those fails, the others don't need to be reinstalled.

RUN asdf plugin add python && \
    asdf set python ${PYTHON_VERSION} && \
    asdf install python

RUN asdf plugin add bun && \
    asdf set bun latest && \
    asdf install bun

RUN asdf plugin add uv && \
    asdf set uv latest && \
    asdf install uv

RUN asdf plugin add golang && \
    asdf set golang latest && \
    asdf install golang

RUN asdf plugin add ruby && \
     asdf set ruby ${RUBY_VERSION} && \
     asdf install ruby

ENV PATH="/home/coder/.asdf/shims:${PATH}"
ENV SHELL="/bin/bash"

RUN bun install -g @oh-my-pi/pi-coding-agent

RUN bun install -g @mariozechner/pi-coding-agent

RUN bun install -g opencode-ai

COPY bashrc /home/coder/.bashrc

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
