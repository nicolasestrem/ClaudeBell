# 🔔 ClaudeBell

> Never miss a Claude moment! A notification sound system for Claude Code.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-brightgreen.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-purple.svg)

## 🎯 What is ClaudeBell?

ClaudeBell provides audio notifications for Claude Code using native system sounds. It alerts you when:
- 🚨 Claude needs your permission or input
- ✅ Claude completes responses 
- 🔧 Tools are being executed
- ⚡ Any Claude Code hook event occurs

Perfect for multitaskers who want audio cues when Claude needs attention!

## ✨ What's New

### Recent Improvements

**Cross-Platform Sound Handling** (PR #3)
- 🎵 Standardized sound file naming across all platforms
- 🔄 Enhanced fallback mechanisms for maximum compatibility
- ⚡ Asynchronous playback - no more blocking Claude Code operations
- 🐍 Improved Python script with type hints and multiple audio player support
- 🛡️ Better error handling with `set -euo pipefail` in shell scripts

**Installation Reliability** (PR #1)
- ✅ Fixed shell variable expansion bug in install.sh
- 🧪 Added comprehensive test suite for installation verification
- 📋 Documented the fix in BUG_REPORT.md

**Sound File Migration**: If upgrading from an older version, rename your custom sound files:
- `bip.wav` → `alert.wav`
- `notify.wav` → `success.wav`

See [CHANGELOG.md](CHANGELOG.md) for complete version history.

## ⚠️ Important Notice: Configuration Complexity

Claude Code checks **multiple configuration files** that can conflict with each other. This project exposed a major issue where hooks can be defined in 6+ different locations, causing unexpected behavior. See the [Configuration Management](#configuration-management) section for details.

## 🚀 Quick Install

### Windows (PowerShell System Sounds)
```bash
git clone https://github.com/nicolasestrem/ClaudeBell.git
cd ClaudeBell
install.bat
```

The installer will:
- ✅ Test Windows system sounds
- ✅ Configure Claude Code hooks in `%USERPROFILE%\.claude\settings.json`
- ✅ Set up three notification types (Exclamation, Asterisk, Hand)
- ⚠️ Warn about existing configuration conflicts

**After installation, restart Claude Code for hooks to take effect!**

### Alternative: Manual PowerShell Setup (Recommended)

For a simpler setup, add this to `%USERPROFILE%\.claude\settings.json`:

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"[System.Media.SystemSounds]::Exclamation.Play()\""
      }]
    }],
    "PreToolUse": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"[System.Media.SystemSounds]::Asterisk.Play()\""
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "powershell.exe -c \"[System.Media.SystemSounds]::Hand.Play()\""
      }]
    }]
  }
}
```

### macOS/Linux
```bash
git clone https://github.com/nicolasestrem/ClaudeBell.git
cd ClaudeBell
chmod +x install.sh
./install.sh
```

## 📦 What's Included

```
ClaudeBell/
├── scripts/              # Platform-specific sound scripts
│   ├── play-sound.bat    # Windows PowerShell player (asynchronous)
│   ├── play-sound.sh     # Unix/Mac script (multi-player fallback)
│   └── play-sound.py     # Python fallback (type hints, pygame support)
├── sounds/               # Custom WAV files (optional)
│   └── README.md         # Sound file guide with free resources
├── install.bat           # Windows installer with validation
├── install.sh            # Unix/Mac installer (fixed path expansion)
├── uninstall.bat         # Windows uninstaller
├── uninstall.sh          # Unix/Mac uninstaller
├── deactivate.bat        # Temporarily disable hooks (Windows)
├── deactivate.sh         # Temporarily disable hooks (Unix/Mac)
├── test-installation.bat # Installation verification (Windows)
├── test_install_script.sh# Installation verification (Unix/Mac)
├── test-sound.ps1        # PowerShell sound testing
├── validate-hooks.ps1    # Hook configuration validator
├── CLAUDE.md             # Detailed troubleshooting & architecture guide
├── CHANGELOG.md          # Version history and improvements
└── BUG_REPORT.md         # Documented issues and fixes
```

### Enhanced Features

**Windows Script (play-sound.bat)**
- Asynchronous playback using `.Play()` instead of `.PlaySync()`
- Non-blocking operation - Claude Code continues working while sound plays
- Improved PowerShell timeout handling

**Unix/Mac Script (play-sound.sh)**
- Robust error handling with `set -euo pipefail`
- Multiple audio player fallbacks: afplay → paplay → aplay → sox
- Better platform detection and error messages

**Python Script (play-sound.py)**
- Full type hints for code clarity
- Multiple player support: paplay, aplay, sox, mplayer
- Optional pygame support for advanced audio features
- Enhanced subprocess handling with timeout control
- Cross-platform path resolution

## 🎨 Sound Options

### Windows System Sounds (No Files Needed!)

Using PowerShell's built-in SystemSounds class:
- `[System.Media.SystemSounds]::Asterisk` - Info/start sound
- `[System.Media.SystemSounds]::Exclamation` - Alert/warning sound
- `[System.Media.SystemSounds]::Hand` - Stop/error sound
- `[System.Media.SystemSounds]::Question` - Query sound
- `[System.Media.SystemSounds]::Beep` - Simple beep

### Custom WAV Files (Optional)

Place WAV files in the `sounds/` directory:
- `default.wav` - Generic fallback used when no specific file exists
- `alert.wav` - Attention-grabbing notification
- `success.wav` - Task completed confirmation
- `error.wav` - Error or failure tone
- `gentle-chime.wav` - Subtle prompt for softer events

### 🔄 Migration Guide for Existing Users

**If you're upgrading from an older version** with custom sound files, the naming convention has changed:

**Old Names** → **New Names**
- `bip.wav` → `alert.wav`
- `notify.wav` → `success.wav`

**Quick Migration Options:**

**Option 1: Rename your files**
```bash
# Windows (Command Prompt)
cd sounds
ren bip.wav alert.wav
ren notify.wav success.wav

# Unix/Mac
cd sounds
mv bip.wav alert.wav
mv notify.wav success.wav
```

**Option 2: Create symlinks (backward compatibility)**
```bash
# Unix/Mac only
cd sounds
ln -s alert.wav bip.wav
ln -s success.wav notify.wav
```

**Why the change?**
- More descriptive names that match their purpose
- Consistency across all platforms
- Support for additional sound types (error, gentle-chime)
- Better integration with the enhanced scripts

## 🔧 Configuration Management

### ⚠️ The Configuration File Nightmare

Claude Code checks these files **in priority order** (Windows paths shown):

1. **`%USERPROFILE%\.claude\settings.json`** ← **PRIMARY** (highest priority)
2. **`%USERPROFILE%\.claude\settings.local.json`** ← Local overrides
3. **`%APPDATA%\Claude\settings.json`** ← Application config
4. **`%APPDATA%\Claude\claude-settings.json`** ← Legacy config
5. **`{project}\.claude\settings.json`** ← Project-specific
6. **`{project}\config\claude-settings.json`** ← Old format

**Problem**: Hooks in ANY of these files will execute, potentially causing multiple notifications!

### Troubleshooting Excessive Notifications

If you're getting too many sounds:

1. **Check ALL config files:**
   ```bash
   # Windows
   notepad %USERPROFILE%\.claude\settings.json
   notepad %USERPROFILE%\.claude\settings.local.json
   notepad %APPDATA%\Claude\settings.json
   
   # Unix/Mac
   cat ~/.claude/settings.json
   cat ~/.claude/settings.local.json
   ```

2. **Remove unwanted hooks** - Keep only what you need
3. **Use ONE config file** - We recommend `%USERPROFILE%\.claude\settings.json`
4. **Restart Claude Code** after changes

## 🛠️ Management Scripts

### Deactivate (Temporary)
```bash
# Windows
deactivate.bat

# Unix/Mac  
./deactivate.sh
```

Options:
- Remove all hooks completely
- Backup hooks for easy reactivation
- Selective hook management

### Uninstall (Complete Removal)
```bash
# Windows
uninstall.bat

# Unix/Mac
./uninstall.sh
```

This will:
- Remove all ClaudeBell hooks from all configs
- Delete backup files
- Optionally remove the ClaudeBell directory

## 🧪 Testing & Validation

ClaudeBell includes a comprehensive test suite to verify installation and functionality:

### Test Scripts

**Windows:**
- `test-installation.bat` - Verifies all scripts are present and hook configuration is correct
- `test-sound.ps1` - Tests PowerShell system sound playback
- `validate-hooks.ps1` - Validates Claude Code hook configuration syntax
- `test-permission.bat` - Tests permission prompt detection

**Unix/Mac:**
- `test_install_script.sh` - Verifies install.sh path expansion and configuration
- `scripts/play-sound.sh --test` - Tests sound player functionality

### Running Tests

```bash
# Windows - Full installation test
test-installation.bat

# Windows - Sound playback test
powershell -File test-sound.ps1

# Unix/Mac - Installation verification
./test_install_script.sh

# Manual sound test (all platforms)
# Windows
scripts\play-sound.bat alert

# Unix/Mac
./scripts/play-sound.sh alert

# Python
python scripts/play-sound.py alert
```

## 🐛 Troubleshooting

### No Sound?

1. **Test system sounds manually:**
   ```powershell
   # Windows PowerShell
   [System.Media.SystemSounds]::Exclamation.Play()
   
   # macOS
   afplay /System/Library/Sounds/Ping.aiff
   
   # Linux
   paplay /usr/share/sounds/freedesktop/stereo/message.oga
   ```

2. **Check Windows sound settings:**
   - Open Sound settings → Sound Control Panel
   - Verify "Windows Default" sound scheme is selected
   - Test sounds in "Program Events" list

3. **Verify hook configuration:**
   - Hooks must be properly formatted JSON
   - Commands must use escaped quotes: `\"`
   - Restart Claude Code after changes

### Hooks Not Triggering?

- **Known issue**: Claude Code hooks can be intermittent
- **Most reliable**: `Notification` hook for permission prompts
- **Less reliable**: Tool-related hooks (PreToolUse, PostToolUse)
- **Solution**: Restart Claude Code, ensure clean config

## 📝 Available Hook Events

- **`Notification`** - Permission requests, important alerts
- **`PreToolUse`** - Before tool execution
- **`PostToolUse`** - After tool completion  
- **`Stop`** - Response finished
- **`UserPromptSubmit`** - User input sent
- **`Error`** - Errors occurred

## 🤝 Contributing

We discovered and documented major Claude Code configuration issues! Help us improve:

1. 🐛 Report configuration conflicts
2. 💡 Suggest simpler notification methods
3. 📖 Improve documentation
4. 🔊 Share cross-platform solutions

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Report Issues](https://github.com/nicolasestrem/ClaudeBell/issues)
- [Version History (CHANGELOG.md)](CHANGELOG.md)
- [Configuration Nightmare Story](CLAUDE.md#the-configuration-nightmare-)
- [Bug Reports & Fixes](BUG_REPORT.md)

---

Made with 🎵 and frustration by someone who just wanted notification sounds to work properly