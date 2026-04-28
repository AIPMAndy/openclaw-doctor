#!/bin/bash
# Pairing 状态诊断规则
# 检查 Pairing 配置和已配对设备状态

check_pairing() {
    local config_file="$HOME/.openclaw/gateway.config.json"
    local pairing_store="$HOME/.openclaw/pairing-store.json"
    local issues=()
    local warnings=()
    
    echo "🔐 检查 Pairing 配置和状态..."
    
    # 检查配置文件
    if [ ! -f "$config_file" ]; then
        issues+=("❌ 配置文件不存在: $config_file")
        return 1
    fi
    
    # 检查是否启用了 pairing 模式
    local has_pairing=false
    local channels=("telegram" "whatsapp" "signal" "discord" "slack" "teams" "feishu")
    
    for channel in "${channels[@]}"; do
        local dm_policy=$(jq -r ".channels.${channel}.dmPolicy // .channels.${channel}.dm.policy // \"null\"" "$config_file" 2>/dev/null)
        if [ "$dm_policy" = "pairing" ]; then
            has_pairing=true
            echo "✅ ${channel}: 已启用 pairing 模式"
        fi
    done
    
    if [ "$has_pairing" = false ]; then
        warnings+=("⚠️  未检测到任何通道启用 pairing 模式")
        warnings+=("   如果你使用 dmPolicy='open'，建议启用 pairing 以提高安全性")
    fi
    
    # 检查 pairing store
    if [ -f "$pairing_store" ]; then
        echo ""
        echo "📋 Pairing Store 状态："
        
        # 统计已配对设备数量
        local paired_count=$(jq -r 'length' "$pairing_store" 2>/dev/null || echo "0")
        echo "   已配对设备数量: $paired_count"
        
        if [ "$paired_count" -gt 0 ]; then
            echo ""
            echo "   已配对设备列表："
            jq -r 'to_entries[] | "   - \(.key): \(.value.channel) (\(.value.timestamp // "未知时间"))"' "$pairing_store" 2>/dev/null
        fi
        
        # 检查是否有过期的配对
        local now=$(date +%s)
        local expired=0
        
        while IFS= read -r line; do
            local timestamp=$(echo "$line" | jq -r '.value.timestamp // "0"' 2>/dev/null)
            if [ "$timestamp" != "0" ]; then
                local age=$((now - timestamp / 1000))
                if [ $age -gt 7776000 ]; then  # 90 天
                    ((expired++))
                fi
            fi
        done < <(jq -c 'to_entries[]' "$pairing_store" 2>/dev/null)
        
        if [ $expired -gt 0 ]; then
            warnings+=("⚠️  发现 $expired 个超过 90 天的配对记录")
            warnings+=("   建议：定期清理过期的配对记录")
            warnings+=("   命令：openclaw pairing list --expired")
        fi
    else
        if [ "$has_pairing" = true ]; then
            warnings+=("⚠️  已启用 pairing 模式，但 pairing store 不存在")
            warnings+=("   这是正常的，首次配对时会自动创建")
        fi
    fi
    
    # 检查 pairing 超时配置
    local pairing_timeout=$(jq -r '.pairing.timeoutMs // "null"' "$config_file" 2>/dev/null)
    if [ "$pairing_timeout" != "null" ]; then
        local timeout_minutes=$((pairing_timeout / 60000))
        if [ $timeout_minutes -lt 5 ]; then
            warnings+=("⚠️  Pairing 超时时间过短: ${timeout_minutes} 分钟")
            warnings+=("   建议：设置为至少 5 分钟")
        fi
    fi
    
    # 输出结果
    if [ ${#issues[@]} -gt 0 ]; then
        echo ""
        echo "🚨 发现问题："
        printf '%s\n' "${issues[@]}"
        return 1
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  警告："
        printf '%s\n' "${warnings[@]}"
        return 0
    fi
    
    echo ""
    echo "✅ Pairing 配置正常"
    return 0
}

# 清理过期的配对记录
clean_expired_pairing() {
    local pairing_store="$HOME/.openclaw/pairing-store.json"
    local backup_file="${pairing_store}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ ! -f "$pairing_store" ]; then
        echo "❌ Pairing store 不存在"
        return 1
    fi
    
    echo "🔧 清理过期的配对记录..."
    
    # 备份
    cp "$pairing_store" "$backup_file"
    echo "✅ 已备份: $backup_file"
    
    # 清理超过 90 天的记录
    local now=$(date +%s)
    local temp_file=$(mktemp)
    
    jq --arg now "$now" '
        with_entries(
            select(
                (.value.timestamp // 0) == 0 or
                (($now | tonumber) - (.value.timestamp / 1000)) < 7776000
            )
        )
    ' "$pairing_store" > "$temp_file"
    
    if [ $? -eq 0 ]; then
        local before=$(jq 'length' "$pairing_store")
        local after=$(jq 'length' "$temp_file")
        local removed=$((before - after))
        
        mv "$temp_file" "$pairing_store"
        echo "✅ 已清理 $removed 个过期配对记录"
        echo "   剩余配对: $after"
        return 0
    else
        rm -f "$temp_file"
        echo "❌ 清理失败"
        return 1
    fi
}

# 如果直接运行此脚本
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ "$1" = "--clean-expired" ]; then
        clean_expired_pairing
    else
        check_pairing
    fi
fi
