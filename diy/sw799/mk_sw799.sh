#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - flippy DIY script for SW799 (RK3399)
#========================================================

set -e

echo "[INFO] Enter SW799 DIY script"

# 必须：RK3399 DTB 绑定格式
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

SOC="rk3399"
BOARD="sw799"

# flippy 已经把 rootfs 复制到 openwrt_packit 目录
OPENWRT_ARMSR="openwrt-armsr-armv8-generic-rootfs.tar.gz"

if [[ ! -f "${OPENWRT_ARMSR}" ]]; then
    echo "[ERROR] rootfs not found: ${OPENWRT_ARMSR}"
    ls -lh
    exit 1
fi

echo "[INFO] Using rootfs: ${OPENWRT_ARMSR}"

# 交给 packit
packit_build
