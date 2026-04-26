# 贡献指南

感谢你对 OpenClaw Doctor 的关注！

## 如何贡献

### 报告问题

如果你遇到了新的 OpenClaw 故障，请：

1. 在 [Issues](https://github.com/YOUR_USERNAME/openclaw-doctor/issues) 中搜索是否已有类似问题
2. 如果没有，创建新 Issue，包含：
   - 问题描述
   - 错误日志
   - 系统环境（OpenClaw 版本、操作系统）
   - 复现步骤

### 添加新的故障模式

如果你成功解决了一个新问题：

1. Fork 这个仓库
2. 在 `openclaw-doctor.md` 的"常见故障模式"章节添加新条目：
   ```markdown
   **问题 X：[问题标题]**
   - 根本原因：[技术原因]
   - 表现：[用户看到的现象]
   - 诊断：[如何确认是这个问题]
   - 解决：[详细的修复步骤]
   ```
3. 如果需要，更新"快速排查清单"和"故障排查决策树"
4. 提交 Pull Request

### 改进文档

文档改进包括但不限于：
- 修正错别字
- 改进表达清晰度
- 添加示例
- 翻译成其他语言

### 代码规范

- 使用清晰的 Markdown 格式
- 代码块使用正确的语法高亮（bash, json, etc.）
- 保持一致的缩进和格式
- 命令示例要可以直接复制执行

### Pull Request 流程

1. Fork 仓库
2. 创建特性分支：`git checkout -b feature/your-feature-name`
3. 提交更改：`git commit -m "Add: 描述你的更改"`
4. 推送到分支：`git push origin feature/your-feature-name`
5. 创建 Pull Request

### Commit 消息规范

使用清晰的 commit 消息：

- `Add: 添加新功能`
- `Fix: 修复问题`
- `Update: 更新文档或内容`
- `Refactor: 重构代码`

示例：
```
Add: 新增 Telegram 通道故障诊断

- 添加 Telegram getUpdates 冲突问题
- 更新快速排查清单
- 补充诊断命令
```

## 行为准则

- 尊重所有贡献者
- 保持友好和专业
- 接受建设性批评
- 关注项目目标

## 问题？

如果有任何疑问，欢迎在 Issues 中提问或通过 [联系方式] 联系维护者。

感谢你的贡献！🎉
