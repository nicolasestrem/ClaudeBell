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

1. **Hook System Integration**
   - Integrates with Claude Code's hook system
   - Uses absolute paths for reliable execution from any working directory
   - Supports multiple hook events for different notification scenarios

2. **Sound Playing Scripts**
   - `play-sound.bat` - Windows PowerShell-based player with asynchronous playback
   - `play-sound.sh` - Unix/Mac shell script using afplay/paplay/aplay/sox with robust fallbacks
   - `play-sound.py` - Cross-platform Python fallback with optional pygame support

### Sound Type Mapping
- `alert` - Attention-grabbing notifications (Notification hook, PreToolUse hook)
- `success` - Task completion (Stop hook)
- `gentle` - Subtle notifications (UserPromptSubmit, PostToolUse hooks)
- `error` - Error notifications
- `default` - Generic fallback

## Understanding Claude Code Configuration

### Official Configuration File Locations

Per the official Claude Code documentation, settings are stored in these locations:

**Configuration Priority (Highest to Lowest):**
1. **Enterprise Managed Policies** (`managed-settings.json`) - Cannot be overridden
2. **Command-line Arguments** - Temporary session overrides
3. **`{project}/.claude/settings.local.json`** - Local project overrides (git-ignored, personal)
4. **`{project}/.claude/settings.json`** - Shared project config (version controlled, team-wide)
5. **`~/.claude/settings.json`** (Unix/Mac) or **`%USERPROFILE%\.claude\settings.json`** (Windows) - User global config

**Important Notes:**
- Higher priority settings override lower priority ones
- Multiple config files can have hooks that ALL execute
- For ClaudeBell, we recommend using **user global config** for personal notification preferences
- Use **project local config** (`.claude/settings.local.json`) if notifications should only apply to this project

### Available Hook Events

Claude Code supports these 9 hook events:

**Tool-related:**
- `PreToolUse` - Executes before tool calls (can block them)
- `PostToolUse` - Runs after tool completion

**Session management:**
- `SessionStart` - Triggers at session initialization or resumption
- `SessionEnd` - Runs when sessions terminate
- `PreCompact` - Executes before context compaction

**Agent control:**
- `Stop` - Activates when the agent finishes responding
- `SubagentStop` - Runs when subagent tasks complete
- `UserPromptSubmit` - Triggers when users submit prompts

**System:**
- `Notification` - Fires when Claude Code sends notifications (most reliable for alerts)

### Hook Types

Claude Code supports two hook types:

1. **Command hooks** (`type: "command"`) - Execute shell scripts (used by ClaudeBell)
2. **Prompt hooks** (`type: "prompt"`) - Use LLM evaluation for decisions (available for Stop/SubagentStop)

ClaudeBell uses command hooks to play sounds without LLM involvement.

## Working Hook Configuration

**⚠️ IMPORTANT**: Configure hooks in ONE location to avoid confusion!

### Recommended: User Global Config
**File**: `~/.claude/settings.json` (Unix/Mac) or `%USERPROFILE%\.claude\settings.json` (Windows)

**Minimal Configuration (Recommended)** - Only triggers on permission prompts:
```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/ClaudeBell/scripts/play-sound.sh alert"
          }
        ]
      }
    ]
  }
}
```

**Full Configuration** - Triggers on multiple Claude events:
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/ClaudeBell/scripts/play-sound.sh gentle"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/ClaudeBell/scripts/play-sound.sh success"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/ClaudeBell/scripts/play-sound.sh alert"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/ClaudeBell/scripts/play-sound.sh gentle"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/absolute/path/to/ClaudeBell/scripts/play-sound.sh alert"
          }
        ]
      }
    ]
  }
}
```

**Windows Example:**
```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "C:\\Users\\yourname\\ClaudeBell\\scripts\\play-sound.bat alert"
          }
        ]
      }
    ]
  }
}
```

**Note**: The `Notification` hook is most reliable for permission prompts. Tool-related hooks may be intermittent depending on Claude Code's internal state.

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

## TROUBLESHOOTING

### Problem: Getting Too Many Notifications

**Symptoms**: Sounds play for every Claude action (user input, tool execution, completion, etc.)

**Solution**:
1. **Check config files** for multiple hook definitions:
   ```bash
   # Unix/Mac
   cat ~/.claude/settings.json
   cat .claude/settings.json
   cat .claude/settings.local.json

   # Windows
   notepad %USERPROFILE%\.claude\settings.json
   notepad .\.claude\settings.json
   notepad .\.claude\settings.local.json
   ```

2. **Remove unwanted hooks** - Keep only what you need
3. **Use ONE config file** - Recommend user global: `~/.claude/settings.json`
4. **Restart Claude Code** after changes

### Problem: No Sound At All

**Check**:
1. Sound files exist in `sounds/` directory (or use system sounds)
2. Scripts have execute permissions (`chmod +x scripts/*.sh` on Unix/Mac)
3. At least one config file has hooks configured
4. Test manually: `scripts/play-sound.bat alert` or `./scripts/play-sound.sh alert`
5. Check hook syntax is valid JSON with proper escaping

### Problem: Hooks Not Triggering

**Known Limitations**:
- Claude Code hooks can be intermittent
- `Notification` hook is most reliable for permission prompts
- `PreToolUse` and `PostToolUse` may not trigger consistently
- Tool-related hooks depend on Claude Code's internal state

**Solutions**:
- Restart Claude Code
- Ensure configuration file syntax is correct
- Use `Notification` hook for most reliable results
- Check that absolute paths are used in hook commands

## Configuration File Locations Reference

### Official Locations (Per Claude Code Documentation):

**Unix/Mac:**
- `~/.claude/settings.json` - User global config
- `{project}/.claude/settings.json` - Project shared config (version controlled)
- `{project}/.claude/settings.local.json` - Project local config (git-ignored)

**Windows:**
- `%USERPROFILE%\.claude\settings.json` - User global config
- `{project}\.claude\settings.json` - Project shared config (version controlled)
- `{project}\.claude\settings.local.json` - Project local config (git-ignored)

**Note**: Previous versions of this documentation listed additional locations (e.g., `%APPDATA%\Claude\settings.json`) that are not mentioned in the current official Claude Code documentation. If you have hooks configured in those locations from earlier Claude Code versions, you may need to migrate them to the official locations listed above.

## Development Notes

### When modifying scripts:
- Ensure cross-platform compatibility
- Test fallback to system sounds when WAV files are missing
- Maintain asynchronous playback to avoid blocking Claude Code
- Use absolute paths for reliability

### When updating hooks:
- **Recommended**: Configure in user global config (`~/.claude/settings.json`)
- Test all hook events you plan to use
- Verify commands execute with proper permissions
- **Always restart Claude Code** after hook changes
- Use absolute paths in hook commands
- Ensure proper JSON escaping (especially backslashes in Windows paths)

### Platform-specific considerations:
- **Windows**: Uses PowerShell's System.Media.SoundPlayer with asynchronous `.Play()` method
- **macOS**: Built-in `afplay` command works reliably
- **Linux**: Multiple fallbacks (paplay → aplay → sox → mplayer)
- **Python**: Cross-platform fallback with pygame support

### Security Considerations

**⚠️ IMPORTANT SECURITY WARNING**

Per official Claude Code documentation:
> "Claude Code hooks execute arbitrary shell commands on your system automatically during the agent loop with your current environment's credentials."

**Security Best Practices:**
1. **Review all hook commands** before adding them to configuration
2. **Use absolute paths** to prevent command injection
3. **Limit hook scope** to only the events you need
4. **Be cautious with project configs** that others might modify
5. **Never run untrusted hook scripts** without reviewing them first

The ClaudeBell scripts are simple sound players with no network access, but you should always review any hook scripts before using them.

## Hook Input/Output

Hooks receive JSON via stdin containing:
- `session_id` - Current session identifier
- `transcript_path` - Path to conversation transcript
- `cwd` - Current working directory
- Event-specific fields

Hooks use exit codes:
- `0` - Success, continue
- `2` - Block the action (for PreToolUse hooks)
- Other non-zero - Error

ClaudeBell scripts ignore stdin and always exit with code 0 (success).

## Additional Hook Events (Not Used by ClaudeBell)

While ClaudeBell primarily uses `Notification`, `PreToolUse`, `PostToolUse`, `Stop`, and `UserPromptSubmit`, Claude Code also supports:

- `SubagentStop` - When subagent tasks complete
- `PreCompact` - Before context compaction operations
- `SessionStart` - At session initialization (useful for environment setup)
- `SessionEnd` - At session termination (useful for cleanup)

These could be used for more advanced notification scenarios.

## Known Issues and Limitations

### Hook Intermittency
- Claude Code hooks can be intermittent, especially tool-related hooks
- `Notification` hook is most reliable for permission prompts
- Hook execution depends on Claude Code's internal state
- **Workaround**: Use `Notification` hook as primary notification method

### Configuration Complexity
- Multiple configuration files can cause unexpected behavior
- Hooks in ALL matching config files will execute
- **Solution**: Use single configuration file location for clarity

### Cross-Platform Path Differences
- Windows requires escaped backslashes in JSON: `"C:\\Users\\..."`
- Unix/Mac uses forward slashes: `"/home/user/..."`
- Always use absolute paths for reliability

## Best Practices Summary

1. ✅ **Use user global config** (`~/.claude/settings.json`) for personal notifications
2. ✅ **Use Notification hook** as primary notification method (most reliable)
3. ✅ **Use absolute paths** in hook commands
4. ✅ **Test hooks manually** before relying on them
5. ✅ **Restart Claude Code** after configuration changes
6. ✅ **Review security implications** of all hook scripts
7. ❌ **Avoid multiple config locations** - pick one and stick to it
8. ❌ **Don't rely on tool hooks exclusively** - they can be intermittent

## Resources

- [Official Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide.md)
- [Official Claude Code Hooks Reference](https://code.claude.com/docs/en/hooks.md)
- [Official Claude Code Settings Documentation](https://code.claude.com/docs/en/settings.md)
