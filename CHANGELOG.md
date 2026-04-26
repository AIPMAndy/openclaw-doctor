# Changelog | 更新日志

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

## Version History

- **v1.0.0** (2026-04-26) - Initial public release
- **v0.1.0** (2026-04-26) - Internal beta

## Future Plans

### v1.1.0 (Planned)
- [ ] Add Telegram channel diagnostics
- [ ] Add WeChat Work channel support
- [ ] Interactive diagnostic mode
- [ ] Web-based diagnostic dashboard
- [ ] Automated health monitoring

### v1.2.0 (Planned)
- [ ] Multi-language support (Japanese, Korean)
- [ ] Video tutorials
- [ ] Integration with OpenClaw CLI
- [ ] Performance optimization tips

### v2.0.0 (Future)
- [ ] AI-powered root cause analysis
- [ ] Predictive failure detection
- [ ] Automated recovery mechanisms
- [ ] Cloud-based diagnostic service

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute to this changelog.

## Links

- [GitHub Repository](https://github.com/AIPMAndy/openclaw-doctor)
- [Issue Tracker](https://github.com/AIPMAndy/openclaw-doctor/issues)
- [OpenClaw Official](https://openclaw.ai)
