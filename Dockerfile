FROM balenalib/raspberrypi3-debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /scripts /src

WORKDIR /build

CMD ["sleep", "infinity"]
