#!/usr/bin/env bash
#========================================================
# mk_sw799.sh - flippy DIY script for SW799 (RK3399)
#========================================================

set -e

# ✅ 强制进入脚本所在目录（避免路径问题）
cd "$(dirname "$0")"

# ✅ 安全加载函数库（带错误检查）
if [[ ! -f "public_funcs" ]]; then
    echo "[ERROR] public_funcs not found in $(pwd)"
    exit 1
fi
source ./public_funcs

echo "[INFO] Enter SW799 DIY script"

#--------------------------------------------------
# ✅ DTB绑定（唯一核心配置）
#--------------------------------------------------
CUSTOMIZE_RK3399="sw799:rk3399-bozz-sw799.dtb"

#--------------------------------------------------
# 执行打包（现在 packit_build 已定义）
#--------------------------------------------------
packit_build
