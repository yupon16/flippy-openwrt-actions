#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - DIY packaging script for SW799
#========================================================

set -euo pipefail

#----------------------------------------
# Variables from workflow environment
#----------------------------------------
OPENWRT_ROOTFS="${OPENWRT_ARMSR:-}"
KERNEL_VERSION="${KERNEL_VER:-6.6.68}"
ENABLE_WIFI="${ENABLE_WIFI:-false}"

# Optional RK3399 DTB customization
RK3399_BOARD="${CUSTOMIZE_RK3399%%:*}"
RK3399_DTB="${CUSTOMIZE_RK3399##*:}"

# Output directories
WORKDIR="/opt/openwrt_packit"
OUTPUTDIR="${WORKDIR}/output"

#----------------------------------------
# Functions
#----------------------------------------
error() {
    echo "[ERROR] $1"
    exit 1
}

info() {
    echo "[INFO] $1"
}

download_kernel() {
    local kernel_tag="$1"
    local kernel_ver="$2"
    local dest_dir="$3"

    mkdir -p "$dest_dir"
    local kernel_tar="${dest_dir}/boot-${kernel_ver}.tar.gz"
    if [[ ! -f "$kernel_tar" ]]; then
        info "Downloading kernel ${kernel_ver}..."
        curl -L -o "$kernel_tar" \
          "https://github.com/breakingbadboy/OpenWrt/releases/download/kernel_${kernel_tag}/boot-${kernel_ver}.tar.gz"
    fi
    tar -xf "$kernel_tar" -C "$dest_dir"
}

prepare_rootfs() {
    if [[ -z "$OPENWRT_ROOTFS" || ! -f "$OPENWRT_ROOTFS" ]]; then
        error "OPENWRT_ARMSR not set or file missing"
    fi
    info "Using rootfs: $OPENWRT_ROOTFS"
    mkdir -p "$WORKDIR/rootfs"
    tar -xzf "$OPENWRT_ROOTFS" -C "$WORKDIR/rootfs"
}

build_openwrt_image() {
    mkdir -p "$OUTPUTDIR"
    cd "$WORKDIR/rootfs"

    # Customize default IP
    sed -i "s/\${ipaddr:-\"192.168.1.1\"}/\${ipaddr:-\"192.168.1.1\"}/" bin/config_generate

    # Copy kernel
    KERNEL_DIR="$WORKDIR/kernel"
    mkdir -p "$KERNEL_DIR"
    download_kernel "stable" "$KERNEL_VERSION" "$KERNEL_DIR"
    cp -r "$KERNEL_DIR"/* "$WORKDIR/rootfs/boot/"

    # Apply RK3399 DTB if provided
    if [[ -n "$RK3399_BOARD" && -n "$RK3399_DTB" ]]; then
        info "Applying custom DTB for ${RK3399_BOARD}: ${RK3399_DTB}"
        cp "$WORKDIR/kernel/${RK3399_DTB}" "$WORKDIR/rootfs/boot/$(basename $RK3399_DTB)"
    fi

    # Disable WiFi if requested
    if [[ "$ENABLE_WIFI" != "true" ]]; then
        info "Disabling WiFi"
        rm -f etc/config/wireless
    fi

    # Create compressed image
    IMG_NAME="openwrt-sw799-${KERNEL_VERSION}.img"
    cd "$WORKDIR/rootfs"
    tar -czf "$OUTPUTDIR/$IMG_NAME" .
    info "OpenWrt DIY image created: $OUTPUTDIR/$IMG_NAME"
}

#----------------------------------------
# Main
#----------------------------------------
info "Starting DIY build for SW799..."
prepare_rootfs
build_openwrt_image
info "DIY build completed successfully."
