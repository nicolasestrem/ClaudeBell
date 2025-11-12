#!/bin/bash

# ClaudeBell - Unix/Linux/Mac Sound Player
# Plays notification sounds for Claude Code

set -euo pipefail

SOUND_TYPE="${1:-default}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOUNDS_DIR="$SCRIPT_DIR/../sounds"

# Map sound types to expected files
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

# Choose the first existing sound file, falling back to default and then to none
choose_sound_file() {
    local primary="$1"
    local fallback="$SOUNDS_DIR/default.wav"

    if [[ -f "$primary" ]]; then
        echo "$primary"
    elif [[ -f "$fallback" ]]; then
        echo "$fallback"
    else
        echo ""
    fi
}

PLAYABLE_FILE="$(choose_sound_file "$SOUND_FILE")"

play_system_beep() {
    # ASCII bell, works in most terminals
    printf '\a' >&2 || true
}

play_with_command() {
    local file="$1"

    # Detect OS and use appropriate player
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v afplay &> /dev/null; then
            afplay "$file" &
            return 0
        elif command -v sox &> /dev/null; then
            play "$file" &> /dev/null &
            return 0
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v paplay &> /dev/null; then
            paplay "$file" &
            return 0
        elif command -v aplay &> /dev/null; then
            aplay "$file" &> /dev/null &
            return 0
        elif command -v sox &> /dev/null; then
            play "$file" &> /dev/null &
            return 0
        elif command -v mplayer &> /dev/null; then
            mplayer -really-quiet "$file" &> /dev/null &
            return 0
        fi
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        if command -v powershell.exe &> /dev/null; then
            powershell.exe -Command "(New-Object System.Media.SoundPlayer '$file').Play()" &> /dev/null &
            return 0
        fi
    else
        if command -v play &> /dev/null; then
            play "$file" &> /dev/null &
            return 0
        fi
    fi

    return 1
}

if [[ -n "$PLAYABLE_FILE" ]]; then
    if ! play_with_command "$PLAYABLE_FILE"; then
        # Try Python fallback if available
        if command -v python3 &> /dev/null; then
            python3 "$SCRIPT_DIR/play-sound.py" "$SOUND_TYPE" &> /dev/null &
        else
            play_system_beep
        fi
    fi
else
    play_system_beep
fi
