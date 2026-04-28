<div align="center">

# 🔧 OpenClaw Doctor

**Diagnose and fix OpenClaw Gateway issues in 5 minutes | Optimized for Feishu/Lark channels**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/AIPMAndy/openclaw-doctor?style=social)](https://github.com/AIPMAndy/openclaw-doctor/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/AIPMAndy/openclaw-doctor)](https://github.com/AIPMAndy/openclaw-doctor/issues)

**English** | [简体中文](README.md)

<img src="assets/demo.gif" width="700" alt="OpenClaw Doctor Demo">

*One-click diagnosis → Auto-fix → Continuous monitoring*

</div>

---

## 🆚 Why OpenClaw Doctor?

| Capability | Manual Troubleshooting | OpenClaw Doctor |
|------------|:----------------------:|:---------------:|
| Diagnosis Speed | 30-60 minutes | **5 minutes** ✅ |
| Failure Pattern Library | Experience-based | **12+ real cases** ✅ |
| Auto-fix | ❌ | **One-click fix** ✅ |
| Continuous Monitoring | ❌ | **24/7 monitoring** ✅ |
| Feishu Channel Optimization | ❌ | **Deep optimization** ✅ |
| CI/CD Integration | ❌ | **JSON output** ✅ |

**Core Difference**: Not just a diagnostic tool, but a complete OpenClaw health management system.

---

## 🚀 Quick Start in 30 Seconds

```bash
# One-line install
curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash

# One-line diagnosis
openclaw-doctor

# See results
✓ Gateway running normally
✓ Port 18789 listening
✗ Feishu channel config incomplete → Auto-fix suggestions
```

**That's it!**

---

## 💡 Core Features

### 🔍 Intelligent Diagnosis System
- **5-minute comprehensive check**: Gateway status, plugin dependencies, channel connections
- **12+ failure pattern library**: Based on real-world cases
- **Priority sorting**: Automatically identifies the most urgent issues

### 🛠️ Auto-fix Tools
- **One-click fix**: Automatic repair for common issues (permissions, config, dependencies)
- **Safe backup**: Auto-backup before fixes, one-click rollback support
- **Fix verification**: Automatic verification after repair

### 📊 Performance Analysis
- **Health scoring system**: 0-100 score quantifying Gateway health
- **Resource monitoring**: Real-time tracking of CPU, memory, file descriptors
- **Performance recommendations**: Optimization suggestions based on analysis

### 🔄 Continuous Monitoring
- **24/7 monitoring**: Background continuous Gateway status checks
- **Auto-alerting**: Automatic notifications on consecutive failures
- **Historical records**: Complete health status history

### 🎯 Feishu Channel Specialization
- **User permission troubleshooting**: Detailed OAuth authorization flow guidance
- **WebSocket vs Long-Polling**: Auto-identify and suggest best connection mode
- **API credential validation**: One-click check for appId, appSecret config
- **Message no-response diagnosis**: Locate agent startup delay issues

---

## 📦 Installation

### Method 1: Quick Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash
```

### Method 2: Manual Install
```bash
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor
./install.sh
```

### Method 3: Skill Only
```bash
cp openclaw-doctor.md ~/.openclaw/skills/
```

---

## 🎬 Use Cases

### Case 1: Daily Health Check
```bash
# Run once every morning
./scripts/quick-diagnostic.sh
```

### Case 2: Emergency Troubleshooting
```bash
# Gateway down? Messages not responding?
./scripts/advanced-diagnostic.sh

# View detailed analysis and fix suggestions
```

### Case 3: Performance Optimization
```bash
# Gateway getting slow?
./scripts/performance-analyzer.sh

# Get health score and optimization suggestions
```

### Case 4: CI/CD Integration
```bash
# Auto-check before deployment
./scripts/advanced-diagnostic.sh --json > diagnostic.json
if [ $? -ne 0 ]; then
  echo "Health check failed, stopping deployment"
  exit 1
fi
```

### Case 5: Continuous Monitoring
```bash
# Run in background, auto-alert
nohup ./scripts/health-monitor.sh --interval 60 --threshold 3 > /tmp/monitor.log 2>&1 &
```

---

## 🛠️ Toolbox

| Tool | Purpose | Output | Time |
|------|---------|--------|------|
| `quick-diagnostic.sh` | Daily health check | Text report | ~10s |
| `advanced-diagnostic.sh` | Comprehensive analysis | Text/JSON | ~30s |
| `performance-analyzer.sh` | Performance analysis + scoring | Text + score | ~20s |
| `health-monitor.sh` | Continuous monitoring | Log file | Continuous |
| `auto-fix.sh` | Auto-repair | Interactive | ~2min |
| `backup-restore.sh` | Config management | Interactive | ~10s |

---

## 📝 Supported Issues

### Feishu Channel Issues (12 patterns)
- ✅ Channel auto-restart loop
- ✅ Message no response
- ✅ WebSocket connection failure
- ✅ Config permission errors
- ✅ API credential validation failure
- ✅ User permission issues (OAuth authorization)
- ✅ Memory leaks
- ✅ File descriptor exhaustion
- ✅ Dependency version conflicts
- ✅ Message send failure
- ✅ Group chat permission issues
- ✅ Event subscription anomalies

### Gateway Issues
- ✅ Startup failure
- ✅ Port conflicts
- ✅ Multiple instance conflicts
- ✅ Plugin loading errors
- ✅ Performance degradation

### Dependency Issues
- ✅ npm dependency conflicts
- ✅ Installation path errors
- ✅ ENOTEMPTY errors
- ✅ Lock file issues

---

## 🎯 Quick Examples

### Example 1: Feishu channel keeps auto-restarting?
```bash
$ ./scripts/advanced-diagnostic.sh

🔍 Issue detected:
✗ Feishu channel config missing verificationToken

💡 Fix suggestion:
1. Open ~/.openclaw/openclaw.json
2. Add to channels.feishu.accounts.xxx:
   "verificationToken": "your_token_here"
3. Restart Gateway

🔧 Auto-fix:
$ ./scripts/auto-fix.sh
```

### Example 2: User permission issues?
```bash
$ ./scripts/advanced-diagnostic.sh

🔍 Issue detected:
✗ Insufficient user permissions

💡 Fix suggestion:
1. Send /feishu auth to complete personal authorization
2. Remove default_user_open_id from config
3. Confirm permission type is "user-level permission"
4. Re-authorize

📚 Detailed docs:
https://bytedance.larkoffice.com/docx/MFK7dDFLFoVlOGxWCv5cTXKmnMh
```

### Example 3: Performance degradation?
```bash
$ ./scripts/performance-analyzer.sh

📊 Health Score: 72/100

⚠️ Issues found:
- CPU usage high: 15.3%
- Memory usage: 4.2GB (recommended < 3GB)
- File descriptors: 1024/4096

💡 Optimization suggestions:
1. Restart Gateway to free memory
2. Increase file descriptor limit: ulimit -n 8192
3. Check for memory leaks
```

---

## 🔄 Automation Integration

### Cron Jobs
```bash
# Edit crontab
crontab -e

# Hourly health check
0 * * * * /path/to/scripts/advanced-diagnostic.sh >> /tmp/health.log 2>&1

# Daily backup at 2 AM
0 2 * * * /path/to/scripts/backup-restore.sh backup >> /tmp/backup.log 2>&1

# Weekly cleanup on Sunday
0 3 * * 0 /path/to/scripts/backup-restore.sh clean >> /tmp/backup.log 2>&1
```

### CI/CD Integration
```yaml
# GitHub Actions example
- name: OpenClaw Health Check
  run: |
    curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash
    ./scripts/advanced-diagnostic.sh --json > diagnostic.json
    if [ $? -ne 0 ]; then
      echo "Health check failed"
      cat diagnostic.json
      exit 1
    fi
```

---

## 🗺️ Roadmap

### v1.2.0 (Planned)
- [ ] Web UI control panel
- [ ] Real-time performance charts
- [ ] Email/DingTalk/WeCom alerts
- [ ] More channel support (Telegram, Discord)

### v1.1.0 (Released)
- [x] Advanced diagnostic script (JSON output)
- [x] Performance analysis tool (health scoring)
- [x] Continuous monitoring service
- [x] Backup & restore tool
- [x] 12 failure pattern library
- [x] Feishu user permission troubleshooting

### v1.0.0 (Released)
- [x] Basic diagnostic features
- [x] Quick troubleshooting checklist
- [x] Troubleshooting decision tree

---

## 🤝 Contributing

Contributions welcome! We need:

- 🐛 **Bug reports**: Found an issue? [Submit an Issue](https://github.com/AIPMAndy/openclaw-doctor/issues)
- 💡 **Feature suggestions**: Have a great idea? [Discussions](https://github.com/AIPMAndy/openclaw-doctor/discussions)
- 📝 **Documentation improvements**: Found errors or unclear parts? Submit a PR
- 🔧 **Code contributions**: See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📚 Related Resources

- [OpenClaw Official Docs](https://openclaw.ai)
- [Feishu Open Platform](https://open.feishu.cn)
- [@larksuite/openclaw-lark Plugin](https://www.npmjs.com/package/@larksuite/openclaw-lark)
- [Detailed Script Docs](scripts/README.md)

---

## 👨‍💻 Author

**AI Chief Andy** | OpenClaw Power User & Feishu Channel Optimization Expert

[![GitHub](https://img.shields.io/badge/GitHub-AIPMAndy-181717?logo=github)](https://github.com/AIPMAndy)
[![WeChat](https://img.shields.io/badge/WeChat-AIPMAndy-07C160?logo=wechat)](https://github.com/AIPMAndy)

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

---

## ⭐ Star History

If this project helped you, please give it a ⭐ Star! Your support motivates continuous updates.

[![Star History Chart](https://api.star-history.com/svg?repos=AIPMAndy/openclaw-doctor&type=Date)](https://star-history.com/#AIPMAndy/openclaw-doctor&Date)

---

<div align="center">

**Made with ❤️ for the OpenClaw community**

[⬆ Back to top](#-openclaw-doctor)

</div>
