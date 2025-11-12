@echo off
setlocal EnableDelayedExpansion

echo.
echo ========================================
echo     ClaudeBell Uninstall Script
echo ========================================
echo.

set "CLAUDEBELL_DIR=%~dp0"
set "CLAUDEBELL_DIR=%CLAUDEBELL_DIR:~0,-1%"

echo [!] WARNING: This will completely remove ClaudeBell from your system.
echo.
echo This will:
echo   - Remove all ClaudeBell hooks from Claude Code configurations
echo   - Delete the ClaudeBell directory and all its contents
echo   - Remove any backup configuration files
echo.
echo ClaudeBell directory: %CLAUDEBELL_DIR%
echo.
set /p "CONFIRM=Are you sure you want to uninstall ClaudeBell? (yes/no): "

if /i not "%CONFIRM%" == "yes" (
    echo.
    echo [i] Uninstall cancelled.
    pause
    exit /b 0
)

echo.
echo ========================================
echo    Step 1: Removing Hooks
echo ========================================
echo.

set "CONFIG_FILE=%USERPROFILE%\.claude\settings.json"
set "LOCAL_CONFIG=%USERPROFILE%\.claude\settings.local.json"

echo Removing ClaudeBell hooks from configuration files...

if exist "%CONFIG_FILE%" (
    echo.
    echo Cleaning: %CONFIG_FILE%
    powershell -Command "try { $json = Get-Content '%CONFIG_FILE%' -Raw | ConvertFrom-Json; if ($json.hooks) { $json.PSObject.Properties.Remove('hooks'); $json | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_FILE%' -Encoding UTF8; Write-Host '  [✓] Removed hooks section' -ForegroundColor Green } else { Write-Host '  [i] No hooks section found' -ForegroundColor Yellow } } catch { Write-Host '  [!] Error processing file: $_' -ForegroundColor Red }"
)

if exist "%LOCAL_CONFIG%" (
    echo.
    echo Cleaning: %LOCAL_CONFIG%
    powershell -Command "try { $json = Get-Content '%LOCAL_CONFIG%' -Raw | ConvertFrom-Json; if ($json.hooks) { $json.PSObject.Properties.Remove('hooks'); $json | ConvertTo-Json -Depth 10 | Set-Content '%LOCAL_CONFIG%' -Encoding UTF8; Write-Host '  [✓] Removed hooks section' -ForegroundColor Green } else { Write-Host '  [i] No hooks section found' -ForegroundColor Yellow } } catch { Write-Host '  [!] Error processing file: $_' -ForegroundColor Red }"
)

for %%F in ("%APPDATA%\Claude\settings.json" "%APPDATA%\Claude\claude-settings.json") do (
    if exist "%%~F" (
        echo.
        echo Cleaning: %%~F
        powershell -Command "try { $json = Get-Content '%%~F' -Raw | ConvertFrom-Json; if ($json.hooks) { $json.PSObject.Properties.Remove('hooks'); $json | ConvertTo-Json -Depth 10 | Set-Content '%%~F' -Encoding UTF8; Write-Host '  [✓] Removed hooks section' -ForegroundColor Green } else { Write-Host '  [i] No hooks section found' -ForegroundColor Yellow } } catch { Write-Host '  [!] Error processing file: $_' -ForegroundColor Red }"
    )
)

echo.
echo ========================================
echo    Step 2: Removing Backup Files
echo ========================================
echo.

set "BACKUPS_FOUND=0"
for %%F in ("%CONFIG_FILE%.backup" "%LOCAL_CONFIG%.backup" "%APPDATA%\Claude\settings.json.backup" "%APPDATA%\Claude\claude-settings.json.backup") do (
    if exist "%%~F" (
        del /q "%%~F" 2>nul
        if !errorlevel! == 0 (
            echo [✓] Removed backup: %%~F
            set /a "BACKUPS_FOUND+=1"
        )
    )
)

if !BACKUPS_FOUND! == 0 (
    echo [i] No backup files found.
)

echo.
echo ========================================
echo    Step 3: Removing ClaudeBell
echo ========================================
echo.

echo [!] About to delete: %CLAUDEBELL_DIR%
echo.
set /p "FINAL_CONFIRM=Type DELETE to confirm removal of ClaudeBell directory: "

if /i not "%FINAL_CONFIRM%" == "DELETE" (
    echo.
    echo [i] Directory removal cancelled.
    echo     Hooks have been removed but ClaudeBell files remain.
    pause
    exit /b 0
)

echo.
echo Removing ClaudeBell directory...

cd /d "%USERPROFILE%"

timeout /t 2 /nobreak >nul

if exist "%CLAUDEBELL_DIR%" (
    rmdir /s /q "%CLAUDEBELL_DIR%" 2>nul
    if exist "%CLAUDEBELL_DIR%" (
        echo [!] Could not remove directory completely.
        echo     Some files may be in use. Please close any programs using
        echo     ClaudeBell files and manually delete: %CLAUDEBELL_DIR%
    ) else (
        echo [✓] ClaudeBell directory removed successfully.
    )
) else (
    echo [!] Directory not found or already removed.
)

echo.
echo ========================================
echo    Uninstall Complete
echo ========================================
echo.
echo ClaudeBell has been uninstalled from your system.
echo.
echo Thank you for using ClaudeBell!
echo.
echo If you want to reinstall ClaudeBell in the future:
echo   1. Clone the repository: git clone https://github.com/yourusername/ClaudeBell.git
echo   2. Run the installer: install.bat
echo.
pause