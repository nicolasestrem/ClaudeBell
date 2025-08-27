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
├── scripts/           # Platform-specific sound scripts
│   ├── play-sound.bat # Windows PowerShell player
│   ├── play-sound.sh  # Unix/Mac shell script
│   └── play-sound.py  # Python fallback
├── sounds/            # Custom WAV files (optional)
├── install.bat        # Windows installer
├── uninstall.bat      # Windows uninstaller
├── deactivate.bat     # Temporarily disable hooks
└── CLAUDE.md          # Detailed troubleshooting guide
```

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
- `bip.wav` - Primary sound
- `notify.wav` - Fallback sound
- Any other `.wav` files for custom events

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
- [Configuration Nightmare Story](CLAUDE.md#the-configuration-nightmare-)

---

Made with 🎵 and frustration by someone who just wanted notification sounds to work properly