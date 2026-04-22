FROM ubuntu:24.04
ARG BUILD_PACKAGES="git gettext-base build-essential yasm pkg-config nasm libfuse-dev libpcsclite-dev libwxgtk3.2-dev libgtk-3-dev" \
    DEBIAN_FRONTEND=noninteractive
ADD files /
RUN apt update && \
    apt install -y libfuse2t64 $BUILD_PACKAGES && \
    /build.sh && \
    apt remove -y --autoremove --purge $BUILD_PACKAGES && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
