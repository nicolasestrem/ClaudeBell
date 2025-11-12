# Bug Report: `install.sh` Fails to Expand Path Variable

## Bug Description

*   **File**: `install.sh`
*   **Location**: The `cat << 'EOF'` block (approximately lines 90-113).
*   **Issue**: The installation script for Unix-based systems (`install.sh`) provides manual instructions for configuring Claude Code. The provided JSON snippet uses a shell environment variable (`${CLAUDE_BELL_DIR}`) to define the path to the notification script. However, the use of a single-quoted heredoc (`cat << 'EOF'`) prevents this variable from being expanded. As a result, the literal string `"${CLAUDE_BELL_DIR}/..."` is printed, which is an invalid path.
*   **Impact**: This bug makes the application non-functional for all macOS and Linux users, as the sound notification hooks will fail to execute.

## Proposed Fix

The fix involves changing the heredoc specifier in `install.sh` from `cat << 'EOF'` to `cat << EOF`. This allows the `$CLAUDE_BELL_DIR` environment variable to be correctly expanded to its absolute path when the instructions are generated, providing the user with a valid and ready-to-use configuration.

## Verification

A new test script, `test_install_script.sh`, has been added to the repository. This script executes `install.sh`, captures its output, and verifies that the generated command contains a valid, absolute path, thus confirming that the bug is resolved.