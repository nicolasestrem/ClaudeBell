@echo off
setlocal EnableDelayedExpansion

echo.
echo ========================================
echo    ClaudeBell Deactivation Script
echo ========================================
echo.

set "CONFIG_FILE=%USERPROFILE%\.claude\settings.json"
set "LOCAL_CONFIG=%USERPROFILE%\.claude\settings.local.json"
set "TEMP_FILE=%TEMP%\claude_settings_temp.json"

echo Checking for ClaudeBell hook configurations...
echo.

set "CONFIGS_FOUND=0"

if exist "%CONFIG_FILE%" (
    echo [✓] Found configuration: %CONFIG_FILE%
    findstr /C:"ClaudeBell" "%CONFIG_FILE%" >nul 2>&1
    if !errorlevel! == 0 (
        echo    - Contains ClaudeBell hooks
        set /a "CONFIGS_FOUND+=1"
    ) else (
        echo    - No ClaudeBell hooks found
    )
)

if exist "%LOCAL_CONFIG%" (
    echo [✓] Found configuration: %LOCAL_CONFIG%
    findstr /C:"ClaudeBell" "%LOCAL_CONFIG%" >nul 2>&1
    if !errorlevel! == 0 (
        echo    - Contains ClaudeBell hooks
        set /a "CONFIGS_FOUND+=1"
    ) else (
        echo    - No ClaudeBell hooks found
    )
)

for %%F in ("%APPDATA%\Claude\settings.json" "%APPDATA%\Claude\claude-settings.json" ".\.claude\settings.json" ".\config\claude-settings.json") do (
    if exist "%%~F" (
        echo [✓] Found configuration: %%~F
        findstr /C:"ClaudeBell" "%%~F" >nul 2>&1
        if !errorlevel! == 0 (
            echo    - Contains ClaudeBell hooks
            set /a "CONFIGS_FOUND+=1"
        ) else (
            echo    - No ClaudeBell hooks found
        )
    )
)

if !CONFIGS_FOUND! == 0 (
    echo.
    echo [i] No ClaudeBell hooks found in any configuration files.
    echo     Nothing to deactivate.
    echo.
    pause
    exit /b 0
)

echo.
echo ========================================
echo    Deactivation Options
echo ========================================
echo.
echo What would you like to do?
echo.
echo 1. Remove ALL hooks (complete deactivation)
echo 2. Keep hooks but comment them out (easy reactivation)
echo 3. Cancel
echo.
set /p "CHOICE=Enter your choice (1-3): "

if "%CHOICE%" == "3" (
    echo.
    echo [i] Deactivation cancelled.
    pause
    exit /b 0
)

if "%CHOICE%" == "1" (
    echo.
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
    
    echo.
    echo [✓] ClaudeBell has been deactivated.
    echo     Hooks have been removed from configuration files.
    
) else if "%CHOICE%" == "2" (
    echo.
    echo Creating backup configuration files...
    
    if exist "%CONFIG_FILE%" (
        copy "%CONFIG_FILE%" "%CONFIG_FILE%.backup" >nul 2>&1
        echo [✓] Backed up: %CONFIG_FILE%
        
        echo {} > "%CONFIG_FILE%"
        echo [✓] Created empty configuration: %CONFIG_FILE%
    )
    
    if exist "%LOCAL_CONFIG%" (
        copy "%LOCAL_CONFIG%" "%LOCAL_CONFIG%.backup" >nul 2>&1
        echo [✓] Backed up: %LOCAL_CONFIG%
        
        echo {} > "%LOCAL_CONFIG%"
        echo [✓] Created empty configuration: %LOCAL_CONFIG%
    )
    
    echo.
    echo [✓] ClaudeBell has been deactivated.
    echo     Original configurations backed up with .backup extension
    echo.
    echo To reactivate, restore from:
    if exist "%CONFIG_FILE%.backup" echo   - %CONFIG_FILE%.backup
    if exist "%LOCAL_CONFIG%.backup" echo   - %LOCAL_CONFIG%.backup
    
) else (
    echo.
    echo [!] Invalid choice. Deactivation cancelled.
    pause
    exit /b 1
)

echo.
echo ========================================
echo    Deactivation Complete
echo ========================================
echo.
echo ClaudeBell hooks have been disabled.
echo You may need to restart Claude Code for changes to take effect.
echo.
echo To reactivate ClaudeBell, run: install.bat
echo.
pause