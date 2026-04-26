#!/bin/bash
# OpenClaw Doctor - Advanced Diagnostic Script
# 高级诊断脚本 - 支持 JSON 输出和详细分析

set -e

VERSION="1.1.0"
OUTPUT_FORMAT="text"  # text or json

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            OUTPUT_FORMAT="json"
            shift
            ;;
        --version)
            echo "OpenClaw Doctor v$VERSION"
            exit 0
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --json       Output in JSON format"
            echo "  --version    Show version"
            echo "  --help       Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Initialize results
declare -A RESULTS
ISSUES_FOUND=0

# JSON output helper
json_escape() {
    echo "$1" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g'
}

# Check function with result tracking
check_item() {
    local name="$1"
    local status="$2"
    local message="$3"
    local severity="${4:-info}"  # info, warning, error
    
    RESULTS["${name}_status"]="$status"
    RESULTS["${name}_message"]="$message"
    RESULTS["${name}_severity"]="$severity"
    
    if [ "$status" = "fail" ]; then
        ((ISSUES_FOUND++))
    fi
}

# Text output
print_text_header() {
    echo "🔍 OpenClaw Doctor - Advanced Diagnostic v$VERSION"
    echo "=================================================="
    echo ""
}

print_text_result() {
    local name="$1"
    local status="${RESULTS[${name}_status]}"
    local message="${RESULTS[${name}_message]}"
    local severity="${RESULTS[${name}_severity]}"
    
    if [ "$status" = "pass" ]; then
        echo -e "${GREEN}✓${NC} $message"
    elif [ "$status" = "fail" ]; then
        if [ "$severity" = "error" ]; then
            echo -e "${RED}✗${NC} $message"
        else
            echo -e "${YELLOW}⚠${NC} $message"
        fi
    else
        echo -e "${BLUE}ℹ${NC} $message"
    fi
}

# JSON output
print_json_output() {
    echo "{"
    echo "  \"version\": \"$VERSION\","
    echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
    echo "  \"issues_found\": $ISSUES_FOUND,"
    echo "  \"checks\": {"
    
    local first=true
    for key in "${!RESULTS[@]}"; do
        if [[ $key == *"_status" ]]; then
            local name="${key%_status}"
            if [ "$first" = true ]; then
                first=false
            else
                echo ","
            fi
            echo -n "    \"$name\": {"
            echo -n "\"status\": \"${RESULTS[${name}_status]}\", "
            echo -n "\"message\": \"$(json_escape "${RESULTS[${name}_message]}")\", "
            echo -n "\"severity\": \"${RESULTS[${name}_severity]}\""
            echo -n "}"
        fi
    done
    
    echo ""
    echo "  }"
    echo "}"
}

# Start diagnostics
if [ "$OUTPUT_FORMAT" = "text" ]; then
    print_text_header
fi

# 1. Check Gateway process
GATEWAY_RUNNING=false
if ps aux | grep -v grep | grep openclaw-gateway > /dev/null; then
    GATEWAY_RUNNING=true
    GATEWAY_PID=$(ps aux | grep -v grep | grep openclaw-gateway | awk '{print $2}' | head -1)
    GATEWAY_CPU=$(ps aux | grep -v grep | grep openclaw-gateway | awk '{print $3}' | head -1)
    GATEWAY_MEM=$(ps aux | grep -v grep | grep openclaw-gateway | awk '{print $4}' | head -1)
    check_item "gateway_process" "pass" "Gateway is running (PID: $GATEWAY_PID, CPU: ${GATEWAY_CPU}%, MEM: ${GATEWAY_MEM}%)" "info"
else
    check_item "gateway_process" "fail" "Gateway is NOT running" "error"
fi

# 2. Check port
if lsof -i :18789 > /dev/null 2>&1; then
    PORT_OWNER=$(lsof -i :18789 | tail -n +2 | awk '{print $1}' | head -1)
    check_item "port_18789" "pass" "Port 18789 is in use by $PORT_OWNER" "info"
else
    check_item "port_18789" "fail" "Port 18789 is not in use" "warning"
fi

# 3. Check config file
if [ -f ~/.openclaw/openclaw.json ]; then
    PERMS=$(ls -l ~/.openclaw/openclaw.json | awk '{print $1}')
    if [ "$PERMS" = "-rw-------" ]; then
        check_item "config_permissions" "pass" "Config file permissions are correct (600)" "info"
    else
        check_item "config_permissions" "fail" "Config file permissions are incorrect: $PERMS (should be 600)" "error"
    fi
    
    # Check config validity
    if command -v jq > /dev/null 2>&1; then
        if jq empty ~/.openclaw/openclaw.json 2>/dev/null; then
            check_item "config_validity" "pass" "Config file is valid JSON" "info"
            
            # Check for required Feishu fields
            if jq -e '.channels.feishu' ~/.openclaw/openclaw.json > /dev/null 2>&1; then
                MISSING_FIELDS=""
                for field in appId appSecret verificationToken encryptKey connectionMode; do
                    if ! jq -e ".channels.feishu.accounts | to_entries[0].value.$field" ~/.openclaw/openclaw.json > /dev/null 2>&1; then
                        MISSING_FIELDS="$MISSING_FIELDS $field"
                    fi
                done
                
                if [ -z "$MISSING_FIELDS" ]; then
                    check_item "feishu_config" "pass" "Feishu config has all required fields" "info"
                else
                    check_item "feishu_config" "fail" "Feishu config missing fields:$MISSING_FIELDS" "error"
                fi
            fi
        else
            check_item "config_validity" "fail" "Config file is invalid JSON" "error"
        fi
    fi
else
    check_item "config_file" "fail" "Config file not found at ~/.openclaw/openclaw.json" "error"
fi

# 4. Check for multiple Gateway instances
GATEWAY_COUNT=$(ps aux | grep -v grep | grep openclaw-gateway | wc -l | tr -d ' ')
if [ "$GATEWAY_COUNT" -gt 1 ]; then
    check_item "multiple_instances" "fail" "Multiple Gateway instances detected ($GATEWAY_COUNT)" "error"
elif [ "$GATEWAY_COUNT" -eq 1 ]; then
    check_item "multiple_instances" "pass" "Single Gateway instance running" "info"
else
    check_item "multiple_instances" "info" "No Gateway instances running" "info"
fi

# 5. Check node_modules conflict
if [ -d ~/node_modules ]; then
    check_item "node_modules_conflict" "fail" "~/node_modules exists (may cause npm conflicts)" "warning"
else
    check_item "node_modules_conflict" "pass" "No ~/node_modules found" "info"
fi

# 6. Check dependency directory
if [ -d ~/.openclaw/plugin-runtime-deps ]; then
    DEPS_SIZE=$(du -sh ~/.openclaw/plugin-runtime-deps 2>/dev/null | awk '{print $1}')
    check_item "plugin_deps" "pass" "Plugin dependencies directory exists (size: $DEPS_SIZE)" "info"
    
    # Check for lock files
    if [ -d ~/.openclaw/plugin-runtime-deps/.locks ]; then
        LOCK_COUNT=$(find ~/.openclaw/plugin-runtime-deps/.locks -type f 2>/dev/null | wc -l | tr -d ' ')
        if [ "$LOCK_COUNT" -gt 0 ]; then
            check_item "dependency_locks" "fail" "Found $LOCK_COUNT dependency lock files (may indicate stale locks)" "warning"
        else
            check_item "dependency_locks" "pass" "No stale dependency locks" "info"
        fi
    fi
else
    check_item "plugin_deps" "info" "Plugin dependencies directory not found" "info"
fi

# 7. Check recent logs
LOG_FILE="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
if [ -f "$LOG_FILE" ]; then
    ERROR_COUNT=$(grep -c -i "error" "$LOG_FILE" 2>/dev/null || echo "0")
    RESTART_COUNT=$(grep -c "auto-restart" "$LOG_FILE" 2>/dev/null || echo "0")
    
    if [ "$ERROR_COUNT" -gt 10 ]; then
        check_item "log_errors" "fail" "High error count in logs: $ERROR_COUNT errors today" "warning"
    elif [ "$ERROR_COUNT" -gt 0 ]; then
        check_item "log_errors" "info" "Found $ERROR_COUNT errors in today's logs" "info"
    else
        check_item "log_errors" "pass" "No errors in today's logs" "info"
    fi
    
    if [ "$RESTART_COUNT" -gt 5 ]; then
        check_item "auto_restarts" "fail" "Excessive auto-restarts detected: $RESTART_COUNT times today" "error"
    elif [ "$RESTART_COUNT" -gt 0 ]; then
        check_item "auto_restarts" "fail" "Auto-restarts detected: $RESTART_COUNT times today" "warning"
    else
        check_item "auto_restarts" "pass" "No auto-restarts detected" "info"
    fi
else
    check_item "log_file" "info" "Log file not found for today" "info"
fi

# 8. Check disk space
DISK_USAGE=$(df -h ~ | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    check_item "disk_space" "fail" "Disk usage is critical: ${DISK_USAGE}%" "error"
elif [ "$DISK_USAGE" -gt 80 ]; then
    check_item "disk_space" "fail" "Disk usage is high: ${DISK_USAGE}%" "warning"
else
    check_item "disk_space" "pass" "Disk usage is normal: ${DISK_USAGE}%" "info"
fi

# 9. Check Node.js version
if command -v node > /dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    check_item "nodejs" "pass" "Node.js installed: $NODE_VERSION" "info"
else
    check_item "nodejs" "fail" "Node.js not found" "error"
fi

# 10. Check npm version
if command -v npm > /dev/null 2>&1; then
    NPM_VERSION=$(npm --version)
    check_item "npm" "pass" "npm installed: v$NPM_VERSION" "info"
else
    check_item "npm" "fail" "npm not found" "error"
fi

# Output results
if [ "$OUTPUT_FORMAT" = "json" ]; then
    print_json_output
else
    echo ""
    echo "1️⃣  Gateway Process"
    print_text_result "gateway_process"
    
    echo ""
    echo "2️⃣  Network & Ports"
    print_text_result "port_18789"
    
    echo ""
    echo "3️⃣  Configuration"
    print_text_result "config_file"
    print_text_result "config_permissions"
    print_text_result "config_validity"
    print_text_result "feishu_config"
    
    echo ""
    echo "4️⃣  Process Management"
    print_text_result "multiple_instances"
    
    echo ""
    echo "5️⃣  Dependencies"
    print_text_result "node_modules_conflict"
    print_text_result "plugin_deps"
    print_text_result "dependency_locks"
    
    echo ""
    echo "6️⃣  Logs & Errors"
    print_text_result "log_file"
    print_text_result "log_errors"
    print_text_result "auto_restarts"
    
    echo ""
    echo "7️⃣  System Resources"
    print_text_result "disk_space"
    print_text_result "nodejs"
    print_text_result "npm"
    
    echo ""
    echo "=================================================="
    echo "📋 Summary"
    echo "=================================================="
    echo ""
    
    if [ "$ISSUES_FOUND" -eq 0 ]; then
        echo -e "${GREEN}✅ No issues found! System is healthy.${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $ISSUES_FOUND issue(s) that need attention.${NC}"
        echo ""
        echo "Recommended actions:"
        
        if [ "${RESULTS[gateway_process_status]}" = "fail" ]; then
            echo "  • Start Gateway: openclaw-gateway &"
        fi
        
        if [ "${RESULTS[config_permissions_status]}" = "fail" ]; then
            echo "  • Fix config permissions: chmod 600 ~/.openclaw/openclaw.json"
        fi
        
        if [ "${RESULTS[feishu_config_status]}" = "fail" ]; then
            echo "  • Add missing Feishu config fields: ${RESULTS[feishu_config_message]}"
        fi
        
        if [ "${RESULTS[multiple_instances_status]}" = "fail" ]; then
            echo "  • Kill duplicate instances: pkill -9 -f openclaw-gateway"
        fi
        
        if [ "${RESULTS[node_modules_conflict_status]}" = "fail" ]; then
            echo "  • Move conflicting node_modules: mv ~/node_modules ~/node_modules.bak"
        fi
        
        if [ "${RESULTS[auto_restarts_status]}" = "fail" ]; then
            echo "  • Check logs for root cause: tail -100 $LOG_FILE"
        fi
    fi
    
    echo ""
    echo "For detailed logs: tail -100 $LOG_FILE"
    echo "For auto-fix: ./scripts/auto-fix.sh"
    echo ""
fi

# Exit with appropriate code
if [ "$ISSUES_FOUND" -gt 0 ]; then
    exit 1
else
    exit 0
fi
