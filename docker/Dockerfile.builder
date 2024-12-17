# vim:ft=dockerfile

FROM balenalib/raspberrypi5-debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Build dependencies for the Qt 6 app
RUN apt-get -y update && apt-get install -y \
    build-essential \
    cmake \
    qt6-base-dev \
    qt6-webengine-dev

RUN mkdir -p /scripts /src

WORKDIR /build

CMD ["sleep", "infinity"]

