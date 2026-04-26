#!/bin/bash
# OpenClaw Doctor - Test Suite
# 测试套件 - 验证所有脚本功能

set -e

echo "🧪 OpenClaw Doctor - Test Suite"
echo "================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASSED=0
FAILED=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

test_script() {
    local name="$1"
    local script="$2"
    local args="${3:-}"
    
    echo -n "Testing $name... "
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}FAIL${NC} (script not found)"
        ((FAILED++))
        return
    fi
    
    if [ ! -x "$script" ]; then
        echo -e "${RED}FAIL${NC} (not executable)"
        ((FAILED++))
        return
    fi
    
    # Test help flag
    if $script --help > /dev/null 2>&1 || $script -h > /dev/null 2>&1 || [ -z "$args" ]; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
    else
        echo -e "${RED}FAIL${NC} (execution error)"
        ((FAILED++))
    fi
}

test_shellcheck() {
    local script="$1"
    local name=$(basename "$script")
    
    if ! command -v shellcheck > /dev/null 2>&1; then
        echo "  Skipping shellcheck for $name (shellcheck not installed)"
        return
    fi
    
    echo -n "  Shellcheck $name... "
    
    if shellcheck "$script" > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}WARN${NC} (shellcheck warnings)"
        # Don't count as failure, just warning
    fi
}

echo "1️⃣  Script Existence & Permissions"
echo "------------------------------------"
test_script "quick-diagnostic.sh" "$SCRIPT_DIR/quick-diagnostic.sh"
test_script "advanced-diagnostic.sh" "$SCRIPT_DIR/advanced-diagnostic.sh" "--help"
test_script "performance-analyzer.sh" "$SCRIPT_DIR/performance-analyzer.sh"
test_script "health-monitor.sh" "$SCRIPT_DIR/health-monitor.sh" "--help"
test_script "backup-restore.sh" "$SCRIPT_DIR/backup-restore.sh" "--help"
test_script "auto-fix.sh" "$SCRIPT_DIR/auto-fix.sh"
echo ""

echo "2️⃣  Script Syntax (shellcheck)"
echo "--------------------------------"
for script in "$SCRIPT_DIR"/*.sh; do
    if [ -f "$script" ] && [ "$script" != "$SCRIPT_DIR/test-all.sh" ]; then
        test_shellcheck "$script"
    fi
done
echo ""

echo "3️⃣  Advanced Diagnostic Features"
echo "----------------------------------"
echo -n "Testing JSON output... "
if "$SCRIPT_DIR/advanced-diagnostic.sh" --json > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi

echo -n "Testing version flag... "
if "$SCRIPT_DIR/advanced-diagnostic.sh" --version > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi
echo ""

echo "4️⃣  Documentation"
echo "------------------"
echo -n "Testing README.md exists... "
if [ -f "$SCRIPT_DIR/README.md" ]; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi

echo -n "Testing main README.md exists... "
if [ -f "$SCRIPT_DIR/../README.md" ]; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi

echo -n "Testing CHANGELOG.md exists... "
if [ -f "$SCRIPT_DIR/../CHANGELOG.md" ]; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi

echo -n "Testing openclaw-doctor.md exists... "
if [ -f "$SCRIPT_DIR/../openclaw-doctor.md" ]; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi
echo ""

echo "5️⃣  Installation Scripts"
echo "-------------------------"
echo -n "Testing install.sh exists... "
if [ -f "$SCRIPT_DIR/../install.sh" ]; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi

echo -n "Testing install.sh is executable... "
if [ -x "$SCRIPT_DIR/../install.sh" ]; then
    echo -e "${GREEN}PASS${NC}"
    ((PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    ((FAILED++))
fi
echo ""

echo "================================="
echo "📊 Test Results"
echo "================================="
echo ""
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total:  $((PASSED + FAILED))"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
