@echo off
echo Triggering UAC/permission prompt...

REM This will request administrator privileges and trigger UAC
powershell -Command "Start-Process cmd -ArgumentList '/c echo Permission granted!' -Verb RunAs"

echo.
echo If you saw a UAC prompt, the permission hook should have been triggered!