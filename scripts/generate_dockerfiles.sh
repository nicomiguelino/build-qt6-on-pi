#!/bin/bash

set -euo pipefail

export BASE_TAG="bookworm"

PLATFORM="${PLATFORM:-pi5}"
SUPPORTED_PLATFORMS=("pi4" "pi5")

case "$PLATFORM" in
    "pi4")
        export BASE_IMAGE="balenalib/raspberrypi3-debian"
        ;;
    "pi5")
        export BASE_IMAGE="balenalib/raspberrypi5-debian"
        ;;
    *)
        echo "Error: PLATFORM must be either of the following: ${SUPPORTED_PLATFORMS[@]}"
        exit 2
        ;;
esac

# Generate builder Dockerfile
envsubst < docker/Dockerfile.builder.template > "docker/Dockerfile.builder.${PLATFORM}"
echo "Generated docker/Dockerfile.builder.${PLATFORM}"

# Generate sandbox Dockerfile
envsubst < docker/Dockerfile.sandbox.template > "docker/Dockerfile.sandbox.${PLATFORM}"
echo "Generated docker/Dockerfile.sandbox.${PLATFORM}"

echo "Done! Generated Dockerfiles for: ${PLATFORM}"
