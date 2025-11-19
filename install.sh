#!/bin/bash

set -euo pipefail

echo ""
echo "==============================================="
echo "      ClaudeBell Installer for Unix/Linux     "
echo "==============================================="
echo ""

# Get the directory where this script is located
CLAUDE_BELL_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing ClaudeBell from: $CLAUDE_BELL_DIR"
echo ""

# Make scripts executable
echo "Setting script permissions..."
chmod +x "$CLAUDE_BELL_DIR/scripts/play-sound.sh"
chmod +x "$CLAUDE_BELL_DIR/scripts/play-sound.py"
echo "[OK] Scripts are now executable"
echo ""

# Test sound playback
echo "Testing sound playback..."
if "$CLAUDE_BELL_DIR/scripts/play-sound.sh" default; then
    echo ""
else
    echo ""
    echo "[ERROR] Sound playback test failed. Please check your audio setup and try again."
    echo "Installation aborted."
    exit 1
fi

# Detect shell and update appropriate config file
SHELL_CONFIG=""
ZSH_VERSION="${ZSH_VERSION:-}"
BASH_VERSION="${BASH_VERSION:-}"
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "Adding environment variables to $SHELL_CONFIG..."
    
    # Check if already configured
    if grep -q "CLAUDE_BELL_DIR" "$SHELL_CONFIG" 2>/dev/null; then
        echo "[INFO] ClaudeBell already configured in $SHELL_CONFIG"
    else
        echo "" >> "$SHELL_CONFIG"
        echo "# ClaudeBell Configuration" >> "$SHELL_CONFIG"
        echo "export CLAUDE_BELL_DIR=\"$CLAUDE_BELL_DIR\"" >> "$SHELL_CONFIG"
        echo "export CLAUDE_BELL_EXT=\"sh\"" >> "$SHELL_CONFIG"
        echo "[OK] Environment variables added to $SHELL_CONFIG"
        echo ""
        echo "Please run: source $SHELL_CONFIG"
        echo "Or restart your terminal for changes to take effect"
    fi
else
    echo "[WARNING] Could not detect shell configuration file"
    echo ""
    echo "Please add these lines to your shell config (.bashrc, .zshrc, etc):"
    echo "export CLAUDE_BELL_DIR=\"$CLAUDE_BELL_DIR\""
    echo "export CLAUDE_BELL_EXT=\"sh\""
fi
echo ""

# Check for audio playback tools
echo "Checking audio playback tools..."
OSTYPE="${OSTYPE:-}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v afplay &> /dev/null; then
        echo "[OK] afplay is available (macOS)"
    else
        echo "[WARNING] afplay not found - sound playback may not work"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    FOUND_PLAYER=false
    for player in paplay aplay play mplayer; do
        if command -v $player &> /dev/null; then
            echo "[OK] $player is available"
            FOUND_PLAYER=true
            break
        fi
    done
    if [ "$FOUND_PLAYER" = false ]; then
        echo "[WARNING] No audio player found. Install one of: pulseaudio-utils, alsa-utils, sox, mplayer"
    fi
fi
echo ""

# Instructions for Claude Code configuration
cat << EOF
===============================================
      Next Steps - Configure Claude Code
===============================================

1. Run: claude config edit

2. Add the following hooks configuration. This script has detected the
   full path to the sound scripts for you.

{
  "hooks": {
    "Notification": [{
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_BELL_DIR/scripts/play-sound.sh alert"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_BELL_DIR/scripts/play-sound.sh success"
      }]
    }],
    "Error": [{
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_BELL_DIR/scripts/play-sound.sh error"
      }]
    }]
  }
}

3. Save and close the configuration file

4. Test by asking Claude Code something that requires permission

===============================================
         Installation Complete!
===============================================

EOF

echo "[INFO] ClaudeBell installation finished successfully."