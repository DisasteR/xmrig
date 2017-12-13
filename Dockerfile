FROM  alpine:latest as builder
RUN   apk add --no-cache \
        cmake \
        libuv-dev \
        libmicrohttpd-dev \
        build-base
COPY  . /xmrig
RUN   cd /xmrig && \
      mkdir build && \
      cmake -DCMAKE_BUILD_TYPE=Release . && \
      make

FROM  alpine:latest
RUN   apk add --no-cache libuv \
      libmicrohttpd && \
      adduser -S -G users -D -H -h /xmrig miner
#COPY --from=builder --chown=miner:users /xmrig/xmrig /xmrig/xmrig
COPY --from=builder /xmrig/xmrig /xmrig/xmrig
RUN   chown -R miner:users /xmrig
USER  miner
WORKDIR    /xmrig
ENTRYPOINT  ["./xmrig"]
