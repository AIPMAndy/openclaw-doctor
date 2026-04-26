# Project Structure | 项目结构

```
openclaw-doctor/
├── README.md                           # 项目主页（中英双语）
├── LICENSE                             # MIT 许可证
├── CONTRIBUTING.md                     # 贡献指南
├── CHANGELOG.md                        # 更新日志
├── PROJECT_STRUCTURE.md                # 本文件 - 项目结构说明
├── RELEASE_CHECKLIST.md                # 发布检查清单
├── .gitignore                          # Git 忽略文件
├── openclaw-doctor.md                  # 核心 skill 文件（增强版）
├── install.sh                          # 一键安装脚本
├── uninstall.sh                        # 卸载脚本
└── scripts/                            # 实用脚本目录
    ├── README.md                       # 脚本详细文档
    ├── quick-diagnostic.sh             # 快速诊断脚本
    ├── advanced-diagnostic.sh          # 高级诊断脚本（新增 v1.1.0）
    ├── performance-analyzer.sh         # 性能分析脚本（新增 v1.1.0）
    ├── health-monitor.sh               # 健康监控脚本（新增 v1.1.0）
    ├── backup-restore.sh               # 备份恢复脚本（新增 v1.1.0）
    └── auto-fix.sh                     # 自动修复脚本
```

## 文件说明

### 核心文件

#### openclaw-doctor.md
OpenClaw skill 定义文件，包含：
- 完整的诊断逻辑和故障模式库（12+ 种场景）
- 故障排查决策树
- 详细的修复步骤
- 高级诊断功能说明
- 性能优化建议
- 最佳实践指南
- 自动化集成示例

**版本历史：**
- v1.0.0: 8 种故障模式
- v1.1.0: 12 种故障模式，新增高级功能章节

#### README.md
项目介绍文档，包含：
- 项目概述（中英双语）
- 功能特性列表
- 安装说明（快速安装 + 手动安装）
- 使用方法（skill + 独立工具）
- 支持的问题类型
- 工具概览表格
- 快速示例
- 自动化配置
- FAQ 常见问题
- 更新日志摘要

#### LICENSE
MIT 开源许可证

#### CONTRIBUTING.md
贡献者指南，说明：
- 如何报告 bug
- 如何提交功能请求
- 代码贡献流程
- 代码规范
- 提交信息格式

#### CHANGELOG.md
详细的版本更新日志：
- 遵循 Keep a Changelog 格式
- 语义化版本号
- 每个版本的新增、改进、修复
- 版本对比
- 未来计划
- 迁移指南

#### PROJECT_STRUCTURE.md
本文件，项目结构说明

#### RELEASE_CHECKLIST.md
发布前检查清单

### 安装脚本

#### install.sh
一键安装脚本，功能：
- 检查 OpenClaw 目录
- 创建 skills 目录
- 下载 skill 文件
- 可选下载诊断脚本
- 设置执行权限
- 显示安装结果和使用说明

#### uninstall.sh
卸载脚本，功能：
- 移除 skill 文件
- 可选移除脚本目录
- 确认提示
- 保留用户数据选项

### 脚本目录

#### scripts/README.md
脚本详细文档，包含：
- 每个脚本的详细说明
- 使用方法和参数
- 输出格式说明
- 使用场景示例
- 自动化集成示例（cron、systemd）
- 故障排查指南
- 最佳实践

#### scripts/quick-diagnostic.sh
**快速诊断脚本**

**功能：**
- Gateway 进程检查
- 端口监听检查
- 配置文件权限检查
- 飞书插件诊断
- 最近日志错误
- npm 依赖冲突检查

**输出：** 文本报告，带颜色标识

**适用场景：** 日常健康检查

#### scripts/advanced-diagnostic.sh ⭐ 新增
**高级诊断脚本**

**功能：**
- 10+ 项系统检查
- JSON 输出支持
- 退出码支持（自动化）
- 详细问题报告
- 严重级别分类（info/warning/error）
- 可操作的修复建议

**参数：**
- `--json`: JSON 格式输出
- `--version`: 显示版本
- `--help`: 显示帮助

**输出：** 文本或 JSON

**适用场景：** 深度故障排查、CI/CD 集成

#### scripts/performance-analyzer.sh ⭐ 新增
**性能分析脚本**

**功能：**
- CPU 和内存使用率
- 打开的文件描述符
- 网络连接状态
- 线程信息
- 日志统计（24 小时）
- 响应时间分析
- 依赖存储大小
- Gateway 运行时间
- **健康评分（0-100）**

**评分系统：**
- 90-100: Excellent ✅
- 70-89: Good ✓
- 50-69: Fair ⚠️
- 0-49: Poor ❌

**输出：** 详细的性能报告

**适用场景：** 性能优化、资源监控

#### scripts/health-monitor.sh ⭐ 新增
**健康监控脚本**

**功能：**
- 持续监控 Gateway 状态
- 可配置检查间隔
- 告警阈值设置
- 状态变化日志
- 可选自动重启
- 后台服务支持

**参数：**
- `--interval N`: 检查间隔（秒）
- `--threshold N`: 告警阈值
- `--log FILE`: 日志文件路径
- `--help`: 显示帮助

**状态级别：**
- healthy: 所有检查通过 ✅
- degraded: 错误率高但运行中 ⚠️
- unhealthy: 严重问题 ❌

**输出：** 持续日志输出

**适用场景：** 生产环境监控、自动告警

#### scripts/backup-restore.sh ⭐ 新增
**备份恢复脚本**

**功能：**
- 一键配置备份
- 列出所有备份
- 安全恢复（带确认）
- 恢复前自动安全备份
- 清理旧备份（保留最近 10 个）
- 元数据跟踪

**命令：**
- `backup`: 创建备份
- `list`: 列出备份
- `restore <date>`: 恢复备份
- `clean`: 清理旧备份
- `--help`: 显示帮助

**备份内容：**
- openclaw.json
- skills/
- plugins/（如果存在）
- metadata.txt

**备份位置：** `~/.openclaw-backups/`

**输出：** 交互式操作

**适用场景：** 配置变更前、灾难恢复

#### scripts/auto-fix.sh
**自动修复脚本**

**功能：**
- 修复配置文件权限
- 杀掉多余 Gateway 实例
- 移除 ~/node_modules 冲突
- 清理依赖锁
- 重启 Gateway

**输出：** 交互式操作（需确认）

**适用场景：** 快速修复常见问题

## 使用方式

### 作为 OpenClaw Skill

```bash
# 安装
cp openclaw-doctor.md ~/.openclaw/skills/

# 在 OpenClaw 中使用
/openclaw-doctor
```

### 作为独立工具

```bash
# 克隆仓库
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor

# 日常检查
./scripts/quick-diagnostic.sh

# 深度诊断
./scripts/advanced-diagnostic.sh

# 性能分析
./scripts/performance-analyzer.sh

# 启动监控
./scripts/health-monitor.sh

# 备份配置
./scripts/backup-restore.sh backup

# 自动修复
./scripts/auto-fix.sh
```

## 版本管理

使用语义化版本号（Semantic Versioning）：

- **主版本号（Major）**: 不兼容的 API 修改
- **次版本号（Minor）**: 向下兼容的功能性新增
- **修订号（Patch）**: 向下兼容的问题修正

### 版本历史

- **v1.1.0** (2026-04-27) - 深度优化版
  - 新增 4 个脚本工具
  - 扩展故障模式库
  - 完善文档
  - 自动化支持

- **v1.0.0** (2026-04-26) - 初始版本
  - 核心 skill 文件
  - 2 个基础脚本
  - 基础文档

## 发布流程

1. 更新 CHANGELOG.md
2. 更新 README.md 版本信息
3. 更新 openclaw-doctor.md 版本历史
4. 更新脚本版本号
5. 提交代码
6. 创建 Git tag: `git tag v1.1.0`
7. 推送到 GitHub: `git push origin v1.1.0`
8. 创建 GitHub Release
9. 更新文档网站（如果有）

## 维护计划

### 定期维护
- 每月更新一次故障模式库
- 及时响应 Issues 和 Pull Requests
- 定期测试脚本兼容性
- 跟进 OpenClaw 版本更新

### 质量保证
- 所有脚本必须通过 shellcheck
- 新功能需要文档说明
- 重大变更需要迁移指南
- 保持向后兼容性

### 社区互动
- 收集用户反馈
- 整理常见问题
- 分享最佳实践
- 举办线上讨论

## 技术栈

- **Shell**: Bash 4.0+
- **工具**: jq, lsof, ps, grep, awk, sed
- **平台**: macOS, Linux
- **依赖**: Node.js, npm, OpenClaw

## 文件大小统计

```
openclaw-doctor.md          ~15 KB  (核心 skill)
README.md                   ~12 KB  (项目文档)
CHANGELOG.md                ~8 KB   (更新日志)
scripts/README.md           ~10 KB  (脚本文档)
scripts/*.sh                ~25 KB  (所有脚本)
Total                       ~70 KB  (整个项目)
```

## 贡献统计

欢迎查看 [GitHub Insights](https://github.com/AIPMAndy/openclaw-doctor/graphs/contributors) 了解贡献者信息。

## 相关链接

- [GitHub Repository](https://github.com/AIPMAndy/openclaw-doctor)
- [Issue Tracker](https://github.com/AIPMAndy/openclaw-doctor/issues)
- [OpenClaw Official](https://openclaw.ai)
- [Feishu Open Platform](https://open.feishu.cn)

---

**Last Updated:** 2026-04-27
**Version:** 1.1.0
