#!/bin/bash
# ==========================================================
# DIY build script for rk3399 sw799 (eMMC)
# Board: bozz sw799
# DTB: rk3399-bozz-sw799.dtb
# Strategy: DTB convergence, no u-boot modification
# ==========================================================

set -e

echo "================================================="
echo " DIY build: rk3399 sw799"
echo "================================================="

# --------------------------------------------------
# 基本变量（只定义一次）
# --------------------------------------------------
BOARD_NAME="sw799"
SOC_FAMILY="rk3399"
DTB_FILE="rk3399-bozz-sw799.dtb"

VMLINUX_IMAGE="Image"
BOOT_DIR="${WORK_DIR}/boot"
DTB_SRC_DIR="${GITHUB_WORKSPACE}/files/boot/dtb"
DTB_DST_DIR="${BOOT_DIR}/dtb"

# --------------------------------------------------
# 关键校验 1：DTB 是否存在
# --------------------------------------------------
if [ ! -f "${DTB_SRC_DIR}/${DTB_FILE}" ]; then
  echo "[FATAL] DTB not found: ${DTB_SRC_DIR}/${DTB_FILE}"
  exit 1
fi

# --------------------------------------------------
# 创建基础目录
# --------------------------------------------------
mkdir -p "${BOOT_DIR}"
mkdir -p "${DTB_DST_DIR}"

# --------------------------------------------------
# 拷贝内核
# flippy 已提前准备好内核 Image
# --------------------------------------------------
if [ ! -f "${VMLINUX_IMAGE}" ]; then
  echo "[INFO] Kernel Image not found in current dir, try /opt/kernel"
  cp -v /opt/kernel/${VMLINUX_IMAGE} "${BOOT_DIR}/" || {
    echo "[FATAL] Kernel Image not found"
    exit 1
  }
else
  cp -v "${VMLINUX_IMAGE}" "${BOOT_DIR}/"
fi

# --------------------------------------------------
# 拷贝 DTB（唯一 DTB）
# --------------------------------------------------
echo "[INFO] Installing DTB: ${DTB_FILE}"
cp -v "${DTB_SRC_DIR}/${DTB_FILE}" "${DTB_DST_DIR}/"

# --------------------------------------------------
# 关键动作：收敛 DTB 选择
# --------------------------------------------------
cd "${BOOT_DIR}"

# 清理任何历史 dtb 链接（防止 flippy 残留）
rm -f dtb.img dtb/*.dtb 2>/dev/null || true

# 只保留 sw799 DTB
cp -v "${DTB_DST_DIR}/${DTB_FILE}" "./dtb.img"

# --------------------------------------------------
# 写入 flippy 识别用的 board 信息
# --------------------------------------------------
cat > board.txt <<EOF
BOARD=${BOARD_NAME}
SOC=${SOC_FAMILY}
DTB=${DTB_FILE}
EOF

# --------------------------------------------------
# 网络默认配置（可选，但建议明确）
# --------------------------------------------------
mkdir -p "${WORK_DIR}/etc/config"

cat > "${WORK_DIR}/etc/config/network" <<'EOF'
config interface 'loopback'
        option device 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config interface 'lan'
        option device 'eth0'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
EOF

# --------------------------------------------------
# 标记完成
# --------------------------------------------------
echo "[SUCCESS] sw799 image prepared with single DTB"
echo "-------------------------------------------------"
ls -lh "${BOOT_DIR}"
