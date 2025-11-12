#!/bin/bash

echo ""
echo "========================================"
echo "     ClaudeBell Uninstall Script"
echo "========================================"
echo ""

CLAUDEBELL_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[!] WARNING: This will completely remove ClaudeBell from your system."
echo ""
echo "This will:"
echo "  - Remove all ClaudeBell hooks from Claude Code configurations"
echo "  - Delete the ClaudeBell directory and all its contents"
echo "  - Remove any backup configuration files"
echo ""
echo "ClaudeBell directory: $CLAUDEBELL_DIR"
echo ""
read -p "Are you sure you want to uninstall ClaudeBell? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo ""
    echo "[i] Uninstall cancelled."
    exit 0
fi

echo ""
echo "========================================"
echo "    Step 1: Removing Hooks"
echo "========================================"
echo ""

CONFIG_FILE="$HOME/.claude/settings.json"
LOCAL_CONFIG="$HOME/.claude/settings.local.json"
XDG_CONFIG="$HOME/.config/claude/settings.json"

echo "Removing ClaudeBell hooks from configuration files..."

remove_hooks() {
    local file="$1"
    if [ -f "$file" ]; then
        echo ""
        echo "Cleaning: $file"
        if command -v python3 &> /dev/null; then
            python3 -c "
import json
import sys
try:
    with open('$file', 'r') as f:
        data = json.load(f)
    if 'hooks' in data:
        del data['hooks']
        with open('$file', 'w') as f:
            json.dump(data, f, indent=2)
        print('  [✓] Removed hooks section')
    else:
        print('  [i] No hooks section found')
except Exception as e:
    print(f'  [!] Error processing file: {e}')
"
        elif command -v jq &> /dev/null; then
            if jq '.hooks' "$file" &>/dev/null; then
                jq 'del(.hooks)' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
                echo "  [✓] Removed hooks section"
            else
                echo "  [i] No hooks section found"
            fi
        else
            echo "{}" > "$file"
            echo "  [✓] Reset configuration file"
        fi
    fi
}

remove_hooks "$CONFIG_FILE"
remove_hooks "$LOCAL_CONFIG"
remove_hooks "$XDG_CONFIG"

echo ""
echo "========================================"
echo "    Step 2: Removing Backup Files"
echo "========================================"
echo ""

BACKUPS_FOUND=0
for file in "$CONFIG_FILE.backup" "$LOCAL_CONFIG.backup" "$XDG_CONFIG.backup"; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "[✓] Removed backup: $file"
        ((BACKUPS_FOUND++))
    fi
done

if [ $BACKUPS_FOUND -eq 0 ]; then
    echo "[i] No backup files found."
fi

echo ""
echo "========================================"
echo "    Step 3: Removing ClaudeBell"
echo "========================================"
echo ""

echo "[!] About to delete: $CLAUDEBELL_DIR"
echo ""
read -p "Type DELETE to confirm removal of ClaudeBell directory: " FINAL_CONFIRM

if [ "$FINAL_CONFIRM" != "DELETE" ]; then
    echo ""
    echo "[i] Directory removal cancelled."
    echo "    Hooks have been removed but ClaudeBell files remain."
    exit 0
fi

echo ""
echo "Removing ClaudeBell directory..."

cd "$HOME" || exit 1

sleep 2

if [ -d "$CLAUDEBELL_DIR" ]; then
    rm -rf "$CLAUDEBELL_DIR"
    if [ -d "$CLAUDEBELL_DIR" ]; then
        echo "[!] Could not remove directory completely."
        echo "    Some files may be in use. Please close any programs using"
        echo "    ClaudeBell files and manually delete: $CLAUDEBELL_DIR"
    else
        echo "[✓] ClaudeBell directory removed successfully."
    fi
else
    echo "[!] Directory not found or already removed."
fi

echo ""
echo "========================================"
echo "    Uninstall Complete"
echo "========================================"
echo ""
echo "ClaudeBell has been uninstalled from your system."
echo ""
echo "Thank you for using ClaudeBell!"
echo ""
echo "If you want to reinstall ClaudeBell in the future:"
echo "  1. Clone the repository: git clone https://github.com/yourusername/ClaudeBell.git"
echo "  2. Run the installer: ./install.sh"
echo ""