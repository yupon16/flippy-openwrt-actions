#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - flippy DIY script for SW799 (RK3399)
#========================================================

set -e

echo "[INFO] Enter SW799 DIY script"

# 必须用正确 DTB 绑定格式
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

# SOC / BOARD 信息（可选）
SOC="rk3399"
BOARD="sw799"

# flippy 内部 rootfs 文件路径
OPENWRT_ARMSR="openwrt_packit/openwrt-armsr-armv8-generic-rootfs.tar.gz"

if [[ ! -f "${OPENWRT_ARMSR}" ]]; then
    echo "[ERROR] OPENWRT_ARMSR not found: ${OPENWRT_ARMSR}"
    exit 1
fi

echo "[INFO] Using rootfs: ${OPENWRT_ARMSR}"

# 交还给 flippy / packit
packit_build
