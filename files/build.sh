#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s inherit_errexit
declare source_dir="$(mktemp -d)"
declare pack_dir="$(mktemp -d)"
declare output="/opt"
declare package_control_template="/package-control.txt"
declare binary="$output/veracrypt"
declare package="$output/veracrypt.deb"

function build() {
    (
        cd "$source_dir"
        git clone --depth 1 https://github.com/veracrypt/VeraCrypt.git
        git clone --depth 1 --recurse-submodules https://github.com/wxWidgets/wxWidgets.git
        cd "$source_dir/VeraCrypt/src"
        make WXSTATIC=1 WX_ROOT="$source_dir/wxWidgets" wxbuild
        make NOGUI=1 WXSTATIC=1
        mv "Main/veracrypt" "$output"
    )
}

function pack() {
    set -a
    source /etc/os-release
    set +a
    export VERACRYPT_VERSION="$(get_app_version)"
    export BUILD_TIME="$(get_app_build)"
    source /etc/os-release
    (
        cd "$pack_dir"
        mkdir -p "usr/bin" "DEBIAN"
        envsubst < "$package_control_template" > "DEBIAN/control"
        cp -a "$binary" "usr/bin"
        dpkg-deb --build . "$package"
    )
}

function get_app_version() {
    "$binary" --version | grep -oP '\d+(\.\d+)+'
}

function get_app_build(){
    date +%s
}

function cleanup() {
    rm -rf "$source_dir" "$pack_dir"
}

trap cleanup exit

build
pack