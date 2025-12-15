#!/bin/bash
echo "======= [自定义调试脚本] 开始 ======="
echo "1. 当前脚本路径: $0"
echo "2. 所有参数: $@"
echo "3. 关键环境变量:"
echo "   - PACKAGE_SOC: $PACKAGE_SOC"
echo "   - CUSTOMIZE_RK3399: $CUSTOMIZE_RK3399"
echo "   - WHOAMI: $WHOAMI"

# 进入打包脚本所在目录（通常已被上级脚本设置）
echo "4. 当前目录: $(pwd)"
echo "5. 目录内容:"
ls -la

# 重点：查找并检查 rk3399 打包脚本
echo "6. 查找打包脚本..."
MK_SCRIPT=$(find . -name "mk_rk3399*.sh" -type f | head -1)
if [ -n "$MK_SCRIPT" ]; then
    echo "   找到脚本: $MK_SCRIPT"
    echo "   脚本头部信息:"
    head -30 "$MK_SCRIPT"
    echo "   搜索 'CUSTOMIZE_RK3399' 处理逻辑:"
    grep -n -A2 -B2 "CUSTOMIZE_RK3399" "$MK_SCRIPT" || echo "      未找到相关逻辑。"
else
    echo "   错误：未找到 rk3399 打包脚本。"
fi

echo "======= [自定义调试脚本] 结束，继续原流程 ======="
# 此脚本执行完毕后，原打包流程会继续
