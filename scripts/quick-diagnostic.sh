#!/bin/bash
# OpenClaw Doctor - Quick Diagnostic Script
# 快速诊断脚本

set -e

echo "🔍 OpenClaw Doctor - Quick Diagnostic"
echo "======================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Gateway process
echo "1️⃣  Checking Gateway process..."
if ps aux | grep -v grep | grep openclaw-gateway > /dev/null; then
    echo -e "${GREEN}✓${NC} Gateway is running"
    ps aux | grep -v grep | grep openclaw-gateway | awk '{print "  PID: " $2 ", CPU: " $3 "%, MEM: " $4 "%"}'
else
    echo -e "${RED}✗${NC} Gateway is NOT running"
fi
echo ""

# Check port
echo "2️⃣  Checking port 18789..."
if lsof -i :18789 > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Port 18789 is in use"
    lsof -i :18789 | tail -n +2
else
    echo -e "${YELLOW}⚠${NC} Port 18789 is not in use"
fi
echo ""

# Check config file
echo "3️⃣  Checking config file..."
if [ -f ~/.openclaw/openclaw.json ]; then
    PERMS=$(ls -l ~/.openclaw/openclaw.json | awk '{print $1}')
    if [ "$PERMS" = "-rw-------" ]; then
        echo -e "${GREEN}✓${NC} Config file permissions are correct (600)"
    else
        echo -e "${RED}✗${NC} Config file permissions are incorrect: $PERMS"
        echo "  Run: chmod 600 ~/.openclaw/openclaw.json"
    fi
else
    echo -e "${RED}✗${NC} Config file not found"
fi
echo ""

# Check Feishu plugin
echo "4️⃣  Running Feishu plugin diagnostics..."
if command -v npx > /dev/null; then
    npx @larksuite/openclaw-lark doctor 2>&1 || true
else
    echo -e "${YELLOW}⚠${NC} npx not found, skipping"
fi
echo ""

# Check recent logs
echo "5️⃣  Checking recent logs..."
LOG_FILE="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
if [ -f "$LOG_FILE" ]; then
    echo "Recent errors:"
    grep -i "error" "$LOG_FILE" | tail -5 || echo "  No recent errors"
    echo ""
    echo "Recent auto-restart:"
    grep "auto-restart" "$LOG_FILE" | tail -5 || echo "  No auto-restart detected"
else
    echo -e "${YELLOW}⚠${NC} Log file not found: $LOG_FILE"
fi
echo ""

# Check node_modules in home
echo "6️⃣  Checking for npm dependency conflicts..."
if [ -d ~/node_modules ]; then
    echo -e "${RED}✗${NC} ~/node_modules exists (may cause conflicts)"
    echo "  Run: mv ~/node_modules ~/node_modules.bak"
else
    echo -e "${GREEN}✓${NC} No ~/node_modules found"
fi
echo ""

# Summary
echo "======================================"
echo "📋 Summary"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. If Gateway is not running: openclaw-gateway &"
echo "  2. If config permissions wrong: chmod 600 ~/.openclaw/openclaw.json"
echo "  3. If Feishu doctor fails: check verificationToken and encryptKey"
echo "  4. View full logs: tail -100 $LOG_FILE"
echo ""
