#!/bin/bash
echo "======= [自定义调试脚本] 开始执行 =======" >&2
echo "当前目录: $(pwd)" >&2

# 核心任务：找到并“劫持” mk_rk3399_generic.sh
TARGET_SCRIPT=$(find . -type f -name "mk_rk3399_generic.sh" | head -1)

if [ -z "$TARGET_SCRIPT" ]; then
    echo "错误：未找到 mk_rk3399_generic.sh，正在列出所有脚本..." >&2
    find . -type f -name "*.sh" | head -20 >&2
    exit 0 # 不要阻塞原流程
fi

echo "找到目标脚本: $TARGET_SCRIPT" >&2
echo "环境变量 CUSTOMIZE_RK3399 = $CUSTOMIZE_RK3399" >&2

# 备份原脚本
cp "$TARGET_SCRIPT" "${TARGET_SCRIPT}.backup"
echo "已备份原脚本。" >&2

# 修改原脚本，在关键位置插入调试信息
# 策略：在脚本开头部分，处理参数之前，添加我们的调试代码
sed -i '/^[[:space:]]*#/!{/^[[:space:]]*$/!{/for board_fdt in/,/done/!p}}' "$TARGET_SCRIPT" # 这行仅为示意，实际用下面的复杂命令

# 更可靠的方法：直接使用awk在脚本开始后插入一大段调试代码
awk -v customize="$CUSTOMIZE_RK3399" '
BEGIN { inserted=0 }
{
    print $0
    if (!inserted && /^[[:space:]]*#/ && /Script/) {
        print ""
        print "# ====== 调试注入开始 ====="
        print "echo \"[DEBUG] 进入 mk_rk3399_generic.sh\""
        print "echo \"[DEBUG] 收到的参数: $@\""
        print "echo \"[DEBUG] CUSTOMIZE_RK3399 值: " customize "\""
        print "echo \"[DEBUG] 当前目录: $(pwd)\""
        print "echo \"[DEBUG] boot目录内容:\""
        print "ls -la boot/ 2>/dev/null || echo \"无boot目录\""
        print "echo \"[DEBUG] 开始解析 CUSTOMIZE_RK3399...\""
        print "# ====== 调试注入结束 ====="
        print ""
        inserted=1
    }
}
' "${TARGET_SCRIPT}.backup" > "$TARGET_SCRIPT"

chmod +x "$TARGET_SCRIPT"
echo "已向目标脚本注入调试代码。" >&2

# 关键：现在执行被我们修改过的脚本，并捕获其所有输出
echo "======= 开始执行被修改的打包脚本 =======" >&2
bash -x "$TARGET_SCRIPT" 2>&1 | tee /tmp/packit_debug.log
SCRIPT_EXIT_CODE=${PIPESTATUS[0]}
echo "======= 打包脚本执行结束，退出码: $SCRIPT_EXIT_CODE =======" >&2
echo "详细日志已保存至 /tmp/packit_debug.log，末尾内容如下：" >&2
tail -100 /tmp/packit_debug.log >&2

echo "======= [自定义调试脚本] 执行完毕 =======" >&2
exit 0
