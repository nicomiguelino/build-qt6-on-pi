#!/bin/bash

#!/bin/bash
set -euo pipefail
CORE_COUNT="$(nproc)"
EXAMPLES_DIR='/src/examples'
RELEASE_DIR='/build/release'
EXAMPLE="${EXAMPLE:-all}"
PLATFORM="${PLATFORM:-aarch64}"

function build_hello() {
    echo "Building the hello example..."
    local ARCHIVE_NAME="hello-${PLATFORM}.tar.gz"
    cd ${EXAMPLES_DIR}/hello
    mkdir -p build/${PLATFORM} && cd build/${PLATFORM}
    cmake ../..
    cmake --build . --parallel ${CORE_COUNT}
    # Package the executables as tarballs.
    tar -czf ${RELEASE_DIR}/${ARCHIVE_NAME} hello
    cd ${RELEASE_DIR}
    sha256sum ${ARCHIVE_NAME} > ${ARCHIVE_NAME}.sha256
}

function build_webview() {
    echo "Building the webview example..."
    local ARCHIVE_NAME="webview-${PLATFORM}.tar.gz"
    cd ${EXAMPLES_DIR}/webview
    mkdir -p build/${PLATFORM} && cd build/${PLATFORM}
    cmake ../..
    cmake --build . --parallel ${CORE_COUNT}
    # Package the executables as tarballs.
    tar -czf ${RELEASE_DIR}/${ARCHIVE_NAME} webview
    cd ${RELEASE_DIR}
    sha256sum ${ARCHIVE_NAME} > ${ARCHIVE_NAME}.sha256
}

function main() {
    mkdir -p ${RELEASE_DIR}
    if [ "${EXAMPLE}" == "hello" ]; then
        build_hello
    elif [ "${EXAMPLE}" == "webview" ]; then
        build_webview
    elif [ "${EXAMPLE}" == "all" ]; then
        build_hello
        build_webview
    else
        echo "Unknown example: ${EXAMPLE}"
        exit 1
    fi
}
main
