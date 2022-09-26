#!/usr/bin/env bash

set -euo pipefail

CONTAINER=iss-display-streamer
readonly CONTAINER
LISTEN_ADDRESS="127.0.0.1"
readonly LISTEN_ADDRESS
VERBOSE=1
readonly VERBOSE
SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_NAME


log() {
    if (( 1=="${VERBOSE}" )); then
        echo "$@" >&2
    fi

    logger -p user.notice -t "${SCRIPT_NAME}" "$@"
}

error() {
    echo "$@" >&2
    logger -p user.error -t "${SCRIPT_NAME}" "$@"
}

if [[ -z $(which podman) ]]; then
    if [[ -z $(which docker) ]]; then
        error "Could not find container executor."
        error "Install either podman or docker"
        exit 1
    else
        executor=docker
        log "Using ${executor} to run ${CONTAINER}"
    fi
else
    executor=podman
    log "Using ${executor} to run ${CONTAINER}"
fi

${executor} run -e XDG_RUNTIME_DIR=/tmp \
                -e WAYLAND_DISPLAY=wayland-1 \
                -e DISPLAY=:0 \
                -e WLR_BACKENDS=headless \
                -e WLR_LIBINPUT_NO_DEVICES=1 \
                -e SWAYSOCK=/tmp/sway-ipc.sock \
                -e MOZ_ENABLE_WAYLAND=1 \
                -e BROWSER_FULLSCREEN=1 \
                -e BROWSER_TABSWITCH_PAUSE=30 \
                -e URL="https://bbusse.github.io/analog-digital-clock|\
                        https://www.rainviewer.com/map.html?loc=50.9307,10.1074,6&oFa=0&oC=1&oU=1&oCS=0&oF=1&oAP=1&c=1&o=100&lm=1&layer=radar&sm=1&sn=1&undefined=0|\
                        https://upload.wikimedia.org/wikipedia/commons/2/2b/Berlin_U-bahn_und_S-bahn.svg" \
                -e STREAM_SOURCE="v4l2" \
                -e DEBUG="1" \
                -p "${LISTEN_ADDRESS}:5910:5910" \
                -p "${LISTEN_ADDRESS}:6000:6000/tcp" \
                -p "${LISTEN_ADDRESS}:6000:6000/udp" \
                --device /dev/video0:/dev/video0 \
                ${CONTAINER}
