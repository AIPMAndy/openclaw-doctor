# OpenClaw Doctor Scripts | 脚本工具集

This directory contains utility scripts for diagnosing, monitoring, and maintaining OpenClaw Gateway.

本目录包含用于诊断、监控和维护 OpenClaw Gateway 的实用脚本。

## Scripts Overview | 脚本概览

### 1. quick-diagnostic.sh
**Quick health check for OpenClaw Gateway**

快速健康检查工具，适合日常使用。

**Usage:**
```bash
./scripts/quick-diagnostic.sh
```

**Checks:**
- Gateway process status
- Port 18789 listening
- Config file permissions
- Feishu plugin diagnostics
- Recent log errors
- npm dependency conflicts

**Output:** Text-based report with actionable recommendations

---

### 2. advanced-diagnostic.sh
**Comprehensive system analysis with JSON support**

全面的系统分析工具，支持 JSON 输出，适合自动化集成。

**Usage:**
```bash
# Text output
./scripts/advanced-diagnostic.sh

# JSON output (for automation)
./scripts/advanced-diagnostic.sh --json

# Show version
./scripts/advanced-diagnostic.sh --version

# Show help
./scripts/advanced-diagnostic.sh --help
```

**Checks (10+ items):**
- Gateway process (PID, CPU, memory)
- Port status
- Config file (permissions, validity, JSON syntax)
- Feishu config completeness
- Multiple instance detection
- npm dependency conflicts
- Plugin dependencies
- Log error statistics
- Auto-restart count
- Disk space usage
- Node.js and npm versions

**Exit codes:**
- `0`: All checks passed
- `1`: Issues found

**JSON Output Example:**
```json
{
  "version": "1.1.0",
  "timestamp": "2026-04-27T00:00:00Z",
  "issues_found": 2,
  "checks": {
    "gateway_process": {
      "status": "pass",
      "message": "Gateway is running (PID: 12345)",
      "severity": "info"
    },
    "config_permissions": {
      "status": "fail",
      "message": "Config file permissions are incorrect",
      "severity": "error"
    }
  }
}
```

---

### 3. performance-analyzer.sh
**Analyze Gateway performance metrics**

性能分析工具，深入分析 Gateway 资源使用情况。

**Usage:**
```bash
./scripts/performance-analyzer.sh
```

**Analysis:**
- CPU and memory usage
- Open file descriptors
- Network connections
- Thread count
- Log statistics (24 hours)
- Response time analysis
- Dependency storage size
- Gateway uptime
- **Health Score (0-100)**

**Health Score Calculation:**
- Starts at 100
- Deducts points for issues:
  - Too many open files (>1000): -20
  - High CPU usage (>80%): -15
  - High memory usage (>50%): -15
  - High error count (>50): -25
  - Moderate errors (>10): -10

**Score Ratings:**
- 90-100: Excellent ✅
- 70-89: Good ✓
- 50-69: Fair ⚠️
- 0-49: Poor ❌

---

### 4. health-monitor.sh
**Continuous health monitoring service**

持续健康监控服务，自动检测问题并发出警报。

**Usage:**
```bash
# Start monitoring (default: check every 60s)
./scripts/health-monitor.sh

# Custom interval and threshold
./scripts/health-monitor.sh --interval 30 --threshold 5

# Custom log file
./scripts/health-monitor.sh --log /var/log/openclaw-monitor.log

# Show help
./scripts/health-monitor.sh --help
```

**Options:**
- `--interval N`: Check interval in seconds (default: 60)
- `--threshold N`: Alert after N consecutive failures (default: 3)
- `--log FILE`: Log file path (default: /tmp/openclaw-doctor-monitor.log)

**Monitoring:**
- Gateway process status
- Port 18789 listening
- Recent error rate in logs
- Status changes logged with timestamps

**Status Levels:**
- `healthy`: All checks passed ✅
- `degraded`: High error rate but running ⚠️
- `unhealthy`: Critical issues detected ❌

**Auto-restart (Optional):**
Uncomment the auto-restart section in the script to enable automatic recovery.

**Run as background service:**
```bash
nohup ./scripts/health-monitor.sh > /tmp/monitor.log 2>&1 &
```

---

### 5. auto-fix.sh
**Automated issue resolution**

自动修复常见问题的工具。

**Usage:**
```bash
./scripts/auto-fix.sh
```

**Fixes:**
1. Config file permissions (chmod 600)
2. Multiple Gateway instances (kill duplicates)
3. npm dependency conflicts (move ~/node_modules)
4. Dependency locks (clear stale locks)
5. Gateway restart

**Safety:**
- Asks for confirmation before each action
- Creates safety backup before restore
- Non-destructive by default

---

### 6. backup-restore.sh
**Backup and restore OpenClaw configuration**

备份和恢复 OpenClaw 配置的工具。

**Usage:**
```bash
# Create backup
./scripts/backup-restore.sh backup

# List all backups
./scripts/backup-restore.sh list

# Restore from backup
./scripts/backup-restore.sh restore 20260427_120000

# Clean old backups (keep last 10)
./scripts/backup-restore.sh clean

# Show help
./scripts/backup-restore.sh --help
```

**Backup Contents:**
- `openclaw.json` configuration file
- `skills/` directory
- `plugins/` directory (if exists)
- Metadata (timestamp, versions)

**Backup Location:**
`~/.openclaw-backups/openclaw_backup_YYYYMMDD_HHMMSS.tar.gz`

**Safety Features:**
- Creates safety backup before restore
- Requires user confirmation
- Automatically sets correct permissions
- Keeps metadata for tracking

---

## Usage Scenarios | 使用场景

### Daily Health Check | 日常健康检查
```bash
./scripts/quick-diagnostic.sh
```

### Deep Troubleshooting | 深度故障排查
```bash
./scripts/advanced-diagnostic.sh
./scripts/performance-analyzer.sh
```

### Continuous Monitoring | 持续监控
```bash
# Start in background
nohup ./scripts/health-monitor.sh --interval 60 --threshold 3 > /tmp/monitor.log 2>&1 &

# Check monitor log
tail -f /tmp/monitor.log
```

### Before Configuration Changes | 配置变更前
```bash
# Create backup
./scripts/backup-restore.sh backup

# Make changes...

# If something goes wrong, restore
./scripts/backup-restore.sh restore <backup_date>
```

### CI/CD Integration | CI/CD 集成
```bash
# Run diagnostic and fail if issues found
./scripts/advanced-diagnostic.sh --json > diagnostic.json
if [ $? -ne 0 ]; then
  echo "Health check failed"
  cat diagnostic.json
  exit 1
fi
```

### Performance Optimization | 性能优化
```bash
# Analyze current performance
./scripts/performance-analyzer.sh

# Check health score
# If score < 70, investigate issues
```

---

## Automation Examples | 自动化示例

### Cron Jobs | 定时任务

```bash
# Edit crontab
crontab -e

# Add these lines:

# Hourly health check
0 * * * * /path/to/openclaw-doctor/scripts/advanced-diagnostic.sh >> /tmp/openclaw-health.log 2>&1

# Daily backup at 2 AM
0 2 * * * /path/to/openclaw-doctor/scripts/backup-restore.sh backup >> /tmp/openclaw-backup.log 2>&1

# Weekly cleanup on Sunday at 3 AM
0 3 * * 0 /path/to/openclaw-doctor/scripts/backup-restore.sh clean >> /tmp/openclaw-backup.log 2>&1

# Daily performance report at 6 AM
0 6 * * * /path/to/openclaw-doctor/scripts/performance-analyzer.sh >> /tmp/openclaw-performance.log 2>&1
```

### systemd Service | 系统服务

Create `/etc/systemd/system/openclaw-monitor.service`:

```ini
[Unit]
Description=OpenClaw Health Monitor
After=network.target

[Service]
Type=simple
User=your-user
ExecStart=/path/to/openclaw-doctor/scripts/health-monitor.sh --interval 60 --threshold 3
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable openclaw-monitor
sudo systemctl start openclaw-monitor
sudo systemctl status openclaw-monitor
```

---

## Troubleshooting | 故障排查

### Script Permission Denied
```bash
chmod +x scripts/*.sh
```

### Command Not Found
```bash
# Ensure you're in the openclaw-doctor directory
cd /path/to/openclaw-doctor

# Or use absolute path
/path/to/openclaw-doctor/scripts/quick-diagnostic.sh
```

### jq Not Found
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# CentOS/RHEL
sudo yum install jq
```

### lsof Not Found
Usually pre-installed on Unix systems. If missing:
```bash
# Ubuntu/Debian
sudo apt-get install lsof

# macOS (should be pre-installed)
# If missing, install via Xcode Command Line Tools
xcode-select --install
```

---

## Best Practices | 最佳实践

1. **Run quick-diagnostic.sh daily** for routine checks
2. **Use advanced-diagnostic.sh** when issues occur
3. **Enable health-monitor.sh** for production environments
4. **Create backups** before making configuration changes
5. **Review performance-analyzer.sh** weekly
6. **Set up cron jobs** for automated monitoring
7. **Keep scripts updated** with the latest version

---

## Contributing | 贡献

Found a bug or have a feature request? Please open an issue:
https://github.com/AIPMAndy/openclaw-doctor/issues

Want to contribute? See [CONTRIBUTING.md](../CONTRIBUTING.md)

---

## License | 许可证

MIT License - see [LICENSE](../LICENSE)
