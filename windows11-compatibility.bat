@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo   ClaudeBell Windows 11 Compatibility Check
echo ===============================================
echo.

REM Check Windows version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
echo Windows version: %VERSION%

REM Check if this is Windows 10 or 11 (build 10.0.22000 or higher is Win11)
for /f "tokens=3" %%a in ('ver') do set BUILD=%%a
set BUILD=%BUILD:[=%
set BUILD=%BUILD:]]=%
echo Build: %BUILD%

if "%BUILD%" GEQ "10.0.22000" (
    echo [INFO] Windows 11 detected
) else (
    echo [INFO] Windows 10 detected
)
echo.

REM Test PowerShell availability and execution policy
echo Testing PowerShell compatibility...
powershell.exe -NoProfile -Command "Write-Host '[OK] PowerShell available'" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell not available or blocked
    goto :compatibility_issues
) else (
    echo [OK] PowerShell accessible
)

REM Test PowerShell execution with bypass policy
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Write-Host '[OK] Execution policy bypass works'" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARN] ExecutionPolicy Bypass may be restricted
) else (
    echo [OK] ExecutionPolicy Bypass functional
)

REM Test System.Media.SoundPlayer availability
echo Testing audio system compatibility...
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "try { $player = New-Object System.Media.SoundPlayer; Write-Host '[OK] SoundPlayer available'; $player.Dispose() } catch { Write-Host '[ERROR] SoundPlayer not available'; exit 1 }" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] System.Media.SoundPlayer not available
    goto :compatibility_issues
) else (
    echo [OK] System.Media.SoundPlayer functional
)

REM Test system sounds fallback
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "try { [System.Media.SystemSounds]::Asterisk.Play(); Write-Host '[OK] System sounds available' } catch { Write-Host '[ERROR] System sounds not available'; exit 1 }" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARN] System sounds may not be available
) else (
    echo [OK] System sounds functional
)

REM Check Claude settings directory permissions
echo Testing file system permissions...
set "CLAUDE_DIR=%APPDATA%\Claude"
if not exist "%CLAUDE_DIR%" (
    mkdir "%CLAUDE_DIR%" 2>nul
    if exist "%CLAUDE_DIR%" (
        echo [OK] Can create Claude directory
        rmdir "%CLAUDE_DIR%" 2>nul
    ) else (
        echo [ERROR] Cannot create Claude directory - permission issue
        goto :compatibility_issues
    )
) else (
    echo [OK] Claude directory exists
    echo test > "%CLAUDE_DIR%\write_test.tmp" 2>nul
    if exist "%CLAUDE_DIR%\write_test.tmp" (
        echo [OK] Can write to Claude directory
        del "%CLAUDE_DIR%\write_test.tmp" 2>nul
    ) else (
        echo [ERROR] Cannot write to Claude directory - permission issue
        goto :compatibility_issues
    )
)

REM Test temp directory access for secure script method
echo Testing temporary file system access...
set "TEST_TEMP=%TEMP%\claudebell_test_%RANDOM%.tmp"
echo test > "%TEST_TEMP%" 2>nul
if exist "%TEST_TEMP%" (
    echo [OK] Can write to temp directory
    del "%TEST_TEMP%" 2>nul
) else (
    echo [WARN] Limited temp directory access
)

echo.
echo ===============================================
echo   Compatibility Check Complete
echo ===============================================
echo.
echo [OK] ClaudeBell should work on this Windows 11 system
echo.
echo Recommendations:
echo 1. Use install-win11.bat for best compatibility
echo 2. Ensure audio device is connected and working
echo 3. Check Windows volume settings
echo 4. Run Claude Code as regular user (not administrator)
echo.
goto :end

:compatibility_issues
echo.
echo ===============================================
echo   Compatibility Issues Detected
echo ===============================================
echo.
echo Potential solutions:
echo 1. Run as administrator if permission issues persist
echo 2. Check Windows security settings (Windows Defender, etc.)
echo 3. Verify PowerShell is not blocked by group policy
echo 4. Ensure audio drivers are installed and working
echo.

:end
pause