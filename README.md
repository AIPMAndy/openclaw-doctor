# OpenClaw Doctor | OpenClaw 诊断专家

[English](#english) | [中文](#chinese)

---

<a name="english"></a>
## English

### Overview

OpenClaw Doctor is a professional diagnostic skill for quickly identifying and fixing common issues with OpenClaw Gateway, especially Feishu/Lark channel problems.

### Features

- 🔍 **System Diagnostics**: Auto-detect Gateway status, plugin dependencies, channel connections
- 🛠️ **Issue Resolution**: Detailed fix steps and commands
- 📊 **Decision Tree**: Systematic troubleshooting workflow
- 📝 **Experience Base**: Real-world failure patterns library
- ⚡ **Quick Checklist**: Priority-based problem identification

### Installation

```bash
# Download directly
curl -o ~/.openclaw/skills/openclaw-doctor.md \
  https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/openclaw-doctor.md

# Or clone the repository
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cp openclaw-doctor/openclaw-doctor.md ~/.openclaw/skills/
```

### Usage

Invoke the skill in OpenClaw:

```
/openclaw-doctor
```

Or describe your problem in conversation, and the AI will automatically use this skill for diagnosis.

### Supported Issues

**Feishu Channel**
- Channel auto-restart loop
- Message no response
- WebSocket connection failure
- Config permission errors
- API credential validation

**Gateway**
- Startup failure
- Port conflicts
- Multiple instance conflicts
- Plugin loading errors

**Dependencies**
- npm dependency conflicts
- Installation path errors
- ENOTEMPTY errors
- Lock file issues

### Quick Examples

**Issue: Feishu channel won't start**

```bash
# 1. Check config file permissions
ls -la ~/.openclaw/openclaw.json

# 2. Run diagnostic tool
npx @larksuite/openclaw-lark doctor

# 3. Check required fields
cat ~/.openclaw/openclaw.json | jq '.channels.feishu.accounts.main'

# 4. Fix permissions
chmod 600 ~/.openclaw/openclaw.json

# 5. Restart Gateway
pkill -9 -f openclaw-gateway && openclaw-gateway &
```

### Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### License

MIT License - see [LICENSE](LICENSE) for details.

---

<a name="chinese"></a>
## 中文

### 概述

OpenClaw Doctor 是一个专业的诊断 skill，帮助你快速定位和修复 OpenClaw Gateway 的常见问题，特别是飞书（Lark/Feishu）通道相关的故障。

### 功能特性

- 🔍 **系统诊断**：自动检测 Gateway 状态、插件依赖、通道连接
- 🛠️ **故障修复**：提供详细的修复步骤和命令
- 📊 **决策树**：系统化的故障排查流程
- 📝 **经验总结**：基于真实案例的故障模式库
- ⚡ **快速排查**：优先级清单，快速定位问题

### 安装

```bash
# 直接下载
curl -o ~/.openclaw/skills/openclaw-doctor.md \
  https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/openclaw-doctor.md

# 或克隆仓库
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cp openclaw-doctor/openclaw-doctor.md ~/.openclaw/skills/
```

### 使用方法

在 OpenClaw 中调用 skill：

```
/openclaw-doctor
```

或者在对话中描述问题，AI 会自动使用这个 skill 进行诊断。

### 支持的问题类型

**飞书通道问题**
- 通道反复 auto-restart
- 消息无响应
- WebSocket 连接失败
- 配置权限错误
- API 凭证验证

**Gateway 问题**
- 启动失败
- 端口占用
- 多实例冲突
- 插件加载失败

**依赖问题**
- npm 依赖冲突
- 依赖安装路径错误
- ENOTEMPTY 错误
- 依赖锁文件问题

### 快速排查示例

**问题：飞书通道无法启动**

```bash
# 1. 检查配置文件权限
ls -la ~/.openclaw/openclaw.json

# 2. 运行诊断工具
npx @larksuite/openclaw-lark doctor

# 3. 检查必需字段
cat ~/.openclaw/openclaw.json | jq '.channels.feishu.accounts.main'

# 4. 修复权限
chmod 600 ~/.openclaw/openclaw.json

# 5. 重启 Gateway
pkill -9 -f openclaw-gateway && openclaw-gateway &
```

### 常见问题 FAQ

#### Q: 飞书通道一直显示 "auto-restart attempt X/10"？

**A:** 这通常是配置缺少必需字段。检查你的 `openclaw.json` 是否包含：
- `appId`
- `appSecret`
- `verificationToken` ⚠️ 最常缺少
- `encryptKey` ⚠️ 最常缺少
- `connectionMode: "long-polling"`

从飞书开放平台获取这些凭证：https://open.feishu.cn/app → 选择应用 → "事件订阅"

#### Q: 如何验证飞书 API 凭证是否有效？

**A:** 使用 curl 测试：

```bash
curl -X POST 'https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal' \
  -H 'Content-Type: application/json' \
  -d '{
    "app_id": "YOUR_APP_ID",
    "app_secret": "YOUR_APP_SECRET"
  }'
```

成功返回示例：
```json
{
  "code": 0,
  "msg": "ok",
  "tenant_access_token": "t-xxx..."
}
```

### 贡献

欢迎贡献！详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

### 许可证

MIT License - 详见 [LICENSE](LICENSE)。

### 相关资源

- [OpenClaw 官方文档](https://openclaw.ai)
- [飞书开放平台](https://open.feishu.cn)
- [@larksuite/openclaw-lark 插件](https://www.npmjs.com/package/@larksuite/openclaw-lark)

### 更新日志

#### v1.0.0 (2026-04-26)
- ✨ 初始版本
- 📝 添加 8 种常见故障模式
- 🔍 添加快速排查清单
- 🌲 添加故障排查决策树
- 📚 添加详细的诊断流程
