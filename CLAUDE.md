# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ClaudeBell is a cross-platform notification sound system for Claude Code that plays audio alerts when Claude needs user attention or completes tasks. It uses shell scripts and Python fallbacks to trigger system sounds based on Claude Code hook events.

## Key Architecture

### Directory Structure
- `scripts/` - Platform-specific sound playing scripts (`.bat`, `.sh`, `.py`)
- `sounds/` - WAV audio files for notifications (users add their own)
- `config/` - Claude Code settings configuration with hook definitions

### Core Components

1. **Hook System Integration** (`%APPDATA%\Claude\settings.json`)
   - Integrates with Claude Code's hook events: UserPromptSubmit, Stop, PreToolUse, PostToolUse, Notification
   - Uses absolute paths for reliable execution from any working directory

2. **Sound Playing Scripts**
   - `play-sound.bat` - Windows PowerShell-based player
   - `play-sound.sh` - Unix/Mac shell script using afplay/paplay/aplay/sox
   - `play-sound.py` - Cross-platform Python fallback with optional pygame support

### Sound Type Mapping
- `alert` - Tool execution starts (PreToolUse hook) and permission requests (Notification hook)
- `success` - Response completion (Stop hook)
- `gentle` - User input (UserPromptSubmit) and tool completion (PostToolUse hooks)
- `default` - Standard notification

### Working Hook Configuration

The functional hook configuration format (in `%APPDATA%\Claude\settings.json`):

**Minimal Configuration (Recommended)** - Only triggers on permission prompts:
```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\nicol\\ClaudeBell\\scripts\\play-sound.bat alert"
          }
        ]
      }
    ]
  }
}
```

**Full Configuration** - Triggers on all Claude actions (may be excessive):
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\nicol\\ClaudeBell\\scripts\\play-sound.bat gentle"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\nicol\\ClaudeBell\\scripts\\play-sound.bat success"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\nicol\\ClaudeBell\\scripts\\play-sound.bat alert"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\nicol\\ClaudeBell\\scripts\\play-sound.bat gentle"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\nicol\\ClaudeBell\\scripts\\play-sound.bat alert"
          }
        ]
      }
    ]
  }
}
```

**Note**: Hooks work reliably for permission prompts and errors. Tool-related hooks may be intermittent.

## Testing Commands

### Manual Sound Testing
```bash
# Windows
scripts\play-sound.bat alert

# Unix/Mac
./scripts/play-sound.sh alert

# Python fallback
python scripts/play-sound.py alert
```

### Installation Testing
```bash
# Windows
install.bat

# Unix/Mac
./install.sh
```

## Development Notes

### When modifying scripts:
- Ensure cross-platform compatibility
- Test fallback to system sounds when WAV files are missing
- Maintain environment variable usage for paths (`CLAUDE_BELL_DIR`, `CLAUDE_BELL_EXT`)

### When updating hooks:
- Test all hook events (Notification, Stop, Error, PostToolUse)
- Verify environment variable substitution works correctly
- Check that commands execute with proper permissions

### Platform-specific considerations:
- **Windows**: Uses PowerShell's System.Media.SoundPlayer
- **macOS**: Requires built-in `afplay` command
- **Linux**: Tries `paplay`, `aplay`, then `sox` in order
- **Python**: Uses wave/ossaudiodev or pygame if available