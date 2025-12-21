#!/usr/bin/env bash
set -e
echo "[INFO] Enter SW799 DIY script"

# 自定义 DTB
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

# 检查 rootfs
if [[ -z "${OPENWRT_ARMSR}" || ! -f "${OPENWRT_ARMSR}" ]]; then
    echo "[ERROR] OPENWRT_ARMSR not set or file missing"
    exit 1
fi

echo "[INFO] Using rootfs: ${OPENWRT_ARMSR}"

# 可选操作
if [[ "${ENABLE_WIFI}" != "true" ]]; then
    echo "[INFO] Disabling WiFi"
    rm -f etc/config/wireless 2>/dev/null || true
fi
