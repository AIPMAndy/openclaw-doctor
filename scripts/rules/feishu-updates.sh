#!/bin/bash

# 飞书开放平台更新检查规则
# 用于 openclaw doctor 诊断

check() {
    local monitor_script="$SCRIPT_DIR/../feishu-monitor.sh"
    local cache_dir="$HOME/.openclaw/cache/feishu-monitor"
    local log_file="$cache_dir/monitor.log"
    
    # 检查监控脚本是否存在
    if [ ! -f "$monitor_script" ]; then
        echo "❌ 飞书监控脚本不存在"
        return 1
    fi
    
    # 运行监控脚本
    bash "$monitor_script" > /dev/null 2>&1
    
    # 检查是否有更新
    if [ -f "$log_file" ]; then
        local recent_updates=$(tail -20 "$log_file" | grep "🔔 发现更新" | wc -l)
        if [ "$recent_updates" -gt 0 ]; then
            echo "🔔 发现 $recent_updates 个飞书开放平台更新"
            echo ""
            echo "最近更新："
            tail -20 "$log_file" | grep "🔔"
            echo ""
            echo "💡 建议："
            echo "   1. 查看完整日志: cat $log_file"
            echo "   2. 访问更新日志: https://open.feishu.cn/changelog"
            echo "   3. 检查 CLI 更新: https://github.com/larksuite/cli/releases"
            return 0
        else
            echo "✅ 飞书开放平台无新更新"
            return 0
        fi
    else
        echo "⚠️  首次运行飞书监控，已初始化缓存"
        return 0
    fi
}

fix() {
    echo "💡 飞书更新检查是信息性的，无需修复"
    echo ""
    echo "建议操作："
    echo "1. 定期运行: openclaw doctor --check feishu-updates"
    echo "2. 设置定时任务: 在 HEARTBEAT.md 中添加定期检查"
    echo "3. 手动运行监控: bash ~/.openclaw/skills/openclaw-doctor/scripts/feishu-monitor.sh"
}

# 规则元数据
RULE_NAME="飞书开放平台更新检查"
RULE_CATEGORY="monitoring"
RULE_SEVERITY="info"
RULE_DESCRIPTION="检查飞书 API、CLI 和文档的更新"
