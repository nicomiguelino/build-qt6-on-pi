#!/bin/bash

set -euo pipefail

TARGET=${TARGET:-pi4}
BUILD_DIR="/build"
PLATFORM_DIR="${BUILD_DIR}/${TARGET}"
DOWNLOAD_DIR="${BUILD_DIR}/downloads"
SRC_DIR="/src"
TOOLCHAIN_DIR="${SRC_DIR}/toolchain"

BUILD_QT="${BUILD_QT:-1}"
if (( BUILD_QT != 0 && BUILD_QT != 1 )); then
    echo "BUILD_QT should be 0 or 1"
    exit 1
fi

BUILD_EXAMPLES="${BUILD_EXAMPLES:-1}"
if (( BUILD_EXAMPLES != 0 && BUILD_EXAMPLES != 1 )); then
    echo "BUILD_EXAMPLES should be 0 or 1"
    exit 1
fi

CORE_COUNT=$(nproc)
QT_MAJOR="6"
QT_MINOR="5"
QT_PATCH="3"
QT_VERSION="${QT_MAJOR}.${QT_MINOR}.${QT_PATCH}"
QT_BASE_URL="https://download.qt.io/official_releases/qt"

EXAMPLES_DIR='/src/examples'
RELEASE_DIR='/build/release'

function build_hello() {
    echo "Building the hello example..."
    local ARCHIVE_NAME="hello-${TARGET}.tar.gz"

    cd ${EXAMPLES_DIR}/hello

    mkdir -p build/${TARGET} && cd build/${TARGET}

    ${PLATFORM_DIR}/qt6/bin/qt-cmake ../..
    cmake --build . --parallel ${CORE_COUNT}
    cmake --install .

    tar -czf ${RELEASE_DIR}/${ARCHIVE_NAME} hello
    cd ${RELEASE_DIR}
    sha256sum ${ARCHIVE_NAME} > ${ARCHIVE_NAME}.sha256
}

function build_qt() {
    local ARCHITECTURE=""
    if [ "$TARGET" == "pi4" ]; then
        ARCHITECTURE="armv8"
    elif [ "$TARGET" == "pi3" ]; then
        ARCHITECTURE="armv7"
    elif [ "$TARGET" == "pi2" ] || [ "$TARGET" == "pi1" ]; then
        ARCHITECTURE="armv6"
    else
        echo "Unknown target: ${TARGET}"
        exit 1
    fi

    local QT_BASE_DIR="qtbase-everywhere-src-${QT_VERSION}"
    local QT_BASE_ARCHIVE="${QT_BASE_DIR}.tar.xz"
    local QT_BASE_DOWNLOAD_URL="${QT_BASE_URL}/${QT_MAJOR}.${QT_MINOR}/${QT_VERSION}/submodules/${QT_BASE_ARCHIVE}"

    local QT6_INSTALL_DIR="/usr/local/qt6"
    local QT6_STAGE_DIR="${PLATFORM_DIR}/qt6"

    mkdir -p "${QT6_INSTALL_DIR}"
    mkdir -p "${DOWNLOAD_DIR}"

    if [ ! -f "${DOWNLOAD_DIR}/${QT_BASE_ARCHIVE}" ]; then
        wget "${QT_BASE_DOWNLOAD_URL}" -O \
            "${DOWNLOAD_DIR}/${QT_BASE_ARCHIVE}"
    fi

    mkdir -p "${PLATFORM_DIR}"

    if [ ! -d "${PLATFORM_DIR}/${QT_BASE_DIR}" ]; then
        tar xf "${DOWNLOAD_DIR}/${QT_BASE_ARCHIVE}" \
            -C "${PLATFORM_DIR}"
    fi

    mkdir -p "${PLATFORM_DIR}/qt-base-build" && \
        cd "${PLATFORM_DIR}/qt-base-build"

    local TOOLCHAIN_FILE="${TOOLCHAIN_DIR}/toolchain-${ARCHITECTURE}.cmake"

    cmake -G Ninja \
        -DCMAKE_INSTALL_PREFIX="${QT6_INSTALL_DIR}" \
        -DCMAKE_STAGING_PREFIX="${QT6_STAGE_DIR}" \
        -DQT_FEATURE_opengles2=ON \
        -DQT_FEATURE_opengles3=ON \
        -DQT_USE_CCACHE=ON \
        -DQT_FEATURE_eglfs=ON \
        -DQT_QPA_DEFAULT_PLATFORM=eglfs \
        -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
        -DQT_AVOID_CMAKE_ARCHIVING_API=ON \
        "${PLATFORM_DIR}/${QT_BASE_DIR}"

    cmake --build . --parallel "${CORE_COUNT}"
    cmake --install .
}

function build_examples() {
    local EXAMPLE="${1}"
    if [ "${EXAMPLE}" == "hello" ]; then
        build_hello
    else
        echo "Unknown example: ${EXAMPLE}"
        exit 1
    fi
}

function main() {
    mkdir -p ${RELEASE_DIR}

    if (( BUILD_QT == 1 )); then
        build_qt

        cd ${PLATFORM_DIR}
        tar -czf ${RELEASE_DIR}/qt-${QT_VERSION}-${TARGET}.tar.gz qt6

        cd ${RELEASE_DIR}
        sha256sum qt-${QT_VERSION}-${TARGET}.tar.gz \
            > qt-${QT_VERSION}-${TARGET}.tar.gz.sha256
    fi

    if (( BUILD_EXAMPLES == 1 )); then
        build_examples "hello"
    fi
}

main
