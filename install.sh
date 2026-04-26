#!/bin/bash

# OpenClaw Doctor - Installation Script
# 一键安装 OpenClaw Doctor skill

set -e

echo "🔧 OpenClaw Doctor Installer"
echo "=============================="
echo ""

# 检查 OpenClaw 目录
OPENCLAW_DIR="$HOME/.openclaw"
SKILLS_DIR="$OPENCLAW_DIR/skills"

if [ ! -d "$OPENCLAW_DIR" ]; then
    echo "❌ Error: OpenClaw directory not found at $OPENCLAW_DIR"
    echo "   Please install OpenClaw first."
    exit 1
fi

echo "✓ Found OpenClaw directory"

# 创建 skills 目录（如果不存在）
if [ ! -d "$SKILLS_DIR" ]; then
    echo "📁 Creating skills directory..."
    mkdir -p "$SKILLS_DIR"
fi

echo "✓ Skills directory ready"

# 下载 skill 文件
echo ""
echo "📥 Downloading openclaw-doctor.md..."

SKILL_FILE="$SKILLS_DIR/openclaw-doctor.md"
REPO_URL="https://raw.githubusercontent.com/YOUR_USERNAME/openclaw-doctor/main/openclaw-doctor.md"

if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_URL" -o "$SKILL_FILE"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_URL" -O "$SKILL_FILE"
else
    echo "❌ Error: Neither curl nor wget found"
    echo "   Please install curl or wget first."
    exit 1
fi

echo "✓ Skill file downloaded"

# 可选：下载脚本
echo ""
read -p "📦 Download diagnostic scripts? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    DOCTOR_DIR="$SKILLS_DIR/openclaw-doctor"
    SCRIPTS_DIR="$DOCTOR_DIR/scripts"

    echo "📁 Creating directory structure..."
    mkdir -p "$SCRIPTS_DIR"

    echo "📥 Downloading scripts..."

    # 下载脚本
    curl -fsSL "https://raw.githubusercontent.com/YOUR_USERNAME/openclaw-doctor/main/scripts/quick-diagnostic.sh" \
        -o "$SCRIPTS_DIR/quick-diagnostic.sh"

    curl -fsSL "https://raw.githubusercontent.com/YOUR_USERNAME/openclaw-doctor/main/scripts/auto-fix.sh" \
        -o "$SCRIPTS_DIR/auto-fix.sh"

    curl -fsSL "https://raw.githubusercontent.com/YOUR_USERNAME/openclaw-doctor/main/scripts/README.md" \
        -o "$SCRIPTS_DIR/README.md"

    # 添加执行权限
    chmod +x "$SCRIPTS_DIR/quick-diagnostic.sh"
    chmod +x "$SCRIPTS_DIR/auto-fix.sh"

    echo "✓ Scripts installed"
    echo ""
    echo "📍 Scripts location: $SCRIPTS_DIR"
fi

# 安装完成
echo ""
echo "=============================="
echo "✅ Installation Complete!"
echo "=============================="
echo ""
echo "Usage:"
echo "  1. In OpenClaw: /openclaw-doctor"
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  2. Run diagnostic: $SCRIPTS_DIR/quick-diagnostic.sh"
    echo "  3. Run auto-fix: $SCRIPTS_DIR/auto-fix.sh"
    echo ""
fi

echo "Documentation:"
echo "  https://github.com/YOUR_USERNAME/openclaw-doctor"
echo ""
echo "Need help? Open an issue:"
echo "  https://github.com/YOUR_USERNAME/openclaw-doctor/issues"
echo ""
