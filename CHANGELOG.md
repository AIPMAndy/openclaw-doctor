# Changelog | 更新日志

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-04-27

### Added - 新增功能

#### New Scripts | 新增脚本
- ✨ **advanced-diagnostic.sh** - Comprehensive diagnostic tool with JSON output support
  - 10+ system checks (process, ports, config, logs, resources)
  - JSON output for CI/CD integration
  - Exit codes for automation
  - Detailed issue reporting with severity levels
  
- 📊 **performance-analyzer.sh** - Performance analysis tool
  - CPU and memory usage tracking
  - Open file descriptor monitoring
  - Network connection analysis
  - Thread information
  - Log statistics (24 hours)
  - Response time analysis
  - Dependency storage size
  - Health score calculation (0-100)
  
- 🔍 **health-monitor.sh** - Continuous health monitoring service
  - Configurable check intervals
  - Alert threshold settings
  - Status change logging
  - Optional auto-restart capability
  - Background service support
  
- 💾 **backup-restore.sh** - Backup and restore tool
  - One-click configuration backup
  - List all available backups
  - Safe restore with confirmation
  - Automatic safety backup before restore
  - Old backup cleanup (keep last 10)
  - Metadata tracking

#### Enhanced Documentation | 文档增强
- 📝 Extended failure patterns (12 scenarios, up from 8)
  - Memory leak detection
  - File descriptor exhaustion
  - Large log files
  - Plugin dependency version conflicts
  
- 📚 New sections in openclaw-doctor.md:
  - Advanced diagnostic features
  - Performance optimization recommendations
  - Failure prevention checklist
  - Best practices guide
  - Automation integration examples
  - Tool quick reference table
  
- 📖 Comprehensive scripts/README.md:
  - Detailed usage for each script
  - Usage scenarios
  - Automation examples (cron, systemd)
  - Troubleshooting guide
  - Best practices

#### Automation Support | 自动化支持
- 🤖 JSON output format for CI/CD integration
- 📋 Exit codes for scripting
- ⏰ Cron job examples
- 🔧 systemd service template
- 🔄 GitHub Actions integration example

### Improved - 改进

#### Enhanced Diagnostics | 诊断增强
- More detailed error messages with actionable recommendations
- Severity levels (info, warning, error) for all checks
- Better config validation (JSON syntax, required fields)
- Feishu config completeness check
- Disk space monitoring
- Node.js and npm version checks

#### Better User Experience | 用户体验
- Color-coded output for better readability
- Progress indicators
- Confirmation prompts for destructive operations
- Detailed help messages (--help flag)
- Version information (--version flag)

#### Performance | 性能
- Faster diagnostic execution
- Optimized log parsing
- Efficient file system operations

### Fixed - 修复
- Improved error handling in all scripts
- Better handling of missing dependencies
- Fixed edge cases in log analysis
- Corrected permission checks

### Documentation - 文档
- Updated README with new features
- Added comprehensive scripts documentation
- Included automation examples
- Added troubleshooting section
- Bilingual documentation (English/Chinese)

## [1.0.0] - 2026-04-26

### Added
- ✨ Initial release of OpenClaw Doctor
- 📝 Core skill file with 8 common failure patterns
- 🔍 Quick diagnostic checklist
- 🌲 Troubleshooting decision tree
- 📚 Detailed diagnostic workflow
- 🛠️ Auto-fix script for common issues
- 📊 Quick diagnostic script
- 📖 Bilingual README (English/Chinese)
- 📄 MIT License
- 🤝 Contributing guidelines

### Failure Patterns Covered
1. Feishu channel auto-restart loop (missing verificationToken/encryptKey)
2. Config file permission errors
3. Message no response (plugin dependency installation delay)
4. npm dependency conflicts
5. WebSocket connection failures
6. Plugin loading failures
7. Gateway startup failures (plugins.allow issues)
8. Telegram getUpdates conflicts (multiple instances)

### Scripts
- `quick-diagnostic.sh` - System health check
- `auto-fix.sh` - Automated issue resolution

### Documentation
- Installation guide
- Usage examples
- FAQ section
- Troubleshooting decision tree
- Command reference

## [0.1.0] - 2026-04-26 (Beta)

### Added
- Initial beta version for internal testing
- Basic diagnostic capabilities
- Core failure patterns identified

---

## Version Comparison | 版本对比

### v1.1.0 vs v1.0.0

**New Scripts:**
- advanced-diagnostic.sh (comprehensive analysis)
- performance-analyzer.sh (resource monitoring)
- health-monitor.sh (continuous monitoring)
- backup-restore.sh (config management)

**Enhanced Features:**
- JSON output support
- Health score calculation
- Continuous monitoring
- Automated backups
- CI/CD integration

**Documentation:**
- 4x more detailed
- Automation examples
- Best practices guide
- Troubleshooting section

**Failure Patterns:**
- 8 → 12 patterns (+50%)

---

## Future Plans | 未来计划

### v1.2.0 (Planned - Q2 2026)
- [ ] Web-based diagnostic dashboard
- [ ] Real-time metrics visualization
- [ ] Email/Slack notification support
- [ ] Telegram channel diagnostics
- [ ] WeChat Work channel support
- [ ] Interactive diagnostic mode
- [ ] Plugin-specific health checks
- [ ] Database integration for historical data

### v1.3.0 (Planned - Q3 2026)
- [ ] Multi-language support (Japanese, Korean, Spanish)
- [ ] Video tutorials
- [ ] Integration with OpenClaw CLI
- [ ] Advanced performance profiling
- [ ] Memory leak detection tools
- [ ] Network latency analysis
- [ ] Custom alert rules

### v2.0.0 (Future - Q4 2026)
- [ ] AI-powered root cause analysis
- [ ] Predictive failure detection
- [ ] Automated recovery mechanisms
- [ ] Cloud-based diagnostic service
- [ ] Multi-instance management
- [ ] Distributed tracing support
- [ ] Advanced analytics dashboard

---

## Migration Guide | 迁移指南

### From v1.0.0 to v1.1.0

**No breaking changes!** All v1.0.0 features are fully compatible.

**New capabilities:**
1. Install new scripts (already included if you clone/pull)
2. Try advanced diagnostic: `./scripts/advanced-diagnostic.sh`
3. Set up monitoring: `./scripts/health-monitor.sh`
4. Create your first backup: `./scripts/backup-restore.sh backup`

**Recommended actions:**
- Set up cron jobs for automated monitoring
- Create initial backup before making changes
- Review new failure patterns in documentation
- Update any automation scripts to use JSON output

---

## Contributing | 贡献

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute to this changelog.

## Links | 链接

- [GitHub Repository](https://github.com/AIPMAndy/openclaw-doctor)
- [Issue Tracker](https://github.com/AIPMAndy/openclaw-doctor/issues)
- [OpenClaw Official](https://openclaw.ai)
- [Release Notes](https://github.com/AIPMAndy/openclaw-doctor/releases)

---

**Note:** This project follows [Semantic Versioning](https://semver.org/).
- MAJOR version for incompatible API changes
- MINOR version for new functionality in a backwards compatible manner
- PATCH version for backwards compatible bug fixes
