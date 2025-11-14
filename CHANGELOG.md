# Changelog

All notable changes to ClaudeBell will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2025-01

### Changed - Documentation Accuracy Update

**Critical documentation corrections to align with official Claude Code specifications:**

#### Configuration System Corrections
- ✅ **Fixed configuration file locations** - Removed incorrect references to `%APPDATA%\Claude\settings.json` and `config/claude-settings.json` that are not mentioned in official Claude Code documentation
- ✅ **Corrected configuration priority order** - Updated from incorrect 6-level system to official 5-level hierarchy:
  1. Enterprise Managed Policies (highest)
  2. Command-line Arguments
  3. Local Project Settings (`.claude/settings.local.json`)
  4. Shared Project Settings (`.claude/settings.json`)
  5. User Global Settings (`~/.claude/settings.json`) (lowest)
- ✅ **Clarified configuration behavior** - Emphasized that hooks in ALL matching config files execute, not just highest priority

#### Hook Events Corrections
- ✅ **Updated hook events list** - Corrected from 6 events to official 9 events:
  - **Added**: SubagentStop, PreCompact, SessionStart, SessionEnd
  - **Noted**: "Error" hook is NOT documented in official Claude Code docs
- ✅ **Removed Error hook** from `.claude/settings.local.json` - replaced with Notification hook per official documentation

#### Hook System Enhancements
- ✅ **Added hook types documentation** - Explained command hooks vs. prompt hooks
- ✅ **Added hook input/output specifications** - Documented stdin JSON format and exit codes
- ✅ **Added security warnings** - Per official Claude Code guidelines about arbitrary command execution
- ✅ **Enhanced troubleshooting guidance** - Based on official configuration system

#### Documentation Improvements
- 📖 Rewrote "Configuration Nightmare" section with accurate information
- 📖 Added references to official Claude Code documentation
- 📖 Clarified most reliable hooks (Notification) vs. intermittent hooks (tool-related)
- 📖 Improved security best practices section
- 📖 Added note about legacy configuration locations from earlier Claude Code versions

**Impact**: These corrections ensure ClaudeBell users have accurate information about Claude Code's configuration system and hook events, preventing confusion and misconfiguration.

### Added
- Comprehensive CHANGELOG.md to track project evolution
- Links to official Claude Code documentation (Hooks Guide, Hooks Reference, Settings Documentation)

## [Recent] - 2025-01

### Changed - Cross-Platform Sound Handling Improvements (PR #3)

**Breaking Change**: Sound file naming has been standardized across all platforms.

#### Sound File Naming Migration
- `bip.wav` → `alert.wav` (attention-grabbing notification)
- `notify.wav` → `success.wav` (task completion)
- Added `error.wav` (error/failure tone)
- Added `gentle-chime.wav` (subtle prompt for softer events)
- Added `default.wav` (generic fallback)

#### Enhanced Scripts
- **Windows (play-sound.bat)**
  - Changed from `.PlaySync()` to `.Play()` for asynchronous playback (non-blocking)
  - Improved PowerShell timeout handling
  - Better error messaging
  - Standardized sound file references

- **Unix/Mac (play-sound.sh)**
  - Added `set -euo pipefail` for better error handling
  - Enhanced fallback mechanism: afplay → paplay → aplay → sox
  - Improved platform detection
  - More robust error messages
  - Standardized sound file references

- **Python (play-sound.py)**
  - Added type hints for better code clarity
  - Enhanced subprocess handling with proper timeout and error checking
  - Multiple audio player fallbacks: paplay, aplay, sox, mplayer
  - Optional pygame support for advanced audio needs
  - Better platform-specific path handling
  - Improved error reporting

#### Testing Updates
- Updated `test-installation.bat` to check for new sound file names
- Enhanced validation for cross-platform compatibility

### Migration Guide
If you're upgrading from an earlier version with custom sound files:
```bash
# Rename your existing files:
mv sounds/bip.wav sounds/alert.wav
mv sounds/notify.wav sounds/success.wav

# Or create symlinks for backward compatibility:
ln -s alert.wav bip.wav
ln -s success.wav notify.wav
```

## [2024-11] - Installation Reliability Fix (PR #1)

### Fixed
- **Install Script Path Variable Expansion** (ef90794)
  - Fixed shell variable expansion bug in `install.sh`
  - Previously, `$HOME` was being written literally instead of expanded
  - Now correctly expands to actual user home directory path

### Added
- `test_install_script.sh` - Verification script for installation testing
- `BUG_REPORT.md` - Documentation of the path expansion issue and fix

### Impact
This fix ensures that Claude Code hooks are properly configured with absolute paths, preventing "command not found" errors when hooks execute.

## [2024-08] - Configuration Management Discovery

### Added
- **THE CONFIGURATION NIGHTMARE Documentation**
  - Comprehensive documentation of Claude Code's multi-file configuration system
  - Identified 6+ configuration file locations that can conflict
  - Added troubleshooting workflows for configuration conflicts
  - Created detailed file priority documentation

### Changed
- Updated CLAUDE.md with extensive configuration management guidance
- Added warning about excessive notifications caused by config conflicts
- Documented best practices for single-location configuration

### Documented Issues
Configuration files checked by Claude Code (in priority order):
1. `~/.claude/settings.json` (PRIMARY - highest priority)
2. `~/.claude/settings.local.json` (Local overrides)
3. `~/.config/claude/settings.json` / `%APPDATA%\Claude\settings.json`
4. `~/.config/claude/claude-settings.json` (Legacy)
5. `{project}/.claude/settings.json` (Project-specific)
6. `{project}/config/claude-settings.json` (Old format)

### Lessons Learned
- Multiple configuration files can cause duplicate hook execution
- Users were experiencing sounds for EVERY Claude action instead of just permission requests
- Recommended approach: Configure hooks in ONLY ONE location
- Restart Claude Code required after configuration changes

## [2024-08] - Windows System Sound Implementation

### Added
- **Native Windows PowerShell System Sounds** (5a80d99)
  - No longer requires WAV files for Windows users
  - Uses PowerShell's `System.Media.SystemSounds` class
  - Five built-in sounds: Asterisk, Exclamation, Hand, Question, Beep
  - Zero dependencies, works out of the box

### Changed
- Major README overhaul to document Windows system sounds
- Simplified Windows installation process
- Added manual PowerShell setup instructions

### Benefits
- Immediate functionality on fresh Windows installations
- Respects user's Windows sound scheme preferences
- Reduced repository size (no required WAV files)
- More reliable playback on Windows systems

## [2024-08] - Management Features

### Added
- **Deactivation Scripts** (72f6654)
  - `deactivate.bat` / `deactivate.sh` - Temporary hook disabling
  - Backup and restore functionality
  - Selective hook management options

- **Uninstallation Scripts**
  - `uninstall.bat` / `uninstall.sh` - Complete removal
  - Cleans all configuration files across all possible locations
  - Optional directory removal
  - Backup file cleanup

### Testing Scripts
- `test-installation.bat` - Windows installation verification
- `test-sound.ps1` - PowerShell sound testing
- `validate-hooks.ps1` - Hook configuration validation
- `test-permission.bat` - Permission prompt testing
- `test_install_script.sh` - Unix/Linux installation testing

## Key Features

### Cross-Platform Support
- Windows: PowerShell system sounds + optional WAV files
- macOS: Native `afplay` command + optional WAV files
- Linux: Multiple audio backends (paplay, aplay, sox, mplayer) + optional WAV files
- Python fallback for maximum compatibility

### Hook Integration
ClaudeBell integrates with Claude Code's hook system:
- `Notification` - Permission requests and important alerts (most reliable)
- `PreToolUse` - Before tool execution
- `PostToolUse` - After tool completion
- `Stop` - Response finished
- `UserPromptSubmit` - User input sent
- `Error` - Error notifications

### Reliability Features
- Absolute path usage throughout for consistent execution
- Asynchronous playback (non-blocking)
- Multiple fallback mechanisms
- Comprehensive error handling
- Environment variable support (`CLAUDE_BELL_DIR`, `CLAUDE_BELL_EXT`)

## Known Issues

### Hook Intermittency
- Claude Code hooks can be intermittent, especially tool-related hooks
- `Notification` hook is most reliable for permission prompts
- `PreToolUse` and `PostToolUse` may not trigger consistently
- Workaround: Restart Claude Code, ensure clean configuration

### Configuration Complexity
- Multiple configuration files can cause unexpected behavior
- Users may experience duplicate notifications
- Solution: Use single configuration file location
- See CLAUDE.md for comprehensive troubleshooting

## Contributing

We welcome contributions! Areas of focus:
- Cross-platform compatibility improvements
- Configuration management simplification
- Hook reliability enhancements
- Documentation improvements
- Sound file contributions

## Acknowledgments

Special thanks to the Claude Code team at Anthropic for their excellent CLI tool, and to all users who helped identify and document the configuration management challenges.

---

**Note**: This project emerged from frustration with configuration complexity but evolved into comprehensive documentation that benefits the entire Claude Code community.
