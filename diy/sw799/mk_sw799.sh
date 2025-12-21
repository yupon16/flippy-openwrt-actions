#!/bin/bash
set -e

echo "[INFO] Enter SW799 DIY script"

# flippy 已经把 rootfs 拷贝到 openwrt_packit 目录
ROOTFS_FILE="openwrt-armsr-armv8-generic-rootfs.tar.gz"

if [[ ! -f "${ROOTFS_FILE}" ]]; then
    echo "Error: rootfs not found: ${ROOTFS_FILE}"
    exit 1
fi

echo "[INFO] Using rootfs: ${ROOTFS_FILE}"

# === 这里什么都不改，也能成功 ===
# 后续你要做的，只是在这里加：
# - 替换 DTB
# - 调整 boot.cmd / extlinux.conf
# - 复制 sw799 专用文件

echo "[INFO] SW799 DIY script finished"
