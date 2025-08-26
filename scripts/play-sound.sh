#!/bin/bash

# ClaudeBell - Unix/Linux/Mac Sound Player
# Plays notification sounds for Claude Code

SOUND_TYPE="${1:-default}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOUNDS_DIR="$SCRIPT_DIR/../sounds"

# Map sound types to files
case "$SOUND_TYPE" in
    alert)
        SOUND_FILE="$SOUNDS_DIR/alert.wav"
        ;;
    success)
        SOUND_FILE="$SOUNDS_DIR/success.wav"
        ;;
    error)
        SOUND_FILE="$SOUNDS_DIR/error.wav"
        ;;
    gentle)
        SOUND_FILE="$SOUNDS_DIR/gentle-chime.wav"
        ;;
    *)
        SOUND_FILE="$SOUNDS_DIR/default.wav"
        ;;
esac

# Function to play sound on different systems
play_sound() {
    local file="$1"
    
    # Check if file exists
    if [ ! -f "$file" ]; then
        # Try to play system beep as fallback
        printf '\a'
        return
    fi
    
    # Detect OS and use appropriate player
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v afplay &> /dev/null; then
            afplay "$file" &
        elif command -v sox &> /dev/null; then
            play "$file" &> /dev/null &
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v paplay &> /dev/null; then
            paplay "$file" &
        elif command -v aplay &> /dev/null; then
            aplay "$file" &> /dev/null &
        elif command -v sox &> /dev/null; then
            play "$file" &> /dev/null &
        elif command -v mplayer &> /dev/null; then
            mplayer "$file" &> /dev/null &
        fi
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows Git Bash / Cygwin
        powershell.exe -Command "(New-Object System.Media.SoundPlayer '$file').PlaySync()" &
    else
        # Unknown OS - try common commands
        if command -v play &> /dev/null; then
            play "$file" &> /dev/null &
        else
            printf '\a'
        fi
    fi
}

# Play the sound
play_sound "$SOUND_FILE"