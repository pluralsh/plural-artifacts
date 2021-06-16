FROM registry.opensource.zalan.do/acid/spilo-13:2.0-p7

ENV AWS_SDK_LOAD_CONFIG=1

ENV WALG_VERSION=v1.0
RUN rm /usr/local/bin/wal-g || echo "wal-g wasn't installed yet"
RUN apt-get update && apt-get install -y liblzo2-dev
RUN curl -sL https://github.com/wal-g/wal-g/releases/download/$WALG_VERSION/wal-g-pg-ubuntu-18.04-amd64.tar.gz \
                | tar -zxv \
        && mv wal-g-pg-ubuntu-18.04-amd64 /usr/local/bin/wal-g