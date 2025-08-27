#!/bin/bash

echo ""
echo "========================================"
echo "    ClaudeBell Deactivation Script"
echo "========================================"
echo ""

CONFIG_FILE="$HOME/.claude/settings.json"
LOCAL_CONFIG="$HOME/.claude/settings.local.json"
XDG_CONFIG="$HOME/.config/claude/settings.json"

echo "Checking for ClaudeBell hook configurations..."
echo ""

CONFIGS_FOUND=0

check_config() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "[✓] Found configuration: $file"
        if grep -q "ClaudeBell" "$file" 2>/dev/null; then
            echo "    - Contains ClaudeBell hooks"
            ((CONFIGS_FOUND++))
        else
            echo "    - No ClaudeBell hooks found"
        fi
    fi
}

check_config "$CONFIG_FILE"
check_config "$LOCAL_CONFIG"
check_config "$XDG_CONFIG"
check_config "./.claude/settings.json"
check_config "./config/claude-settings.json"

if [ $CONFIGS_FOUND -eq 0 ]; then
    echo ""
    echo "[i] No ClaudeBell hooks found in any configuration files."
    echo "    Nothing to deactivate."
    echo ""
    exit 0
fi

echo ""
echo "========================================"
echo "    Deactivation Options"
echo "========================================"
echo ""
echo "What would you like to do?"
echo ""
echo "1. Remove ALL hooks (complete deactivation)"
echo "2. Keep hooks but comment them out (easy reactivation)"
echo "3. Cancel"
echo ""
read -p "Enter your choice (1-3): " CHOICE

case $CHOICE in
    3)
        echo ""
        echo "[i] Deactivation cancelled."
        exit 0
        ;;
    
    1)
        echo ""
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
    sys.exit(1)
"
                elif command -v jq &> /dev/null; then
                    jq 'del(.hooks)' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
                    echo "  [✓] Removed hooks section"
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
        echo "[✓] ClaudeBell has been deactivated."
        echo "    Hooks have been removed from configuration files."
        ;;
    
    2)
        echo ""
        echo "Creating backup configuration files..."
        
        backup_config() {
            local file="$1"
            if [ -f "$file" ]; then
                cp "$file" "$file.backup"
                echo "[✓] Backed up: $file"
                echo "{}" > "$file"
                echo "[✓] Created empty configuration: $file"
            fi
        }
        
        backup_config "$CONFIG_FILE"
        backup_config "$LOCAL_CONFIG"
        backup_config "$XDG_CONFIG"
        
        echo ""
        echo "[✓] ClaudeBell has been deactivated."
        echo "    Original configurations backed up with .backup extension"
        echo ""
        echo "To reactivate, restore from:"
        [ -f "$CONFIG_FILE.backup" ] && echo "  - $CONFIG_FILE.backup"
        [ -f "$LOCAL_CONFIG.backup" ] && echo "  - $LOCAL_CONFIG.backup"
        [ -f "$XDG_CONFIG.backup" ] && echo "  - $XDG_CONFIG.backup"
        ;;
    
    *)
        echo ""
        echo "[!] Invalid choice. Deactivation cancelled."
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo "    Deactivation Complete"
echo "========================================"
echo ""
echo "ClaudeBell hooks have been disabled."
echo "You may need to restart Claude Code for changes to take effect."
echo ""
echo "To reactivate ClaudeBell, run: ./install.sh"
echo ""