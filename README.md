<div align="center">

# 🔧 OpenClaw Doctor

**5 分钟诊断并修复 OpenClaw Gateway 故障 | 专为飞书通道优化**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/AIPMAndy/openclaw-doctor?style=social)](https://github.com/AIPMAndy/openclaw-doctor/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/AIPMAndy/openclaw-doctor)](https://github.com/AIPMAndy/openclaw-doctor/issues)

[English](README_EN.md) | **简体中文**

<img src="assets/demo.gif" width="700" alt="OpenClaw Doctor Demo">

*一键诊断 → 自动修复 → 持续监控*

</div>

---

## 🆚 为什么选 OpenClaw Doctor？

| 能力 | 手动排查 | OpenClaw Doctor |
|------|:--------:|:---------------:|
| 诊断速度 | 30-60 分钟 | **5 分钟** ✅ |
| 故障模式库 | 靠经验 | **12+ 真实案例** ✅ |
| 自动修复 | ❌ | **一键修复** ✅ |
| 持续监控 | ❌ | **24/7 监控** ✅ |
| 飞书通道专项 | ❌ | **深度优化** ✅ |
| 飞书平台监控 | ❌ | **自动追踪更新** ✅ |
| CI/CD 集成 | ❌ | **JSON 输出** ✅ |

**核心差异**：不只是诊断工具，而是完整的 OpenClaw 健康管理系统 + 飞书开放平台更新监控。

---

## 🚀 30 秒快速开始

```bash
# 一行安装
curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash

# 一行诊断
openclaw-doctor

# 看到结果
✓ Gateway 运行正常
✓ 端口 18789 正常监听
✗ 飞书通道配置不完整 → 自动修复建议
```

**就这么简单！**

---

## 💡 核心功能

### 🔍 智能诊断系统
- **5 分钟全面体检**：Gateway 状态、插件依赖、通道连接一次检查
- **12+ 故障模式库**：基于真实案例的故障识别
- **优先级排序**：自动识别最紧急的问题

### 🛠️ 自动修复工具
- **一键修复**：常见问题自动修复（权限、配置、依赖）
- **安全备份**：修复前自动备份，支持一键回滚
- **修复验证**：修复后自动验证是否生效

### 📊 性能分析
- **健康评分系统**：0-100 分量化 Gateway 健康度
- **资源监控**：CPU、内存、文件描述符实时追踪
- **性能建议**：根据分析结果给出优化建议

### 🔄 持续监控
- **24/7 监控**：后台持续检查 Gateway 状态
- **自动告警**：连续失败自动通知
- **历史记录**：完整的健康状态历史

### 🎯 飞书通道专项
- **用户权限问题排查**：详细的 OAuth 授权流程指导
- **WebSocket vs Long-Polling**：自动识别并建议最佳连接模式
- **API 凭证验证**：一键检查 appId、appSecret 配置
- **消息无响应诊断**：定位 agent 启动延迟问题
- **🆕 飞书平台更新监控**：自动追踪飞书 API、CLI 和文档更新
  - 监控飞书开放平台 API 更新日志
  - 追踪飞书 CLI GitHub releases
  - 检测开放平台文档变化
  - 自动缓存和对比，只通知真实更新

---

## 📦 安装方式

### 方式一：快速安装（推荐）
```bash
curl -fsSL https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/install.sh | bash
```

### 方式二：手动安装
```bash
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor
./install.sh
```

### 方式三：仅安装 Skill
```bash
cp openclaw-doctor.md ~/.openclaw/skills/
```

---

## 🎬 使用场景

### 场景 1：日常健康检查
```bash
# 每天早上运行一次
./scripts/quick-diagnostic.sh
```

### 场景 2：故障紧急排查
```bash
# Gateway 挂了？消息不响应？
./scripts/advanced-diagnostic.sh

# 查看详细分析和修复建议
```

### 场景 3：性能优化
```bash
# Gateway 变慢了？
./scripts/performance-analyzer.sh

# 获得健康评分和优化建议
```

### 场景 4：CI/CD 集成
```bash
# 部署前自动检查
./scripts/advanced-diagnostic.sh --json > diagnostic.json
if [ $? -ne 0 ]; then
  echo "健康检查失败，停止部署"
  exit 1
fi
```

### 场景 5：持续监控
```bash
# 后台运行，自动告警
nohup ./scripts/health-monitor.sh --interval 60 --threshold 3 > /tmp/monitor.log 2>&1 &
```

### 场景 6：飞书平台更新监控
```bash
# 检查飞书开放平台更新
./scripts/feishu-monitor.sh

# 查看监控日志
cat ~/.openclaw/cache/feishu-monitor/monitor.log

# 集成到 openclaw doctor
openclaw-doctor --check feishu-updates
```

---

## 🛠️ 工具箱

| 工具 | 用途 | 输出 | 耗时 |
|------|------|------|------|
| `quick-diagnostic.sh` | 日常健康检查 | 文本报告 | ~10s |
| `advanced-diagnostic.sh` | 全面深度分析 | 文本/JSON | ~30s |
| `performance-analyzer.sh` | 性能分析+评分 | 文本+评分 | ~20s |
| `health-monitor.sh` | 持续监控 | 日志文件 | 持续 |
| `feishu-monitor.sh` | 🆕 飞书平台更新监控 | 日志文件 | ~15s |
| `auto-fix.sh` | 自动修复 | 交互式 | ~2min |
| `backup-restore.sh` | 配置管理 | 交互式 | ~10s |

---

## 📝 支持的问题类型

### 飞书通道问题（12 种模式）
- ✅ 通道反复 auto-restart
- ✅ 消息无响应
- ✅ WebSocket 连接失败
- ✅ 配置权限错误
- ✅ API 凭证验证失败
- ✅ 用户权限问题（OAuth 授权）
- ✅ 内存泄漏
- ✅ 文件描述符耗尽
- ✅ 依赖版本冲突
- ✅ 消息发送失败
- ✅ 群聊权限问题
- ✅ 事件订阅异常

### Gateway 问题
- ✅ 启动失败
- ✅ 端口占用
- ✅ 多实例冲突
- ✅ 插件加载失败
- ✅ 性能下降

### 依赖问题
- ✅ npm 依赖冲突
- ✅ 依赖安装路径错误
- ✅ ENOTEMPTY 错误
- ✅ 依赖锁文件问题

---

## 🎯 快速示例

### 示例 1：飞书通道一直 auto-restart？
```bash
$ ./scripts/advanced-diagnostic.sh

🔍 检测到问题：
✗ 飞书通道配置缺少 verificationToken

💡 修复建议：
1. 打开 ~/.openclaw/openclaw.json
2. 在 channels.feishu.accounts.xxx 中添加：
   "verificationToken": "your_token_here"
3. 重启 Gateway

🔧 自动修复：
$ ./scripts/auto-fix.sh
```

### 示例 2：用户权限问题？
```bash
$ ./scripts/advanced-diagnostic.sh

🔍 检测到问题：
✗ 用户权限不足

💡 修复建议：
1. 发送 /feishu auth 完成个人授权
2. 删除配置中的 default_user_open_id
3. 确认权限类型为"用户级权限"
4. 重新授权

📚 详细文档：
https://bytedance.larkoffice.com/docx/MFK7dDFLFoVlOGxWCv5cTXKmnMh
```

### 示例 3：性能下降？
```bash
$ ./scripts/performance-analyzer.sh

📊 健康评分：72/100

⚠️ 发现问题：
- CPU 使用率偏高：15.3%
- 内存占用：4.2GB（建议 < 3GB）
- 文件描述符：1024/4096

💡 优化建议：
1. 重启 Gateway 释放内存
2. 增加文件描述符限制：ulimit -n 8192
3. 检查是否有内存泄漏
```

---

## 🔄 自动化集成

### Cron 定时任务
```bash
# 编辑 crontab
crontab -e

# 每小时健康检查
0 * * * * /path/to/scripts/advanced-diagnostic.sh >> /tmp/health.log 2>&1

# 每天凌晨 2 点备份
0 2 * * * /path/to/scripts/backup-restore.sh backup >> /tmp/backup.log 2>&1

# 每周日清理旧备份
0 3 * * 0 /path/to/scripts/backup-restore.sh clean >> /tmp/backup.log 2>&1
```

### CI/CD 集成
```yaml
# GitHub Actions 示例
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

### v1.2.0（计划中）
- [ ] Web UI 控制面板
- [ ] 实时性能图表
- [ ] 邮件/钉钉/企微告警
- [ ] 更多通道支持（Telegram、Discord）

### v1.1.0（已发布）
- [x] 高级诊断脚本（JSON 输出）
- [x] 性能分析工具（健康评分）
- [x] 持续监控服务
- [x] 备份恢复工具
- [x] 12 种故障模式库
- [x] 飞书用户权限问题排查

### v1.0.0（已发布）
- [x] 基础诊断功能
- [x] 快速排查清单
- [x] 故障排查决策树

---

## 🤝 贡献指南

欢迎贡献！我们需要：

- 🐛 **Bug 报告**：遇到问题？[提交 Issue](https://github.com/AIPMAndy/openclaw-doctor/issues)
- 💡 **功能建议**：有好想法？[讨论区](https://github.com/AIPMAndy/openclaw-doctor/discussions)
- 📝 **文档改进**：发现错误或不清楚的地方？提交 PR
- 🔧 **代码贡献**：查看 [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📚 相关资源

- [OpenClaw 官方文档](https://openclaw.ai)
- [飞书开放平台](https://open.feishu.cn)
- [@larksuite/openclaw-lark 插件](https://www.npmjs.com/package/@larksuite/openclaw-lark)
- [详细脚本文档](scripts/README.md)

---

## 👨‍💻 作者

**AI酋长Andy** | OpenClaw 深度用户 & 飞书通道优化专家

[![GitHub](https://img.shields.io/badge/GitHub-AIPMAndy-181717?logo=github)](https://github.com/AIPMAndy)
[![微信](https://img.shields.io/badge/微信-AIPMAndy-07C160?logo=wechat)](https://github.com/AIPMAndy)

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## ⭐ Star History

如果这个项目帮到了你，请给个 ⭐ Star！你的支持是我持续更新的动力。

[![Star History Chart](https://api.star-history.com/svg?repos=AIPMAndy/openclaw-doctor&type=Date)](https://star-history.com/#AIPMAndy/openclaw-doctor&Date)

---

<div align="center">

**Made with ❤️ for the OpenClaw community**

[⬆ 回到顶部](#-openclaw-doctor)

</div>
