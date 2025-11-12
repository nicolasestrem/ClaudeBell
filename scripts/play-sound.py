#!/usr/bin/env python3
"""ClaudeBell - Cross-platform Python Sound Player"""

from __future__ import annotations

import platform
import subprocess
import sys
from pathlib import Path
from shutil import which

SOUND_MAP = {
    "alert": "alert.wav",
    "success": "success.wav",
    "error": "error.wav",
    "gentle": "gentle-chime.wav",
    "default": "default.wav",
}


def resolve_sound_file(sound_type: str, sounds_dir: Path) -> Path | None:
    """Return the best available sound file for the requested type."""
    candidates = []
    if sound_type in SOUND_MAP:
        candidates.append(sounds_dir / SOUND_MAP[sound_type])
    candidates.append(sounds_dir / SOUND_MAP["default"])

    for candidate in candidates:
        if candidate.exists():
            return candidate
    return None


def play_with_subprocess(command: list[str]) -> bool:
    """Try running a command in the background, returning True on success."""
    try:
        subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True
    except (FileNotFoundError, OSError):
        return False


def play_sound_file(file_path: Path) -> None:
    """Play a sound file using platform-specific tools."""
    system = platform.system()
    file_str = str(file_path)

    if system == "Windows":
        try:
            import winsound

            winsound.PlaySound(file_str, winsound.SND_FILENAME | winsound.SND_ASYNC)
            return
        except ImportError:
            pass

    if system == "Darwin":
        if which("afplay") and play_with_subprocess(["afplay", file_str]):
            return
        if which("play") and play_with_subprocess(["play", file_str]):
            return
    elif system == "Linux":
        if which("paplay") and play_with_subprocess(["paplay", file_str]):
            return
        if which("aplay") and play_with_subprocess(["aplay", file_str]):
            return
        if which("play") and play_with_subprocess(["play", file_str]):
            return
        if which("mplayer") and play_with_subprocess(["mplayer", "-really-quiet", file_str]):
            return
    else:
        # Try a generic player if available
        if which("play") and play_with_subprocess(["play", file_str]):
            return

    # pygame fallback
    try:
        import pygame

        pygame.mixer.init()
        pygame.mixer.music.load(file_str)
        pygame.mixer.music.play()
        while pygame.mixer.music.get_busy():
            pygame.time.Clock().tick(10)
        return
    except Exception:
        pass

    # Last resort: ASCII bell
    sys.stdout.write("\a")
    sys.stdout.flush()


def main() -> None:
    sound_type = sys.argv[1] if len(sys.argv) > 1 else "default"
    sound_type = sound_type.lower()

    script_dir = Path(__file__).resolve().parent
    sounds_dir = script_dir.parent / "sounds"

    sound_file = resolve_sound_file(sound_type, sounds_dir)

    if sound_file is None:
        sys.stdout.write("\a")
        sys.stdout.flush()
        return

    play_sound_file(sound_file)


if __name__ == "__main__":
    main()
