FROM balenalib/raspberrypi3-debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# General-purpose dependencies
RUN apt-get -y update && apt-get install -y \
    wget \
    xz-utils

# Required build dependencies - Part 1
RUN apt-get -y update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    ccache

# Required build dependencies - Part 2
RUN apt-get -y update && apt-get install -y \
    libfontconfig1-dev \
    libdbus-1-dev \
    libfreetype6-dev \
    libicu-dev \
    libinput-dev \
    libxkbcommon-dev \
    libsqlite3-dev \
    libpng-dev \
    libssl-dev \
    libjpeg-dev \
    libglib2.0-dev

# Graphics driver options
RUN apt-get update && apt-get install -y \
    libgles2-mesa-dev \
    libgbm-dev \
    libdrm-dev

RUN mkdir -p /scripts /src

WORKDIR /build

CMD ["sleep", "infinity"]
