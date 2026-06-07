FROM node:24-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    curl \
    wget \
    nano \
    vim \
    htop \
    git \
    unzip \
    zip \
    procps \
    iproute2 \
    sudo \
    tmux \
    screen \
    ca-certificates \
    python3 \
    python3-pip \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN mkdir code

# User
RUN useradd -m coder
USER coder
WORKDIR /home/coder

# code-server config (NO PASSWORD)
RUN mkdir -p ~/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080" > ~/.config/code-server/config.yaml && \
    echo "auth: none" >> ~/.config/code-server/config.yaml

EXPOSE 8080

CMD ["code-server", "/home/coder/code"]
