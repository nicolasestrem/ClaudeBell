@echo off
echo Testing permission trigger...
echo This script will attempt to access a protected resource
echo.

REM Try to access system directory (will trigger permission prompt)
echo Attempting to list Windows System32 directory...
dir C:\Windows\System32 > nul 2>&1

REM Try to modify registry (will trigger permission prompt)
echo Checking registry access...
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" > nul 2>&1

echo.
echo Permission test completed.