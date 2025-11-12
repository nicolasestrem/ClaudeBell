#!/bin/bash

# Test script to verify the fix in install.sh

# Run the install script and capture its output
output=$(./install.sh)

# Check if the output contains the unexpanded variable.
# If it does, the script is broken.
if echo "$output" | grep -q 'command": "${CLAUDE_BELL_DIR}'; then
  echo "Test failed: Found unexpanded variable in output."
  exit 1
fi

# Check if the output contains a command with an absolute path.
# This is the expected behavior for the fix.
if echo "$output" | grep -q 'command": "/'; then
  echo "Test passed: Found absolute path in command."
  exit 0
else
  echo "Test failed: Did not find absolute path in command."
  exit 1
fi