# 🔔 ClaudeBell

> Never miss a Claude moment! A cross-platform notification sound system for Claude Code.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-brightgreen.svg)
![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-purple.svg)

## 🎯 What is ClaudeBell?

ClaudeBell adds audio notifications to Claude Code, playing sounds when:
- 🚨 Claude needs your permission or input
- ✅ Tasks complete successfully
- ❌ Errors occur
- 🎵 Custom events you define

Perfect for multitaskers who want to know when Claude needs attention without constantly watching the terminal!

## 🚀 Quick Install

### Windows
```bash
git clone https://github.com/yourusername/ClaudeBell.git
cd ClaudeBell
install.bat
```

### macOS/Linux
```bash
git clone https://github.com/yourusername/ClaudeBell.git
cd ClaudeBell
chmod +x install.sh
./install.sh
```

## 📦 Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/ClaudeBell.git
   ```

2. **Set environment variables:**
   
   **Windows (PowerShell):**
   ```powershell
   $env:CLAUDE_BELL_DIR = "C:\path\to\ClaudeBell"
   $env:CLAUDE_BELL_EXT = "bat"
   ```
   
   **Unix/Linux/Mac:**
   ```bash
   export CLAUDE_BELL_DIR="/path/to/ClaudeBell"
   export CLAUDE_BELL_EXT="sh"
   ```

3. **Configure Claude Code:**
   
   Add the hooks from `config/claude-settings.json` to your Claude Code settings:
   
   ```bash
   claude config edit
   ```
   
   Then merge the hooks configuration from this project.

## 🎨 Customization

### Adding Custom Sounds

1. Add your WAV files to the `sounds/` directory
2. Name them according to the sound types:
   - `default.wav` - Default notification
   - `alert.wav` - Urgent attention needed
   - `success.wav` - Task completed
   - `error.wav` - Error occurred  
   - `gentle-chime.wav` - Soft notification

### Configuring Hooks

Edit your Claude Code settings to customize when sounds play:

```json
{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "/path/to/ClaudeBell/scripts/play-sound.sh alert"
      }]
    }]
  }
}
```

## 🔧 Troubleshooting

### No Sound Playing?

1. **Check script permissions:**
   ```bash
   chmod +x scripts/play-sound.sh  # Unix/Mac
   ```

2. **Test manually:**
   ```bash
   # Windows
   scripts\play-sound.bat alert
   
   # Unix/Mac
   ./scripts/play-sound.sh alert
   ```

3. **Verify audio system:**
   - **macOS:** Requires `afplay` (built-in)
   - **Linux:** Requires `paplay`, `aplay`, or `sox`
   - **Windows:** Uses PowerShell (built-in)

### Python Fallback

If shell scripts don't work, use the Python version:

```bash
python scripts/play-sound.py alert
```

Optional: Install pygame for better audio support:
```bash
pip install pygame
```

## 🛠️ Supported Platforms

- ✅ Windows 10/11 (PowerShell)
- ✅ macOS (10.15+)
- ✅ Ubuntu/Debian Linux
- ✅ Fedora/RHEL Linux
- ✅ WSL2
- ✅ Git Bash on Windows

## 📝 Configuration Options

### Sound Types

- `default` - Standard notification
- `alert` - Urgent, requires immediate attention
- `success` - Task completed successfully
- `error` - Error or failure occurred
- `gentle` - Soft, non-intrusive notification

### Hook Events

- `Notification` - Claude needs permission
- `Stop` - Claude finished responding
- `PostToolUse` - After tool execution
- `Error` - When errors occur

## 🤝 Contributing

We love contributions! Feel free to:

1. 🐛 Report bugs
2. 💡 Suggest new features
3. 🔊 Share your custom sound packs
4. 📖 Improve documentation

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🌟 Show Your Support

If ClaudeBell helps you stay productive, give it a ⭐ on GitHub!

## 🔗 Links

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Report Issues](https://github.com/yourusername/ClaudeBell/issues)
- [Discussions](https://github.com/yourusername/ClaudeBell/discussions)

---

Made with 🎵 by the Claude Code community