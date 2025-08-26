#!/usr/bin/env python3
"""
ClaudeBell - Cross-platform Python Sound Player
Plays notification sounds for Claude Code
"""

import sys
import os
import platform
from pathlib import Path

def play_sound_file(file_path):
    """Play a sound file using available methods"""
    system = platform.system()
    
    try:
        if system == "Windows":
            import winsound
            winsound.PlaySound(file_path, winsound.SND_FILENAME)
        elif system == "Darwin":  # macOS
            os.system(f'afplay "{file_path}" &')
        elif system == "Linux":
            # Try different Linux audio players
            if os.system(f'which paplay > /dev/null 2>&1') == 0:
                os.system(f'paplay "{file_path}" &')
            elif os.system(f'which aplay > /dev/null 2>&1') == 0:
                os.system(f'aplay "{file_path}" > /dev/null 2>&1 &')
            else:
                print('\a', end='', flush=True)  # System beep fallback
        else:
            print('\a', end='', flush=True)  # System beep fallback
    except Exception:
        # If all else fails, try pygame if available
        try:
            import pygame
            pygame.mixer.init()
            pygame.mixer.music.load(file_path)
            pygame.mixer.music.play()
            while pygame.mixer.music.get_busy():
                pygame.time.Clock().tick(10)
        except ImportError:
            # Last resort: system beep
            print('\a', end='', flush=True)

def main():
    # Get sound type from command line argument
    sound_type = sys.argv[1] if len(sys.argv) > 1 else "default"
    
    # Get script directory and sounds directory
    script_dir = Path(__file__).parent
    sounds_dir = script_dir.parent / "sounds"
    
    # Map sound types to files
    sound_map = {
        "alert": "alert.wav",
        "success": "success.wav",
        "error": "error.wav",
        "gentle": "gentle-chime.wav",
        "default": "default.wav"
    }
    
    sound_filename = sound_map.get(sound_type, "default.wav")
    sound_file = sounds_dir / sound_filename
    
    # Play sound if file exists, otherwise system beep
    if sound_file.exists():
        play_sound_file(str(sound_file))
    else:
        print('\a', end='', flush=True)  # System beep

if __name__ == "__main__":
    main()