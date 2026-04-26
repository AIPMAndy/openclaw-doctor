#!/bin/bash
# OpenClaw Doctor - Auto Fix Script
# 自动修复脚本

set -e

echo "🛠️  OpenClaw Doctor - Auto Fix"
echo "======================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to ask for confirmation
confirm() {
    read -p "$1 (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Fix 1: Config file permissions
echo "1️⃣  Fixing config file permissions..."
if [ -f ~/.openclaw/openclaw.json ]; then
    PERMS=$(ls -l ~/.openclaw/openclaw.json | awk '{print $1}')
    if [ "$PERMS" != "-rw-------" ]; then
        if confirm "Fix config file permissions to 600?"; then
            chmod 600 ~/.openclaw/openclaw.json
            echo -e "${GREEN}✓${NC} Fixed config file permissions"
        fi
    else
        echo -e "${GREEN}✓${NC} Config file permissions already correct"
    fi
else
    echo -e "${RED}✗${NC} Config file not found"
fi
echo ""

# Fix 2: Kill multiple Gateway instances
echo "2️⃣  Checking for multiple Gateway instances..."
GATEWAY_COUNT=$(ps aux | grep -v grep | grep openclaw-gateway | wc -l)
if [ "$GATEWAY_COUNT" -gt 1 ]; then
    echo -e "${YELLOW}⚠${NC} Found $GATEWAY_COUNT Gateway instances"
    if confirm "Kill all Gateway instances?"; then
        pkill -9 -f openclaw-gateway
        echo -e "${GREEN}✓${NC} Killed all Gateway instances"
        sleep 2
    fi
elif [ "$GATEWAY_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} No Gateway instance running"
else
    echo -e "${GREEN}✓${NC} Single Gateway instance running"
fi
echo ""

# Fix 3: Remove ~/node_modules
echo "3️⃣  Checking for npm dependency conflicts..."
if [ -d ~/node_modules ]; then
    echo -e "${YELLOW}⚠${NC} Found ~/node_modules (may cause conflicts)"
    if confirm "Move ~/node_modules to ~/node_modules.bak?"; then
        mv ~/node_modules ~/node_modules.bak
        echo -e "${GREEN}✓${NC} Moved ~/node_modules to backup"
    fi
else
    echo -e "${GREEN}✓${NC} No ~/node_modules found"
fi
echo ""

# Fix 4: Clear dependency locks
echo "4️⃣  Checking dependency locks..."
if [ -d ~/.openclaw/plugin-runtime-deps/.locks ]; then
    if confirm "Clear dependency locks?"; then
        rm -rf ~/.openclaw/plugin-runtime-deps/.locks
        echo -e "${GREEN}✓${NC} Cleared dependency locks"
    fi
else
    echo -e "${GREEN}✓${NC} No dependency locks found"
fi
echo ""

# Fix 5: Restart Gateway
echo "5️⃣  Restarting Gateway..."
if confirm "Start Gateway now?"; then
    openclaw-gateway > /dev/null 2>&1 &
    sleep 3

    if ps aux | grep -v grep | grep openclaw-gateway > /dev/null; then
        echo -e "${GREEN}✓${NC} Gateway started successfully"
        echo "  PID: $(ps aux | grep -v grep | grep openclaw-gateway | awk '{print $2}')"
    else
        echo -e "${RED}✗${NC} Gateway failed to start"
        echo "  Check logs: tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
    fi
fi
echo ""

# Summary
echo "======================================"
echo "📋 Fix Summary"
echo "======================================"
echo ""
echo "✅ Completed fixes"
echo ""
echo "Next steps:"
echo "  1. Wait 30 seconds for plugin dependencies to install"
echo "  2. Check Gateway status: ps aux | grep openclaw-gateway"
echo "  3. Test Feishu channel: send a message"
echo "  4. View logs: tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"
echo ""
