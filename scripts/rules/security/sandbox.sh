#!/bin/bash
# Sandbox 配置验证规则
# 检查 Sandbox 配置，确保非主会话的安全隔离

check_sandbox() {
    local config_file="$HOME/.openclaw/gateway.config.json"
    local issues=()
    local warnings=()
    
    echo "🏖️  检查 Sandbox 配置..."
    
    if [ ! -f "$config_file" ]; then
        issues+=("❌ 配置文件不存在: $config_file")
        return 1
    fi
    
    # 检查全局 sandbox 模式
    local sandbox_mode=$(jq -r '.agents.defaults.sandbox.mode // "null"' "$config_file" 2>/dev/null)
    
    if [ "$sandbox_mode" = "null" ] || [ "$sandbox_mode" = "off" ]; then
        warnings+=("⚠️  Sandbox 未启用（mode='$sandbox_mode'）")
        warnings+=("   风险：所有会话（包括群聊）都在主机上运行，具有完全权限")
        warnings+=("   建议：设置 agents.defaults.sandbox.mode='non-main'")
        warnings+=("   这样只有主会话在主机运行，其他会话在沙箱中隔离")
    elif [ "$sandbox_mode" = "non-main" ]; then
        echo "✅ Sandbox 模式: non-main（推荐配置）"
        echo "   主会话在主机运行，其他会话在沙箱隔离"
    elif [ "$sandbox_mode" = "all" ]; then
        echo "✅ Sandbox 模式: all（最高安全级别）"
        echo "   所有会话都在沙箱中运行"
    else
        warnings+=("⚠️  未知的 sandbox 模式: $sandbox_mode")
    fi
    
    # 检查 sandbox 后端
    local sandbox_backend=$(jq -r '.agents.defaults.sandbox.backend // "docker"' "$config_file" 2>/dev/null)
    echo "📦 Sandbox 后端: $sandbox_backend"
    
    # 验证后端可用性
    case "$sandbox_backend" in
        "docker")
            if command -v docker &> /dev/null; then
                if docker info &> /dev/null; then
                    echo "✅ Docker 后端可用"
                else
                    issues+=("❌ Docker 后端配置但 Docker daemon 未运行")
                    issues+=("   修复：启动 Docker 或切换到其他后端")
                fi
            else
                issues+=("❌ Docker 后端配置但 Docker 未安装")
                issues+=("   修复：安装 Docker 或切换到 SSH/OpenShell 后端")
            fi
            ;;
        "ssh")
            echo "ℹ️  SSH 后端配置（需要远程 SSH 服务器）"
            local ssh_host=$(jq -r '.agents.defaults.sandbox.ssh.host // "null"' "$config_file" 2>/dev/null)
            if [ "$ssh_host" = "null" ]; then
                issues+=("❌ SSH 后端配置但未指定 ssh.host")
            else
                echo "   SSH 主机: $ssh_host"
            fi
            ;;
        "openshell")
            echo "ℹ️  OpenShell 后端配置"
            ;;
        *)
            warnings+=("⚠️  未知的 sandbox 后端: $sandbox_backend")
            ;;
    esac
    
    # 检查工具权限配置
    echo ""
    echo "🔧 检查沙箱工具权限..."
    
    local allowed_tools=$(jq -r '.agents.defaults.sandbox.allowedTools // [] | join(", ")' "$config_file" 2>/dev/null)
    local denied_tools=$(jq -r '.agents.defaults.sandbox.deniedTools // [] | join(", ")' "$config_file" 2>/dev/null)
    
    if [ -n "$allowed_tools" ]; then
        echo "✅ 允许的工具: $allowed_tools"
    fi
    
    if [ -n "$denied_tools" ]; then
        echo "✅ 禁止的工具: $denied_tools"
    fi
    
    # 检查危险工具是否被允许
    local dangerous_tools=("browser" "canvas" "nodes" "cron" "gateway")
    for tool in "${dangerous_tools[@]}"; do
        if echo "$allowed_tools" | grep -q "$tool"; then
            warnings+=("⚠️  危险工具 '$tool' 在沙箱中被允许")
            warnings+=("   建议：将其添加到 deniedTools 列表")
        fi
    done
    
    # 检查是否有自定义 agent 配置覆盖了全局 sandbox
    local custom_agents=$(jq -r '.agents | to_entries[] | select(.key != "defaults") | .key' "$config_file" 2>/dev/null)
    if [ -n "$custom_agents" ]; then
        echo ""
        echo "👥 检查自定义 Agent 配置..."
        while IFS= read -r agent; do
            local agent_sandbox=$(jq -r ".agents.${agent}.sandbox.mode // \"inherit\"" "$config_file" 2>/dev/null)
            if [ "$agent_sandbox" != "inherit" ]; then
                echo "   Agent '$agent': sandbox.mode=$agent_sandbox"
                if [ "$agent_sandbox" = "off" ]; then
                    warnings+=("⚠️  Agent '$agent' 禁用了 sandbox")
                fi
            fi
        done <<< "$custom_agents"
    fi
    
    # 输出结果
    if [ ${#issues[@]} -gt 0 ]; then
        echo ""
        echo "🚨 发现问题："
        printf '%s\n' "${issues[@]}"
        echo ""
        echo "💡 修复建议："
        echo "   1. 运行: openclaw doctor --fix-sandbox"
        echo "   2. 或手动编辑配置文件"
        return 1
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  安全警告："
        printf '%s\n' "${warnings[@]}"
        return 0
    fi
    
    echo ""
    echo "✅ Sandbox 配置安全"
    return 0
}

# 自动修复 Sandbox 配置
fix_sandbox() {
    local config_file="$HOME/.openclaw/gateway.config.json"
    local backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    echo "🔧 修复 Sandbox 配置..."
    
    # 备份配置文件
    cp "$config_file" "$backup_file"
    echo "✅ 已备份配置文件: $backup_file"
    
    # 使用 jq 修复配置
    local temp_file=$(mktemp)
    
    jq '
        # 设置 sandbox 模式为 non-main
        .agents.defaults.sandbox.mode = "non-main" |
        
        # 设置推荐的允许工具
        .agents.defaults.sandbox.allowedTools = [
            "bash", "process", "read", "write", "edit",
            "sessions_list", "sessions_history", "sessions_send", "sessions_spawn"
        ] |
        
        # 设置推荐的禁止工具
        .agents.defaults.sandbox.deniedTools = [
            "browser", "canvas", "nodes", "cron", "discord", "gateway"
        ]
    ' "$config_file" > "$temp_file"
    
    if [ $? -eq 0 ]; then
        mv "$temp_file" "$config_file"
        echo "✅ Sandbox 配置已修复"
        echo "📝 更改内容："
        echo "   - sandbox.mode 设置为 'non-main'"
        echo "   - 配置了推荐的工具权限列表"
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
        fix_sandbox
    else
        check_sandbox
    fi
fi
