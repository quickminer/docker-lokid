# Requires docker 17.05

# Run sample docker run -d --name lokid -p 18081:18081 --mount type=bind,source=/media/data01/lokidata,target=/lokidata docker-lokid
FROM ubuntu:16.04 as builder

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
    language-pack-en-base \
    ca-certificates \
    wget \
    unzip && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# loki volume data
VOLUME /lokidata

## download && extrack & chmod
RUN wget https://github.com/loki-project/loki/releases/download/0.2.0/loki-unix64-v0.2.0.zip -P /lokid && \
    unzip /lokid/loki-unix64-v0.2.0.zip -d /lokid && \
    chmod +x /lokid/lokid

# Generate your wallet via accessing the container and run:
# cd /lokid
# loki-wallet-cli

EXPOSE 18080
EXPOSE 18081
ENTRYPOINT ["/lokid/lokid", "--p2p-bind-ip=0.0.0.0", "--p2p-bind-port=18080", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=18081", "--non-interactive", "--data-dir=/lokidata/.loki","--confirm-external-bind"]
