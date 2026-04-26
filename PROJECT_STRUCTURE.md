# Project Structure | 项目结构

```
openclaw-doctor/
├── README.md                    # 项目主页（中英双语）
├── LICENSE                      # MIT 许可证
├── CONTRIBUTING.md              # 贡献指南
├── .gitignore                   # Git 忽略文件
├── openclaw-doctor.md           # 核心 skill 文件
├── scripts/                     # 实用脚本
│   ├── README.md               # 脚本使用指南
│   ├── quick-diagnostic.sh     # 快速诊断脚本
│   └── auto-fix.sh             # 自动修复脚本
└── docs/                        # 文档目录（可选）
    ├── troubleshooting.md      # 详细故障排查指南
    ├── examples.md             # 使用示例
    └── faq.md                  # 常见问题
```

## 文件说明

### 核心文件

- **openclaw-doctor.md**: OpenClaw skill 定义文件，包含完整的诊断逻辑和故障模式库
- **README.md**: 项目介绍、安装说明、快速开始指南（中英双语）
- **LICENSE**: MIT 开源许可证
- **CONTRIBUTING.md**: 贡献者指南，说明如何参与项目

### 脚本目录

- **quick-diagnostic.sh**: 快速诊断脚本，检查 Gateway 状态和常见问题
- **auto-fix.sh**: 自动修复脚本，修复常见配置和依赖问题
- **scripts/README.md**: 脚本使用说明

### 文档目录（可选扩展）

未来可以添加更详细的文档：
- 详细的故障排查指南
- 更多使用示例
- FAQ 常见问题解答
- 视频教程链接

## 使用方式

### 作为 OpenClaw Skill

```bash
# 安装到 OpenClaw
cp openclaw-doctor.md ~/.openclaw/skills/

# 在 OpenClaw 中使用
/openclaw-doctor
```

### 作为独立工具

```bash
# 克隆仓库
git clone https://github.com/AIPMAndy/openclaw-doctor.git
cd openclaw-doctor

# 运行诊断
./scripts/quick-diagnostic.sh

# 运行修复
./scripts/auto-fix.sh
```

## 版本管理

使用语义化版本号（Semantic Versioning）：

- **主版本号（Major）**: 不兼容的 API 修改
- **次版本号（Minor）**: 向下兼容的功能性新增
- **修订号（Patch）**: 向下兼容的问题修正

示例：
- v1.0.0 - 初始版本
- v1.1.0 - 添加新的故障模式
- v1.1.1 - 修复文档错误

## 发布流程

1. 更新 CHANGELOG.md
2. 更新版本号
3. 创建 Git tag
4. 推送到 GitHub
5. 创建 GitHub Release

## 维护计划

- 每月更新一次故障模式库
- 及时响应 Issues 和 Pull Requests
- 定期测试脚本兼容性
- 跟进 OpenClaw 版本更新
