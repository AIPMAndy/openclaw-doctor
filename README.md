# OpenClaw Doctor | OpenClaw 诊断专家

[English](#english) | [中文](#chinese)

---

<a name="english"></a>
## English

### Overview

OpenClaw Doctor is a professional diagnostic toolkit for quickly identifying and fixing common issues with OpenClaw Gateway, especially Feishu/Lark channel problems. Now with advanced monitoring, performance analysis, and automated recovery tools.

### Features

- 🔍 **System Diagnostics**: Auto-detect Gateway status, plugin dependencies, channel connections
- 📊 **Performance Analysis**: Deep dive into resource usage, response times, and health scores
- 🔄 **Health Monitoring**: Continuous monitoring with automatic alerting
- 💾 **Backup & Restore**: Safe configuration management with one-click recovery
- 🛠️ **Issue Resolution**: Detailed fix steps and automated repair tools
- 📝 **Experience Base**: Real-world failure patterns library (12+ scenarios)
- ⚡ **Quick Checklist**: Priority-based problem identification
- 🤖 **Automation Ready**: JSON output for CI/CD integration

### Installation

#### Quick Install
```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash
```

#### Manual Install
```bash
# Clone the repository
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor

# Run installer
./install.sh

# Or copy manually
cp openclaw-doctor.md ~/.openclaw/skills/
```

### Usage

#### As OpenClaw Skill
```
/openclaw-doctor
```

#### As Standalone Tools

**Quick Diagnostic:**
```bash
./scripts/quick-diagnostic.sh
```

**Advanced Diagnostic:**
```bash
# Text output
./scripts/advanced-diagnostic.sh

# JSON output (for automation)
./scripts/advanced-diagnostic.sh --json
```

**Performance Analysis:**
```bash
./scripts/performance-analyzer.sh
```

**Health Monitoring:**
```bash
# Start monitoring (check every 60s, alert after 3 failures)
./scripts/health-monitor.sh --interval 60 --threshold 3

# Run in background
nohup ./scripts/health-monitor.sh > /tmp/monitor.log 2>&1 &
```

**Backup & Restore:**
```bash
# Create backup
./scripts/backup-restore.sh backup

# List backups
./scripts/backup-restore.sh list

# Restore
./scripts/backup-restore.sh restore 20260427_120000
```

**Auto Fix:**
```bash
./scripts/auto-fix.sh
```

### Supported Issues

**Feishu Channel (12 patterns)**
- Channel auto-restart loop
- Message no response
- WebSocket connection failure
- Config permission errors
- API credential validation
- Memory leaks
- File descriptor exhaustion
- Dependency version conflicts

**Gateway**
- Startup failure
- Port conflicts
- Multiple instance conflicts
- Plugin loading errors
- Performance degradation

**Dependencies**
- npm dependency conflicts
- Installation path errors
- ENOTEMPTY errors
- Lock file issues

### Tools Overview

| Tool | Purpose | Output |
|------|---------|--------|
| quick-diagnostic.sh | Daily health check | Text report |
| advanced-diagnostic.sh | Comprehensive analysis | Text/JSON |
| performance-analyzer.sh | Resource usage analysis | Text with health score |
| health-monitor.sh | Continuous monitoring | Log file |
| auto-fix.sh | Automated repair | Interactive |
| backup-restore.sh | Config management | Interactive |

### Quick Examples

**Daily Health Check:**
```bash
./scripts/quick-diagnostic.sh
```

**Troubleshooting:**
```bash
# Run full diagnostic
./scripts/advanced-diagnostic.sh

# Analyze performance
./scripts/performance-analyzer.sh

# Check logs
tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

**Before Config Changes:**
```bash
# Backup first
./scripts/backup-restore.sh backup

# Make changes...
vim ~/.openclaw/openclaw.json

# Restart Gateway
pkill -f openclaw-gateway && openclaw-gateway &
```

**CI/CD Integration:**
```bash
# Run diagnostic and fail if issues found
./scripts/advanced-diagnostic.sh --json > diagnostic.json
if [ $? -ne 0 ]; then
  echo "Health check failed"
  cat diagnostic.json
  exit 1
fi
```

### Automation

**Cron Jobs:**
```bash
# Hourly health check
0 * * * * /path/to/scripts/advanced-diagnostic.sh >> /tmp/health.log 2>&1

# Daily backup at 2 AM
0 2 * * * /path/to/scripts/backup-restore.sh backup >> /tmp/backup.log 2>&1

# Weekly cleanup
0 3 * * 0 /path/to/scripts/backup-restore.sh clean >> /tmp/backup.log 2>&1
```

### Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### License

MIT License - see [LICENSE](LICENSE) for details.

---

<a name="chinese"></a>
## 中文

### 概述

OpenClaw Doctor 是一个专业的诊断工具集，帮助你快速定位和修复 OpenClaw Gateway 的常见问题，特别是飞书（Lark/Feishu）通道相关的故障。现已包含高级监控、性能分析和自动恢复工具。

### 功能特性

- 🔍 **系统诊断**：自动检测 Gateway 状态、插件依赖、通道连接
- 📊 **性能分析**：深入分析资源使用、响应时间和健康评分
- 🔄 **健康监控**：持续监控并自动告警
- 💾 **备份恢复**：安全的配置管理，一键恢复
- 🛠️ **故障修复**：提供详细的修复步骤和自动修复工具
- 📝 **经验总结**：基于真实案例的故障模式库（12+ 种场景）
- ⚡ **快速排查**：优先级清单，快速定位问题
- 🤖 **自动化就绪**：支持 JSON 输出，可集成到 CI/CD

### 安装

#### 快速安装
```bash
# 下载并运行安装脚本
curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash
```

#### 手动安装
```bash
# 克隆仓库
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor

# 运行安装脚本
./install.sh

# 或手动复制
cp openclaw-doctor.md ~/.openclaw/skills/
```

### 使用方法

#### 作为 OpenClaw Skill
```
/openclaw-doctor
```

#### 作为独立工具

**快速诊断：**
```bash
./scripts/quick-diagnostic.sh
```

**高级诊断：**
```bash
# 文本输出
./scripts/advanced-diagnostic.sh

# JSON 输出（用于自动化）
./scripts/advanced-diagnostic.sh --json
```

**性能分析：**
```bash
./scripts/performance-analyzer.sh
```

**健康监控：**
```bash
# 启动监控（每 60 秒检查一次，连续 3 次失败后告警）
./scripts/health-monitor.sh --interval 60 --threshold 3

# 后台运行
nohup ./scripts/health-monitor.sh > /tmp/monitor.log 2>&1 &
```

**备份与恢复：**
```bash
# 创建备份
./scripts/backup-restore.sh backup

# 列出备份
./scripts/backup-restore.sh list

# 恢复备份
./scripts/backup-restore.sh restore 20260427_120000
```

**自动修复：**
```bash
./scripts/auto-fix.sh
```

### 支持的问题类型

**飞书通道问题（12 种模式）**
- 通道反复 auto-restart
- 消息无响应
- WebSocket 连接失败
- 配置权限错误
- API 凭证验证
- 内存泄漏
- 文件描述符耗尽
- 依赖版本冲突

**Gateway 问题**
- 启动失败
- 端口占用
- 多实例冲突
- 插件加载失败
- 性能下降

**依赖问题**
- npm 依赖冲突
- 依赖安装路径错误
- ENOTEMPTY 错误
- 依赖锁文件问题

### 工具概览

| 工具 | 用途 | 输出格式 |
|------|------|----------|
| quick-diagnostic.sh | 日常健康检查 | 文本报告 |
| advanced-diagnostic.sh | 全面分析 | 文本/JSON |
| performance-analyzer.sh | 资源使用分析 | 文本+健康评分 |
| health-monitor.sh | 持续监控 | 日志文件 |
| auto-fix.sh | 自动修复 | 交互式 |
| backup-restore.sh | 配置管理 | 交互式 |

### 快速示例

**日常健康检查：**
```bash
./scripts/quick-diagnostic.sh
```

**故障排查：**
```bash
# 运行完整诊断
./scripts/advanced-diagnostic.sh

# 分析性能
./scripts/performance-analyzer.sh

# 查看日志
tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

**配置变更前：**
```bash
# 先备份
./scripts/backup-restore.sh backup

# 修改配置...
vim ~/.openclaw/openclaw.json

# 重启 Gateway
pkill -f openclaw-gateway && openclaw-gateway &
```

**CI/CD 集成：**
```bash
# 运行诊断，如果有问题则失败
./scripts/advanced-diagnostic.sh --json > diagnostic.json
if [ $? -ne 0 ]; then
  echo "健康检查失败"
  cat diagnostic.json
  exit 1
fi
```

### 自动化

**定时任务：**
```bash
# 每小时健康检查
0 * * * * /path/to/scripts/advanced-diagnostic.sh >> /tmp/health.log 2>&1

# 每天凌晨 2 点备份
0 2 * * * /path/to/scripts/backup-restore.sh backup >> /tmp/backup.log 2>&1

# 每周日清理
0 3 * * 0 /path/to/scripts/backup-restore.sh clean >> /tmp/backup.log 2>&1
```

### 常见问题 FAQ

#### Q: 飞书通道一直显示 "auto-restart attempt X/10"？

**A:** 这通常是配置缺少必需字段。运行诊断：
```bash
./scripts/advanced-diagnostic.sh
```
检查输出中的 `feishu_config` 项，补充缺失的字段。

#### Q: 如何监控 Gateway 健康状态？

**A:** 使用健康监控工具：
```bash
nohup ./scripts/health-monitor.sh --interval 60 --threshold 3 > /tmp/monitor.log 2>&1 &
```

#### Q: Gateway 性能下降怎么办？

**A:** 运行性能分析：
```bash
./scripts/performance-analyzer.sh
```
查看健康评分和具体问题，根据建议进行优化。

#### Q: 如何自动化日常检查？

**A:** 设置 cron 定时任务：
```bash
crontab -e
# 添加：0 * * * * /path/to/scripts/advanced-diagnostic.sh >> /tmp/health.log 2>&1
```

### 贡献

欢迎贡献！详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

### 许可证

MIT License - 详见 [LICENSE](LICENSE)。

### 相关资源

- [OpenClaw 官方文档](https://openclaw.ai)
- [飞书开放平台](https://open.feishu.cn)
- [@larksuite/openclaw-lark 插件](https://www.npmjs.com/package/@larksuite/openclaw-lark)
- [详细脚本文档](scripts/README.md)

### 更新日志

#### v1.1.0 (2026-04-27) - 深度优化版
- ✨ 新增高级诊断脚本（支持 JSON 输出）
- 📊 新增性能分析工具（健康评分系统）
- 🔍 新增健康监控服务（持续监控+自动告警）
- 💾 新增备份恢复工具（安全配置管理）
- 📝 扩展故障模式库（12 种常见问题）
- 🚀 性能优化建议和最佳实践
- 📋 故障预防清单
- 🔧 自动化集成示例（CI/CD、Cron）
- 📚 完善的文档和使用指南

#### v1.0.0 (2026-04-26)
- ✨ 初始版本
- 📝 添加 8 种常见故障模式
- 🔍 添加快速排查清单
- 🌲 添加故障排查决策树
- 📚 添加详细的诊断流程

### Star History

If you find this project helpful, please give it a ⭐️!

如果这个项目对你有帮助，请给个 ⭐️！

---

**Made with ❤️ for the OpenClaw community**
