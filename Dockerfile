FROM alpine

ENV JFS_VERSION 1.0.4
WORKDIR /tmp/setup

RUN \
    wget "https://github.com/juicedata/juicefs/releases/download/v${JFS_VERSION}/juicefs-${JFS_VERSION}-linux-amd64.tar.gz" && \
    tar -zxf "juicefs-${JFS_VERSION}-linux-amd64.tar.gz" && \
    install juicefs /usr/local/bin && \
    cd / && rm -rf /tmp/setup

COPY entrypoint.sh /
WORKDIR /
ENTRYPOINT [ "./entrypoint.sh" ]
