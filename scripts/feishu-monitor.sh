#!/bin/bash

# 飞书开放平台监控脚本
# 用于定期检查飞书 API、CLI 和文档的更新

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$HOME/.openclaw/cache/feishu-monitor"
LOG_FILE="$CACHE_DIR/monitor.log"

# 创建缓存目录
mkdir -p "$CACHE_DIR"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 检查 URL 是否有更新
check_url_update() {
    local url="$1"
    local name="$2"
    local cache_file="$CACHE_DIR/${name}.cache"
    
    log "检查 $name: $url"
    
    # 获取当前内容
    local current_content=$(curl -s "$url" | md5)
    
    # 如果缓存文件存在，比较内容
    if [ -f "$cache_file" ]; then
        local cached_content=$(cat "$cache_file")
        if [ "$current_content" != "$cached_content" ]; then
            log "🔔 发现更新: $name"
            echo "$current_content" > "$cache_file"
            return 0  # 有更新
        else
            log "✓ 无更新: $name"
            return 1  # 无更新
        fi
    else
        # 首次检查，保存缓存
        echo "$current_content" > "$cache_file"
        log "✓ 首次检查: $name (已缓存)"
        return 1
    fi
}

# 检查 GitHub releases
check_github_releases() {
    local repo="$1"
    local name="$2"
    local cache_file="$CACHE_DIR/${name}-releases.cache"
    
    log "检查 GitHub Releases: $repo"
    
    # 获取最新 release
    local latest_release=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
    
    if [ -z "$latest_release" ]; then
        log "⚠️  无法获取 $name 的最新版本"
        return 1
    fi
    
    # 如果缓存文件存在，比较版本
    if [ -f "$cache_file" ]; then
        local cached_release=$(cat "$cache_file")
        if [ "$latest_release" != "$cached_release" ]; then
            log "🔔 发现新版本: $name $latest_release (旧版本: $cached_release)"
            echo "$latest_release" > "$cache_file"
            return 0  # 有更新
        else
            log "✓ 无新版本: $name $latest_release"
            return 1  # 无更新
        fi
    else
        # 首次检查，保存缓存
        echo "$latest_release" > "$cache_file"
        log "✓ 首次检查: $name $latest_release (已缓存)"
        return 1
    fi
}

# 主监控逻辑
main() {
    log "========== 开始飞书开放平台监控 =========="
    
    local has_updates=false
    
    # 1. 检查 API 更新日志
    if check_url_update "https://open.feishu.cn/changelog" "api-changelog"; then
        has_updates=true
    fi
    
    # 2. 检查飞书 CLI GitHub releases
    if check_github_releases "larksuite/cli" "lark-cli"; then
        has_updates=true
    fi
    
    # 3. 检查开放平台文档更新
    if check_url_update "https://open.feishu.cn/document/home/index" "platform-docs"; then
        has_updates=true
    fi
    
    # 4. 检查平台公告
    if check_url_update "https://open.feishu.cn/document/platform-notices/platform-updates-/catalogue-update-release-notes" "platform-notices"; then
        has_updates=true
    fi
    
    if [ "$has_updates" = true ]; then
        log "========== 发现更新！请查看详情 =========="
        echo "发现飞书开放平台更新，请查看日志: $LOG_FILE"
    else
        log "========== 无更新 =========="
    fi
    
    log ""
}

# 执行主函数
main "$@"
