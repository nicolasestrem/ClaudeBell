#!/bin/bash
# Validation script to verify install.bat integrity
# This script checks that install.bat contains proper batch commands
# and not corrupted content like process lists

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_BAT="${SCRIPT_DIR}/install.bat"

echo "======================================"
echo "  install.bat Integrity Validator"
echo "======================================"
echo ""

# Check if file exists
if [ ! -f "$INSTALL_BAT" ]; then
    echo "[ERROR] install.bat not found at: $INSTALL_BAT"
    exit 1
fi
echo "[OK] File exists: $INSTALL_BAT"

# Check file type
FILE_TYPE=$(file "$INSTALL_BAT")
if [[ "$FILE_TYPE" == *"DOS batch file"* ]] || [[ "$FILE_TYPE" == *"ASCII text"* ]]; then
    echo "[OK] File type is correct: DOS batch file"
else
    echo "[ERROR] File type is incorrect: $FILE_TYPE"
    exit 1
fi

# Check for essential batch commands
REQUIRED_PATTERNS=(
    "@echo off"
    "setlocal"
    "CLAUDE_BELL_DIR"
    "CLAUDE_SETTINGS_DIR"
    "powershell"
    "echo.*ClaudeBell"
)

echo ""
echo "Checking for required batch commands..."
for pattern in "${REQUIRED_PATTERNS[@]}"; do
    if grep -qi "$pattern" "$INSTALL_BAT"; then
        echo "[OK] Found: $pattern"
    else
        echo "[ERROR] Missing required pattern: $pattern"
        exit 1
    fi
done

# Check for signs of corruption (process list output)
CORRUPTION_PATTERNS=(
    "^[0-9]+ \?"              # Process list format: "1234 ?"
    "^Image Name"             # tasklist header
    "^====="                  # tasklist separator (but not our echo separators)
    "^PID:"                   # Process ID format
    "Session Name:"           # tasklist column
)

echo ""
echo "Checking for signs of corruption..."
CORRUPTION_FOUND=0
for pattern in "${CORRUPTION_PATTERNS[@]}"; do
    # Skip our intentional separator lines in echo commands
    if grep -E "$pattern" "$INSTALL_BAT" | grep -v "^echo" | grep -v "^REM" > /dev/null 2>&1; then
        echo "[WARNING] Suspicious pattern found: $pattern"
        CORRUPTION_FOUND=1
    fi
done

if [ $CORRUPTION_FOUND -eq 0 ]; then
    echo "[OK] No corruption patterns detected"
else
    echo "[ERROR] Potential corruption detected in install.bat"
    exit 1
fi

# Check line count (should be around 160-170 lines)
LINE_COUNT=$(wc -l < "$INSTALL_BAT")
if [ "$LINE_COUNT" -lt 100 ] || [ "$LINE_COUNT" -gt 200 ]; then
    echo ""
    echo "[WARNING] Unexpected line count: $LINE_COUNT (expected 100-200)"
    echo "          This might indicate corruption or significant changes"
else
    echo ""
    echo "[OK] Line count is reasonable: $LINE_COUNT lines"
fi

# Check for proper batch file structure
echo ""
echo "Checking batch file structure..."
if grep -q "^@echo off" "$INSTALL_BAT"; then
    echo "[OK] Proper batch file header found"
else
    echo "[ERROR] Missing '@echo off' header"
    exit 1
fi

if grep -q ":end" "$INSTALL_BAT" || grep -q "goto :eof" "$INSTALL_BAT"; then
    echo "[OK] Proper batch file termination found"
else
    echo "[ERROR] Missing proper termination labels"
    exit 1
fi

# Verify it's not a binary file
if file "$INSTALL_BAT" | grep -q "binary"; then
    echo ""
    echo "[ERROR] File appears to be binary, not text"
    exit 1
fi
echo "[OK] File is text-based"

echo ""
echo "======================================"
echo "  Validation PASSED"
echo "======================================"
echo ""
echo "install.bat appears to be valid and uncorrupted."
echo ""

exit 0
