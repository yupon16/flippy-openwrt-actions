#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - flippy DIY script for SW799 (RK3399)
#========================================================

set -e

# ✅ 强制使用绝对路径（避免任何路径歧义）
SCRIPT_DIR="/opt/openwrt_packit"
cd "$SCRIPT_DIR"

# ✅ 确保 public_funcs 可读
if [[ ! -f "public_funcs" ]]; then
    echo "[ERROR] public_funcs not found in $SCRIPT_DIR"
    exit 1
fi

# ✅ 安全加载函数库
source ./public_funcs

echo "[INFO] Enter SW799 DIY script"

#--------------------------------------------------
# ✅ DTB绑定（唯一核心配置）
#--------------------------------------------------
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

#--------------------------------------------------
# 执行打包
#--------------------------------------------------
packit_build
