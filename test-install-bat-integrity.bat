@echo off
REM Test script to validate install.bat integrity
REM This script ensures install.bat is not corrupted

echo.
echo ===============================================
echo   Testing install.bat Integrity
echo ===============================================
echo.

REM Check if install.bat exists
if not exist "%~dp0install.bat" (
    echo [FAIL] install.bat not found
    exit /b 1
)
echo [PASS] install.bat exists

REM Check file size (should be around 5KB)
for %%A in ("%~dp0install.bat") do set size=%%~zA
if %size% LSS 3000 (
    echo [FAIL] install.bat is too small - possible corruption
    exit /b 1
)
if %size% GTR 10000 (
    echo [WARN] install.bat is larger than expected
)
echo [PASS] File size is reasonable: %size% bytes

REM Check for required batch commands
findstr /C:"@echo off" "%~dp0install.bat" >nul
if errorlevel 1 (
    echo [FAIL] Missing @echo off command
    exit /b 1
)
echo [PASS] Found @echo off

findstr /C:"CLAUDE_BELL_DIR" "%~dp0install.bat" >nul
if errorlevel 1 (
    echo [FAIL] Missing CLAUDE_BELL_DIR variable
    exit /b 1
)
echo [PASS] Found CLAUDE_BELL_DIR variable

findstr /C:"setlocal" "%~dp0install.bat" >nul
if errorlevel 1 (
    echo [FAIL] Missing setlocal command
    exit /b 1
)
echo [PASS] Found setlocal command

findstr /C:"powershell" "%~dp0install.bat" >nul
if errorlevel 1 (
    echo [FAIL] Missing powershell commands
    exit /b 1
)
echo [PASS] Found powershell commands

REM Check for corruption patterns (process list output)
findstr /R /C:"^[0-9][0-9]* ?" "%~dp0install.bat" | findstr /V /C:"echo" /C:"REM" >nul
if not errorlevel 1 (
    echo [FAIL] Detected process list pattern - file may be corrupted
    exit /b 1
)
echo [PASS] No process list patterns detected

findstr /C:"Image Name" "%~dp0install.bat" | findstr /V /C:"echo" /C:"REM" >nul
if not errorlevel 1 (
    echo [FAIL] Detected tasklist header - file may be corrupted
    exit /b 1
)
echo [PASS] No tasklist headers detected

echo.
echo ===============================================
echo   All Integrity Tests PASSED
echo ===============================================
echo.
echo install.bat appears to be valid and uncorrupted.
echo.
exit /b 0
