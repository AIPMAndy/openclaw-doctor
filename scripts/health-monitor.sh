#!/bin/bash
# OpenClaw Doctor - Health Monitoring Script
# 健康监控脚本 - 持续监控 Gateway 状态

set -e

INTERVAL=60  # Check interval in seconds
LOG_FILE="/tmp/openclaw-doctor-monitor.log"
ALERT_THRESHOLD=3  # Alert after N consecutive failures

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --interval)
            INTERVAL="$2"
            shift 2
            ;;
        --log)
            LOG_FILE="$2"
            shift 2
            ;;
        --threshold)
            ALERT_THRESHOLD="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --interval N    Check interval in seconds (default: 60)"
            echo "  --log FILE      Log file path (default: /tmp/openclaw-doctor-monitor.log)"
            echo "  --threshold N   Alert after N failures (default: 3)"
            echo "  --help          Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🔍 OpenClaw Health Monitor Started"
echo "Interval: ${INTERVAL}s | Log: $LOG_FILE | Threshold: $ALERT_THRESHOLD"
echo "Press Ctrl+C to stop"
echo ""

FAILURE_COUNT=0
LAST_STATUS="unknown"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_health() {
    local status="healthy"
    local issues=""
    
    # Check Gateway process
    if ! ps aux | grep -v grep | grep openclaw-gateway > /dev/null; then
        status="unhealthy"
        issues="${issues}Gateway not running; "
    fi
    
    # Check port
    if ! lsof -i :18789 > /dev/null 2>&1; then
        status="unhealthy"
        issues="${issues}Port 18789 not listening; "
    fi
    
    # Check recent errors in logs
    if [ -f "/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log" ]; then
        RECENT_ERRORS=$(tail -100 "/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log" | grep -c -i "error" || echo "0")
        if [ "$RECENT_ERRORS" -gt 10 ]; then
            status="degraded"
            issues="${issues}High error rate ($RECENT_ERRORS in last 100 lines); "
        fi
    fi
    
    echo "$status|$issues"
}

while true; do
    RESULT=$(check_health)
    STATUS=$(echo "$RESULT" | cut -d'|' -f1)
    ISSUES=$(echo "$RESULT" | cut -d'|' -f2)
    
    if [ "$STATUS" = "healthy" ]; then
        if [ "$LAST_STATUS" != "healthy" ]; then
            log_message "✅ System recovered - Status: healthy"
        fi
        FAILURE_COUNT=0
    elif [ "$STATUS" = "degraded" ]; then
        log_message "⚠️  System degraded - $ISSUES"
        FAILURE_COUNT=0
    else
        ((FAILURE_COUNT++))
        log_message "❌ System unhealthy (${FAILURE_COUNT}/${ALERT_THRESHOLD}) - $ISSUES"
        
        if [ "$FAILURE_COUNT" -ge "$ALERT_THRESHOLD" ]; then
            log_message "🚨 ALERT: System has been unhealthy for $FAILURE_COUNT consecutive checks!"
            
            # Optional: Send notification (uncomment and configure)
            # osascript -e 'display notification "OpenClaw Gateway is down!" with title "OpenClaw Doctor Alert"'
            
            # Optional: Auto-restart (uncomment to enable)
            # log_message "🔄 Attempting auto-restart..."
            # pkill -9 -f openclaw-gateway
            # sleep 2
            # openclaw-gateway > /dev/null 2>&1 &
            # log_message "✅ Auto-restart initiated"
            # FAILURE_COUNT=0
        fi
    fi
    
    LAST_STATUS="$STATUS"
    sleep "$INTERVAL"
done
