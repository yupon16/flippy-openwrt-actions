#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - SW799 DIY script for flippy
#========================================================

set -e

echo "[INFO] Enter SW799 DIY script"

#--------------------------------------------------
# ✅ 自定义 RK3399 DTB
# 格式：BOARD:DTB_FILE
#--------------------------------------------------
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

#--------------------------------------------------
# Rootfs 检查
#--------------------------------------------------
if [[ -z "${OPENWRT_ARMSR}" ]]; then
    echo "[ERROR] OPENWRT_ARMSR not set"
    exit 1
fi

echo "[INFO] Using rootfs: ${OPENWRT_ARMSR}"

#--------------------------------------------------
# 可放置自定义操作，例如：
# - 禁用 WiFi
# - 修改默认 IP
# - 添加初始化脚本
#--------------------------------------------------
if [[ "${ENABLE_WIFI}" != "true" ]]; then
    echo "[INFO] Disabling WiFi"
    rm -f etc/config/wireless 2>/dev/null || true
fi

# 注意：
# 不需要直接调用 packit_build，flippy Action 会在外层执行打包逻辑。
