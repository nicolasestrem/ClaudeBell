# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ClaudeBell is a cross-platform notification sound system for Claude Code that plays audio alerts when Claude needs user attention or completes tasks. It uses shell scripts and Python fallbacks to trigger system sounds based on Claude Code hook events.

**⚠️ WARNING: This project exposed a major Claude Code configuration management issue where multiple configuration files can conflict with each other, causing excessive notifications.**

## Key Architecture

### Directory Structure
- `scripts/` - Platform-specific sound playing scripts (`.bat`, `.sh`, `.py`)
- `sounds/` - WAV audio files for notifications (users add their own)
- `config/` - Claude Code settings configuration with hook definitions

### Core Components

1. **Hook System Integration** (Multiple Configuration Locations!)
   - Integrates with Claude Code's hook events: UserPromptSubmit, Stop, PreToolUse, PostToolUse, Notification
   - Uses absolute paths for reliable execution from any working directory
   - **CRITICAL**: Claude Code checks MULTIPLE config files in priority order!

2. **Sound Playing Scripts**
   - `play-sound.bat` - Windows PowerShell-based player
   - `play-sound.sh` - Unix/Mac shell script using afplay/paplay/aplay/sox
   - `play-sound.py` - Cross-platform Python fallback with optional pygame support

### Sound Type Mapping
- `alert` - Tool execution starts (PreToolUse hook) and permission requests (Notification hook)
- `success` - Response completion (Stop hook)
- `gentle` - User input (UserPromptSubmit) and tool completion (PostToolUse hooks)
- `default` - Standard notification

## THE CONFIGURATION NIGHTMARE 😱

**Problem**: Claude Code checks MULTIPLE configuration files, and they can override/conflict with each other!

### Configuration File Priority (Windows):
1. **`C:\Users\{user}\.claude\settings.json`** ← **MAIN GLOBAL CONFIG** (highest priority)
2. **`C:\Users\{user}\.claude\settings.local.json`** ← Local user overrides  
3. **`C:\Users\{user}\AppData\Roaming\Claude\settings.json`** ← Application data config
4. **`C:\Users\{user}\AppData\Roaming\Claude\claude-settings.json`** ← Legacy config
5. **`{project}\.claude\settings.json`** ← Project-specific config
6. **`{project}\config\claude-settings.json`** ← Old project config

**LESSON LEARNED**: If you're getting unexpected hook behavior, you MUST check ALL of these files!

### The Horror Story We Just Experienced:

1. **Initial Problem**: Getting sounds for EVERY Claude action instead of just permission requests
2. **Investigation**: Found multiple config files with different hook configurations
3. **The Hunt**: Had to check 6+ different configuration locations
4. **Root Cause**: `C:\Users\nicol\.claude\settings.json` had ALL hooks enabled (Stop, PreToolUse, PostToolUse, UserPromptSubmit)
5. **Solution**: Cleaned all configs to only use Notification hook

## Working Hook Configuration

**⚠️ IMPORTANT**: Only configure hooks in ONE location to avoid conflicts!

### Recommended: Main Global Config
**File**: `C:\Users\{user}\.claude\settings.json`

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

## TROUBLESHOOTING THE CONFIG NIGHTMARE 🔧

### Problem: Getting Too Many Notifications

**Symptoms**: Sounds play for every Claude action (user input, tool execution, completion, etc.)

**Solution**:
1. **Check ALL config files** in this order:
   ```bash
   # Check main global config (most likely culprit)
   notepad "%USERPROFILE%\.claude\settings.json"
   
   # Check other potential locations
   notepad "%USERPROFILE%\.claude\settings.local.json"
   notepad "%APPDATA%\Claude\settings.json" 
   notepad "%APPDATA%\Claude\claude-settings.json"
   notepad ".\.claude\settings.json"
   notepad ".\config\claude-settings.json"
   ```

2. **Remove conflicting hooks** from all files
3. **Configure hooks in ONLY ONE location** (recommend main global: `~/.claude/settings.json`)
4. **Use only Notification hook** for minimal notifications

### Problem: No Sound At All

**Check**:
1. Sound files exist in `sounds/` directory
2. Scripts have execute permissions
3. At least one config file has the Notification hook configured
4. Test manually: `scripts\play-sound.bat alert`

### Problem: Configuration File Conflicts

**Symptoms**: Hooks seem to work intermittently or behave unexpectedly

**Solution**:
1. **Audit all config files** - search for any with "hooks" sections
2. **Choose ONE location** for your configuration  
3. **Clear hooks from all other files**: `{}`
4. **Restart Claude Code** after changes

## Configuration File Locations Reference

### Windows:
- `%USERPROFILE%\.claude\settings.json` ← **PRIMARY GLOBAL**
- `%USERPROFILE%\.claude\settings.local.json` ← Local overrides
- `%APPDATA%\Claude\settings.json` ← App data config  
- `%APPDATA%\Claude\claude-settings.json` ← Legacy config
- `{project}\.claude\settings.json` ← Project-specific
- `{project}\config\claude-settings.json` ← Old project format

### Unix/Mac:
- `~/.claude/settings.json` ← **PRIMARY GLOBAL**
- `~/.claude/settings.local.json` ← Local overrides
- `~/.config/claude/settings.json` ← XDG config
- `{project}/.claude/settings.json` ← Project-specific
- `{project}/config/claude-settings.json` ← Old project format

## Development Notes

### When modifying scripts:
- Ensure cross-platform compatibility
- Test fallback to system sounds when WAV files are missing
- Maintain environment variable usage for paths (`CLAUDE_BELL_DIR`, `CLAUDE_BELL_EXT`)

### When updating hooks:
- **CRITICAL**: Only configure in ONE location
- Check for conflicts across all potential config files
- Test all hook events (Notification, Stop, Error, PostToolUse)
- Verify environment variable substitution works correctly
- Check that commands execute with proper permissions
- **Always restart Claude Code** after hook changes

### Platform-specific considerations:
- **Windows**: Uses PowerShell's System.Media.SoundPlayer, fixed timeout syntax issues
- **macOS**: Requires built-in `afplay` command
- **Linux**: Tries `paplay`, `aplay`, then `sox` in order
- **Python**: Uses wave/ossaudiodev or pygame if available

## LESSONS LEARNED FROM THE CONFIG NIGHTMARE

1. **Claude Code's multi-file configuration system is confusing** - it checks 6+ different locations
2. **Configuration conflicts are nearly impossible to debug** without checking every file
3. **The installer should warn about existing configurations** before creating new ones
4. **Documentation should emphasize the config file priority system**
5. **A configuration audit tool would be invaluable** for debugging conflicts
6. **Hook behavior is inconsistent** - some work reliably, others are intermittent

**Recommendation to Claude Code team**: Please consider:
- A single, well-documented configuration location
- Better error messages when configs conflict  
- A `claude config audit` command to show all active configurations
- Clear documentation about file priority and merging behavior