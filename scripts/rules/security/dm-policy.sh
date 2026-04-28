#!/bin/bash
# DM 策略安全检查规则
# 检查各通道的 DM 策略配置，防止未授权访问

check_dm_policy() {
    local config_file="$HOME/.openclaw/gateway.config.json"
    local issues=()
    local warnings=()
    
    echo "🔒 检查 DM 策略安全配置..."
    
    if [ ! -f "$config_file" ]; then
        issues+=("❌ 配置文件不存在: $config_file")
        return 1
    fi
    
    # 检查全局 dmPolicy
    local global_dm_policy=$(jq -r '.agents.defaults.dmPolicy // "null"' "$config_file" 2>/dev/null)
    
    if [ "$global_dm_policy" = "open" ]; then
        warnings+=("⚠️  全局 dmPolicy 设置为 'open'，允许任何人发送 DM")
        warnings+=("   建议：设置为 'pairing' 以提高安全性")
    fi
    
    # 检查各通道的 DM 策略
    local channels=("telegram" "whatsapp" "signal" "discord" "slack" "teams")
    
    for channel in "${channels[@]}"; do
        # 检查新格式配置
        local channel_dm_policy=$(jq -r ".channels.${channel}.dmPolicy // \"null\"" "$config_file" 2>/dev/null)
        
        # 检查旧格式配置（向后兼容）
        if [ "$channel_dm_policy" = "null" ]; then
            channel_dm_policy=$(jq -r ".channels.${channel}.dm.policy // \"null\"" "$config_file" 2>/dev/null)
        fi
        
        if [ "$channel_dm_policy" = "open" ]; then
            # 检查是否有 allowFrom 白名单
            local allow_from=$(jq -r ".channels.${channel}.allowFrom // .channels.${channel}.dm.allowFrom // \"null\"" "$config_file" 2>/dev/null)
            
            if echo "$allow_from" | grep -q '"*"'; then
                issues+=("❌ ${channel}: dmPolicy='open' 且 allowFrom 包含 '*'，完全开放！")
                issues+=("   风险：任何人都可以向你的 bot 发送消息")
                issues+=("   修复：移除 '*' 或设置 dmPolicy='pairing'")
            else
                warnings+=("⚠️  ${channel}: dmPolicy='open'，建议使用 'pairing' 模式")
            fi
        elif [ "$channel_dm_policy" = "null" ] || [ "$channel_dm_policy" = "pairing" ]; then
            echo "✅ ${channel}: DM 策略安全（pairing 或未配置，默认安全）"
        fi
    done
    
    # 检查 Feishu 配置
    local feishu_dm_policy=$(jq -r '.channels.feishu.dmPolicy // "null"' "$config_file" 2>/dev/null)
    if [ "$feishu_dm_policy" = "open" ]; then
        warnings+=("⚠️  feishu: dmPolicy='open'，建议使用 'pairing' 模式")
    fi
    
    # 输出结果
    if [ ${#issues[@]} -gt 0 ]; then
        echo ""
        echo "🚨 发现安全问题："
        printf '%s\n' "${issues[@]}"
        echo ""
        echo "💡 修复建议："
        echo "   1. 运行: openclaw doctor --fix-dm-policy"
        echo "   2. 或手动编辑配置文件，设置 dmPolicy='pairing'"
        echo "   3. 移除 allowFrom 中的 '*' 通配符"
        return 1
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  安全警告："
        printf '%s\n' "${warnings[@]}"
        echo ""
        echo "💡 建议："
        echo "   考虑将 dmPolicy 设置为 'pairing' 以提高安全性"
        return 0
    fi
    
    echo "✅ DM 策略配置安全"
    return 0
}

# 自动修复 DM 策略
fix_dm_policy() {
    local config_file="$HOME/.openclaw/gateway.config.json"
    local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    echo "🔧 修复 DM 策略配置..."
    
    # 备份配置文件
    cp "$config_file" "$backup_file"
    echo "✅ 已备份配置文件: $backup_file"
    
    # 使用 jq 修复配置
    local temp_file=$(mktemp)
    
    jq '
        # 修复全局 dmPolicy
        if .agents.defaults.dmPolicy == "open" then
            .agents.defaults.dmPolicy = "pairing"
        else . end |
        
        # 修复各通道的 dmPolicy
        if .channels.telegram.dmPolicy == "open" then
            .channels.telegram.dmPolicy = "pairing"
        else . end |
        if .channels.whatsapp.dmPolicy == "open" then
            .channels.whatsapp.dmPolicy = "pairing"
        else . end |
        if .channels.signal.dmPolicy == "open" then
            .channels.signal.dmPolicy = "pairing"
        else . end |
        if .channels.discord.dmPolicy == "open" then
            .channels.discord.dmPolicy = "pairing"
        else . end |
        if .channels.slack.dmPolicy == "open" then
            .channels.slack.dmPolicy = "pairing"
        else . end |
        if .channels.teams.dmPolicy == "open" then
            .channels.teams.dmPolicy = "pairing"
        else . end |
        if .channels.feishu.dmPolicy == "open" then
            .channels.feishu.dmPolicy = "pairing"
        else . end |
        
        # 移除 allowFrom 中的 "*"
        if .channels.telegram.allowFrom then
            .channels.telegram.allowFrom = [.channels.telegram.allowFrom[] | select(. != "*")]
        else . end |
        if .channels.whatsapp.allowFrom then
            .channels.whatsapp.allowFrom = [.channels.whatsapp.allowFrom[] | select(. != "*")]
        else . end |
        if .channels.discord.allowFrom then
            .channels.discord.allowFrom = [.channels.discord.allowFrom[] | select(. != "*")]
        else . end |
        if .channels.slack.allowFrom then
            .channels.slack.allowFrom = [.channels.slack.allowFrom[] | select(. != "*")]
        else . end
    ' "$config_file" > "$temp_file"
    
    if [ $? -eq 0 ]; then
        mv "$temp_file" "$config_file"
        echo "✅ DM 策略已修复"
        echo "📝 更改内容："
        echo "   - 所有 dmPolicy='open' 已改为 'pairing'"
        echo "   - 已移除 allowFrom 中的 '*' 通配符"
        echo ""
        echo "⚠️  需要重启 Gateway 使配置生效："
        echo "   openclaw gateway restart"
        return 0
    else
        rm -f "$temp_file"
        echo "❌ 修复失败，配置文件未更改"
        return 1
    fi
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ "$1" = "--fix" ]; then
        fix_dm_policy
    else
        check_dm_policy
    fi
fi
