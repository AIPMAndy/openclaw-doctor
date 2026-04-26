# GitHub Release Checklist | GitHub 发布清单

## 发布前准备

### 1. 代码检查
- [ ] 所有文件已提交到 Git
- [ ] 代码格式统一
- [ ] 脚本已测试并可执行
- [ ] 文档链接正确
- [ ] 示例代码可运行

### 2. 文档完善
- [ ] README.md 完整且准确
- [ ] CHANGELOG.md 已更新
- [ ] LICENSE 文件存在
- [ ] CONTRIBUTING.md 清晰
- [ ] 所有脚本有使用说明

### 3. 测试验证
- [ ] quick-diagnostic.sh 在 macOS 上测试通过
- [ ] quick-diagnostic.sh 在 Linux 上测试通过
- [ ] auto-fix.sh 交互式确认正常
- [ ] openclaw-doctor.md 在 OpenClaw 中可用
- [ ] 所有命令示例已验证

### 4. 版本信息
- [ ] 版本号已确定（v1.0.0）
- [ ] CHANGELOG.md 包含此版本
- [ ] README.md 中的版本号已更新
- [ ] Git tag 已准备

## 创建 GitHub 仓库

### 1. 初始化仓库

```bash
cd ~/.openclaw/skills/openclaw-doctor

# 初始化 Git（如果还没有）
git init

# 添加所有文件
git add .

# 首次提交
git commit -m "Initial commit: OpenClaw Doctor v1.0.0"
```

### 2. 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 仓库名称：`openclaw-doctor`
3. 描述：`OpenClaw system diagnostic and troubleshooting skill`
4. 选择 Public
5. 不要初始化 README（我们已有）
6. 创建仓库

### 3. 推送到 GitHub

```bash
# 添加远程仓库（替换 AIPMAndy）
git remote add origin https://github.com/AIPMAndy/openclaw-doctor.git

# 推送主分支
git branch -M main
git push -u origin main
```

### 4. 创建 Release

```bash
# 创建并推送 tag
git tag -a v1.0.0 -m "Release v1.0.0: Initial public release"
git push origin v1.0.0
```

然后在 GitHub 上：
1. 进入仓库页面
2. 点击 "Releases" → "Create a new release"
3. 选择 tag: v1.0.0
4. Release title: `v1.0.0 - Initial Release`
5. 描述使用以下模板：

```markdown
# OpenClaw Doctor v1.0.0

🎉 Initial public release!

## What's New

- ✨ Complete diagnostic skill for OpenClaw Gateway
- 🔍 8 common failure patterns with solutions
- 🛠️ Automated diagnostic and fix scripts
- 📖 Bilingual documentation (English/Chinese)

## Features

- Quick diagnostic script
- Auto-fix script with interactive confirmation
- Troubleshooting decision tree
- Detailed failure pattern library
- Command reference guide

## Installation

```bash
curl -o ~/.openclaw/skills/openclaw-doctor.md \
  https://raw.githubusercontent.com/AIPMAndy/openclaw-doctor/main/openclaw-doctor.md
```

## Quick Start

```bash
# In OpenClaw
/openclaw-doctor

# Or use scripts
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor/scripts
./quick-diagnostic.sh
```

## Documentation

- [README](https://github.com/AIPMAndy/openclaw-doctor#readme)
- [Scripts Guide](scripts/README.md)
- [Contributing](CONTRIBUTING.md)

## Feedback

Found a bug or have a suggestion? [Open an issue](https://github.com/AIPMAndy/openclaw-doctor/issues)!

---

**Full Changelog**: https://github.com/AIPMAndy/openclaw-doctor/blob/main/CHANGELOG.md
```

6. 点击 "Publish release"

## 发布后

### 1. 社区推广
- [ ] 在 OpenClaw 社区分享
- [ ] 在相关论坛发帖
- [ ] 社交媒体宣传
- [ ] 添加到 awesome-openclaw 列表（如果有）

### 2. 文档更新
- [ ] 更新 README 中的 GitHub 链接
- [ ] 添加 badges（stars, license, version）
- [ ] 创建 GitHub Pages（可选）

### 3. 监控反馈
- [ ] 关注 GitHub Issues
- [ ] 回复用户问题
- [ ] 收集改进建议
- [ ] 计划下一版本

## Badges 示例

在 README.md 顶部添加：

```markdown
![GitHub release](https://img.shields.io/github/v/release/AIPMAndy/openclaw-doctor)
![License](https://img.shields.io/github/license/AIPMAndy/openclaw-doctor)
![GitHub stars](https://img.shields.io/github/stars/AIPMAndy/openclaw-doctor)
![GitHub issues](https://img.shields.io/github/issues/AIPMAndy/openclaw-doctor)
```

## 持续维护

- 每月检查 Issues
- 定期更新故障模式
- 跟进 OpenClaw 版本更新
- 响应 Pull Requests
- 更新文档

---

**准备好了吗？开始发布吧！** 🚀
