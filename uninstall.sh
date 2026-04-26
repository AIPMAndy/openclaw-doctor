#!/bin/bash

# OpenClaw Doctor - Uninstallation Script
# 卸载 OpenClaw Doctor skill

set -e

echo "🗑️  OpenClaw Doctor Uninstaller"
echo "================================"
echo ""

OPENCLAW_DIR="$HOME/.openclaw"
SKILLS_DIR="$OPENCLAW_DIR/skills"
SKILL_FILE="$SKILLS_DIR/openclaw-doctor.md"
DOCTOR_DIR="$SKILLS_DIR/openclaw-doctor"

# 检查是否已安装
if [ ! -f "$SKILL_FILE" ] && [ ! -d "$DOCTOR_DIR" ]; then
    echo "ℹ️  OpenClaw Doctor is not installed."
    exit 0
fi

echo "Found installed components:"
[ -f "$SKILL_FILE" ] && echo "  - Skill file: $SKILL_FILE"
[ -d "$DOCTOR_DIR" ] && echo "  - Scripts directory: $DOCTOR_DIR"
echo ""

# 确认卸载
read -p "⚠️  Are you sure you want to uninstall? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Uninstallation cancelled."
    exit 0
fi

# 删除文件
echo ""
echo "🗑️  Removing files..."

if [ -f "$SKILL_FILE" ]; then
    rm "$SKILL_FILE"
    echo "✓ Removed skill file"
fi

if [ -d "$DOCTOR_DIR" ]; then
    rm -rf "$DOCTOR_DIR"
    echo "✓ Removed scripts directory"
fi

# 完成
echo ""
echo "================================"
echo "✅ Uninstallation Complete!"
echo "================================"
echo ""
echo "OpenClaw Doctor has been removed from your system."
echo ""
echo "To reinstall:"
echo "  curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/openclaw-doctor/main/install.sh | bash"
echo ""
echo "Thank you for using OpenClaw Doctor! 👋"
echo ""
