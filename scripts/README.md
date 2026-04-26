# Scripts Usage Guide | 脚本使用指南

## Quick Diagnostic Script | 快速诊断脚本

### 功能

快速检查 OpenClaw Gateway 的运行状态和常见问题。

### 使用方法

```bash
cd ~/.openclaw/skills/openclaw-doctor/scripts
./quick-diagnostic.sh
```

### 检查项目

1. ✅ Gateway 进程状态
2. ✅ 端口 18789 占用情况
3. ✅ 配置文件权限
4. ✅ 飞书插件诊断
5. ✅ 最近的错误日志
6. ✅ npm 依赖冲突

### 输出示例

```
🔍 OpenClaw Doctor - Quick Diagnostic
======================================

1️⃣  Checking Gateway process...
✓ Gateway is running
  PID: 12345, CPU: 2.3%, MEM: 1.5%

2️⃣  Checking port 18789...
✓ Port 18789 is in use

3️⃣  Checking config file...
✓ Config file permissions are correct (600)

4️⃣  Running Feishu plugin diagnostics...
All checks passed!

5️⃣  Checking recent logs...
Recent errors:
  No recent errors

6️⃣  Checking for npm dependency conflicts...
✓ No ~/node_modules found

======================================
📋 Summary
======================================
```

---

## Auto Fix Script | 自动修复脚本

### 功能

自动修复常见的 OpenClaw 问题。

### 使用方法

```bash
cd ~/.openclaw/skills/openclaw-doctor/scripts
./auto-fix.sh
```

### 修复项目

1. 🔧 修复配置文件权限（chmod 600）
2. 🔧 清理多余的 Gateway 实例
3. 🔧 移除冲突的 ~/node_modules
4. 🔧 清理依赖锁文件
5. 🔧 重启 Gateway

### 交互式确认

脚本会在执行每个修复操作前询问确认：

```
Fix config file permissions to 600? (y/n)
```

输入 `y` 确认，`n` 跳过。

### 安全提示

- ⚠️ 脚本会备份 ~/node_modules 到 ~/node_modules.bak
- ⚠️ 会强制终止所有 Gateway 进程（pkill -9）
- ⚠️ 建议先运行 quick-diagnostic.sh 了解问题

---

## 常见使用场景

### 场景 1：飞书通道无法启动

```bash
# 1. 先诊断
./quick-diagnostic.sh

# 2. 如果发现问题，运行修复
./auto-fix.sh

# 3. 等待 30 秒让依赖安装完成
sleep 30

# 4. 再次诊断验证
./quick-diagnostic.sh
```

### 场景 2：Gateway 启动失败

```bash
# 1. 诊断
./quick-diagnostic.sh

# 2. 查看详细日志
tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log

# 3. 运行修复
./auto-fix.sh
```

### 场景 3：定期健康检查

```bash
# 添加到 crontab，每小时检查一次
0 * * * * ~/.openclaw/skills/openclaw-doctor/scripts/quick-diagnostic.sh > /tmp/openclaw-health.log 2>&1
```

---

## 故障排除

### 脚本无法执行

```bash
# 确保脚本有执行权限
chmod +x quick-diagnostic.sh
chmod +x auto-fix.sh
```

### npx 命令不可用

```bash
# 安装 Node.js 和 npm
# macOS
brew install node

# Ubuntu/Debian
sudo apt-get install nodejs npm
```

### 权限不足

```bash
# 某些操作可能需要 sudo
sudo ./auto-fix.sh
```

---

## 高级用法

### 静默模式（非交互）

修改 `auto-fix.sh`，将所有 `confirm` 函数调用改为直接返回 true：

```bash
# 原代码
if confirm "Fix config file permissions to 600?"; then

# 修改为
if true; then
```

### 自定义检查项

在 `quick-diagnostic.sh` 中添加自定义检查：

```bash
# 添加在文件末尾
echo "7️⃣  Custom check..."
# 你的检查逻辑
echo ""
```

### 集成到 CI/CD

```yaml
# GitHub Actions 示例
- name: OpenClaw Health Check
  run: |
    ~/.openclaw/skills/openclaw-doctor/scripts/quick-diagnostic.sh
```

---

## 贡献

如果你有新的诊断或修复脚本想法，欢迎提交 PR！

## 许可证

MIT License
