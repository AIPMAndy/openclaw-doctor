# Assets 目录

## demo.gif

这里需要放置一个演示 GIF，展示 OpenClaw Doctor 的使用过程。

### 建议录制内容（30-60秒）

1. **启动诊断**（5秒）
   ```bash
   ./scripts/quick-diagnostic.sh
   ```

2. **显示诊断结果**（10秒）
   - ✓ Gateway 运行正常
   - ✓ 端口监听正常
   - ✗ 飞书通道配置问题

3. **自动修复**（10秒）
   ```bash
   ./scripts/auto-fix.sh
   ```

4. **修复完成**（5秒）
   - 显示修复成功的绿色提示

### 录制工具推荐

- **终端录制**: [asciinema](https://asciinema.org/)
- **转 GIF**: [terminalizer](https://github.com/faressoft/terminalizer)
- **桌面录制**: [LICEcap](https://www.cockos.com/licecap/)

### 录制技巧

- 使用大字体（16-18pt）
- 窗口宽度 80-100 列
- 放慢操作速度（每个命令停顿 2-3 秒）
- 使用清晰的终端主题（推荐 Solarized Dark）
