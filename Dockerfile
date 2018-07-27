# Multistage docker build, requires docker 17.05

# builder stage
FROM ubuntu:16.04 as builder

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
    language-pack-en-base \
    ca-certificates \
    wget \
    unzip && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

## download && extrack & chmod
RUN mkdir /lokid && \
    wget https://github.com/loki-project/loki/releases/download/0.2.0/loki-unix64-v0.2.0.zip -P /lokid && \
    unzip /lokid/loki-unix64-v0.2.0.zip -d /lokid && \
    chmod +x /lokid/*

# Set ENV
ENV LC_ALL en_US.UTF-8

# Contains the blockchain
VOLUME /root/.bitmonero

# Generate your wallet via accessing the container and run:
# cd /wallet
# loki-wallet-cli
VOLUME /wallet

EXPOSE 18080
EXPOSE 18081
ENTRYPOINT ["/lokid/lokid", "--p2p-bind-ip=0.0.0.0", "--p2p-bind-port=18080", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=18081", "--non-interactive", "--confirm-external-bind"]