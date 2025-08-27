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

### Windows 11/10 (Recommended)
```bash
git clone https://github.com/nicolasestrem/ClaudeBell.git
cd ClaudeBell
install-win11.bat
```

### Windows (Legacy)
```bash
git clone https://github.com/nicolasestrem/ClaudeBell.git
cd ClaudeBell
install.bat
```

The installer will:
- ✅ Test your sound system
- ✅ Automatically configure Claude Code hooks
- ✅ Create the proper settings.json file
- ✅ Guide you through setup

**Important:** For reliable hook triggering on Windows, run Claude Code as Administrator:
```bash
# Right-click Command Prompt → "Run as administrator"
claude
```

### macOS/Linux
```bash
git clone https://github.com/nicolasestrem/ClaudeBell.git
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
   
   Create `%APPDATA%\Claude\settings.json` (Windows) or `~/.config/claude/settings.json` (Unix) with:
   
   ```json
   {
     "hooks": {
       "UserPromptSubmit": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/path/to/ClaudeBell/scripts/play-sound.bat gentle"
             }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/path/to/ClaudeBell/scripts/play-sound.bat success"
             }
           ]
         }
       ],
       "PreToolUse": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/path/to/ClaudeBell/scripts/play-sound.bat alert"
             }
           ]
         }
       ],
       "PostToolUse": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/path/to/ClaudeBell/scripts/play-sound.bat gentle"
             }
           ]
         }
       ],
       "Notification": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "/path/to/ClaudeBell/scripts/play-sound.bat alert"
             }
           ]
         }
       ]
     }
   }
   ```

## 🎨 Customization

### Adding Custom Sounds

1. Add your WAV files to the `sounds/` directory
2. Primary sound file: `bip.wav` (automatically detected)
3. Fallback: `notify.wav` 
4. If no custom sounds exist, uses Windows system sounds

**Supported formats:** WAV files work best with Windows PowerShell SoundPlayer

### Working Hook Events

ClaudeBell uses these reliable hook events:

- `UserPromptSubmit` - When you send a message to Claude
- `Stop` - When Claude finishes responding  
- `PreToolUse` - Before Claude uses any tool
- `PostToolUse` - After Claude finishes using a tool
- `Notification` - When Claude needs user permission or attention

**Note:** Hooks work most reliably for permission prompts (`Notification`). Tool hooks may be intermittent.

## 🔧 Troubleshooting

### No Sound Playing?

1. **Check script permissions:**
   ```bash
   chmod +x scripts/play-sound.sh  # Unix/Mac
   ```

2. **Test manually:**
   ```bash
   # Windows 11/10 (Recommended)
   scripts\play-sound-secure.bat alert
   
   # Windows (Legacy)
   scripts\play-sound.bat alert
   
   # Unix/Mac
   ./scripts/play-sound.sh alert
   ```

3. **Check Windows 11 compatibility:**
   ```bash
   windows11-compatibility.bat
   ```

4. **Verify audio system:**
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

- `Notification` - Claude needs permission or attention
- `Stop` - Claude finished responding
- `UserPromptSubmit` - When user sends a message
- `PreToolUse` - Before tool execution
- `PostToolUse` - After tool execution

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