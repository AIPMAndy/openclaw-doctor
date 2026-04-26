#!/bin/bash
# OpenClaw Doctor - Performance Analyzer
# 性能分析脚本 - 分析 Gateway 性能指标

set -e

echo "📊 OpenClaw Performance Analyzer"
echo "=================================="
echo ""

# Check if Gateway is running
if ! ps aux | grep -v grep | grep openclaw-gateway > /dev/null; then
    echo "❌ Gateway is not running"
    exit 1
fi

GATEWAY_PID=$(ps aux | grep -v grep | grep openclaw-gateway | awk '{print $2}' | head -1)

echo "Gateway PID: $GATEWAY_PID"
echo ""

# 1. CPU and Memory Usage
echo "1️⃣  Resource Usage"
echo "-------------------"
ps -p "$GATEWAY_PID" -o pid,ppid,%cpu,%mem,vsz,rss,etime,command | tail -n +2
echo ""

# 2. Open Files
echo "2️⃣  Open Files"
echo "---------------"
OPEN_FILES=$(lsof -p "$GATEWAY_PID" 2>/dev/null | wc -l)
echo "Total open files: $OPEN_FILES"
echo ""
echo "File descriptors by type:"
lsof -p "$GATEWAY_PID" 2>/dev/null | awk '{print $5}' | sort | uniq -c | sort -rn | head -10
echo ""

# 3. Network Connections
echo "3️⃣  Network Connections"
echo "------------------------"
echo "Active connections:"
lsof -i -p "$GATEWAY_PID" 2>/dev/null | tail -n +2 || echo "No active connections"
echo ""

# 4. Thread Count
echo "4️⃣  Thread Information"
echo "-----------------------"
if [[ "$OSTYPE" == "darwin"* ]]; then
    THREAD_COUNT=$(ps -M -p "$GATEWAY_PID" 2>/dev/null | wc -l)
    echo "Thread count: $((THREAD_COUNT - 1))"
else
    THREAD_COUNT=$(ps -T -p "$GATEWAY_PID" 2>/dev/null | wc -l)
    echo "Thread count: $((THREAD_COUNT - 1))"
fi
echo ""

# 5. Log Analysis
echo "5️⃣  Log Statistics (Last 24 Hours)"
echo "------------------------------------"
LOG_FILE="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
if [ -f "$LOG_FILE" ]; then
    TOTAL_LINES=$(wc -l < "$LOG_FILE")
    ERROR_COUNT=$(grep -c -i "error" "$LOG_FILE" 2>/dev/null || echo "0")
    WARN_COUNT=$(grep -c -i "warn" "$LOG_FILE" 2>/dev/null || echo "0")
    
    echo "Total log lines: $TOTAL_LINES"
    echo "Errors: $ERROR_COUNT"
    echo "Warnings: $WARN_COUNT"
    
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo ""
        echo "Recent errors (last 5):"
        grep -i "error" "$LOG_FILE" | tail -5 | sed 's/^/  /'
    fi
else
    echo "Log file not found"
fi
echo ""

# 6. Response Time Analysis
echo "6️⃣  Response Time Analysis"
echo "---------------------------"
if [ -f "$LOG_FILE" ]; then
    echo "Analyzing message processing times..."
    
    # Extract processing times if available in logs
    PROCESSING_TIMES=$(grep -o "processed in [0-9]*ms" "$LOG_FILE" 2>/dev/null | grep -o "[0-9]*" || echo "")
    
    if [ -n "$PROCESSING_TIMES" ]; then
        AVG_TIME=$(echo "$PROCESSING_TIMES" | awk '{sum+=$1; count++} END {if(count>0) print sum/count; else print 0}')
        MAX_TIME=$(echo "$PROCESSING_TIMES" | sort -n | tail -1)
        MIN_TIME=$(echo "$PROCESSING_TIMES" | sort -n | head -1)
        
        echo "Average processing time: ${AVG_TIME}ms"
        echo "Min processing time: ${MIN_TIME}ms"
        echo "Max processing time: ${MAX_TIME}ms"
    else
        echo "No processing time data available in logs"
    fi
else
    echo "Log file not found"
fi
echo ""

# 7. Dependency Size
echo "7️⃣  Dependency Storage"
echo "-----------------------"
if [ -d ~/.openclaw/plugin-runtime-deps ]; then
    DEPS_SIZE=$(du -sh ~/.openclaw/plugin-runtime-deps 2>/dev/null | awk '{print $1}')
    DEPS_COUNT=$(find ~/.openclaw/plugin-runtime-deps -type d -name "node_modules" 2>/dev/null | wc -l)
    
    echo "Total size: $DEPS_SIZE"
    echo "Plugin dependency folders: $DEPS_COUNT"
    
    echo ""
    echo "Largest dependencies:"
    du -sh ~/.openclaw/plugin-runtime-deps/*/* 2>/dev/null | sort -rh | head -5
else
    echo "Dependency directory not found"
fi
echo ""

# 8. Uptime
echo "8️⃣  Uptime"
echo "-----------"
UPTIME=$(ps -p "$GATEWAY_PID" -o etime= | tr -d ' ')
echo "Gateway uptime: $UPTIME"
echo ""

# 9. Health Score
echo "=================================="
echo "📈 Health Score"
echo "=================================="
echo ""

SCORE=100
ISSUES=""

# Deduct points for issues
if [ "$OPEN_FILES" -gt 1000 ]; then
    SCORE=$((SCORE - 20))
    ISSUES="${ISSUES}- Too many open files ($OPEN_FILES)\n"
fi

CPU_USAGE=$(ps -p "$GATEWAY_PID" -o %cpu= | tr -d ' ' | cut -d'.' -f1)
if [ "$CPU_USAGE" -gt 80 ]; then
    SCORE=$((SCORE - 15))
    ISSUES="${ISSUES}- High CPU usage (${CPU_USAGE}%)\n"
fi

MEM_USAGE=$(ps -p "$GATEWAY_PID" -o %mem= | tr -d ' ' | cut -d'.' -f1)
if [ "$MEM_USAGE" -gt 50 ]; then
    SCORE=$((SCORE - 15))
    ISSUES="${ISSUES}- High memory usage (${MEM_USAGE}%)\n"
fi

if [ "$ERROR_COUNT" -gt 50 ]; then
    SCORE=$((SCORE - 25))
    ISSUES="${ISSUES}- High error count ($ERROR_COUNT)\n"
elif [ "$ERROR_COUNT" -gt 10 ]; then
    SCORE=$((SCORE - 10))
    ISSUES="${ISSUES}- Moderate error count ($ERROR_COUNT)\n"
fi

if [ "$SCORE" -ge 90 ]; then
    echo "✅ Excellent: $SCORE/100"
elif [ "$SCORE" -ge 70 ]; then
    echo "✓ Good: $SCORE/100"
elif [ "$SCORE" -ge 50 ]; then
    echo "⚠️  Fair: $SCORE/100"
else
    echo "❌ Poor: $SCORE/100"
fi

if [ -n "$ISSUES" ]; then
    echo ""
    echo "Issues detected:"
    echo -e "$ISSUES"
fi

echo ""
echo "Recommendations:"
if [ "$OPEN_FILES" -gt 1000 ]; then
    echo "  • Consider restarting Gateway to clear file handles"
fi
if [ "$CPU_USAGE" -gt 80 ] || [ "$MEM_USAGE" -gt 50 ]; then
    echo "  • Check for resource-intensive plugins"
    echo "  • Review recent log activity"
fi
if [ "$ERROR_COUNT" -gt 10 ]; then
    echo "  • Investigate error patterns in logs"
    echo "  • Run: grep -i error $LOG_FILE | tail -20"
fi

echo ""
