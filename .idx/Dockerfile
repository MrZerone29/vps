FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openssh-server \
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

# SSH setup
RUN mkdir -p /run/sshd
RUN ssh-keygen -A

# Root password
RUN echo "root:262006" | chpasswd

# SSH config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
