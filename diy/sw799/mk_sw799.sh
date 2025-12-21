#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - Minimal DIY script for SW799 (RK3399)
#========================================================

set -e

echo "[INFO] Enter SW799 DIY script"

#--------------------------------------------------
# 必须：声明 RK3399 + 板级 DTB 绑定
# 格式：board_name:dtb_filename
#--------------------------------------------------
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

#--------------------------------------------------
# 可选声明（用于日志识别）
#--------------------------------------------------
SOC="rk3399"
BOARD="sw799"

#--------------------------------------------------
# Rootfs 由 flippy 自动复制到工作目录
# 这里只做存在性确认（不做路径假设）
#--------------------------------------------------
if [[ -z "${OPENWRT_ARMSR}" ]]; then
    echo "[ERROR] OPENWRT_ARMSR not set"
    exit 1
fi

if [[ ! -f "${OPENWRT_ARMSR}" ]]; then
    echo "[ERROR] OPENWRT_ARMSR file not found: ${OPENWRT_ARMSR}"
    exit 1
fi

echo "[INFO] Using rootfs: ${OPENWRT_ARMSR}"
echo "[INFO] SW799 DIY script finished"

#--------------------------------------------------
# 注意：
# 不要调用 packit_build
# packit 会在脚本返回后自动继续
#--------------------------------------------------
exit 0
