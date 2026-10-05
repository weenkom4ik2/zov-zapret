@echo off
setlocal EnableDelayedExpansion

set "HOSTS_FILE=C:\Windows\System32\drivers\etc\hosts"
set "NEW_ENTRY=18.65.39.105 tr.rbxcdn.com"

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

color 0C
title ZOV Roblox Thumbnail Fixer

echo.
echo  ==========================================
echo    ZOV ROBLOX THUMBNAIL FIXER
echo  ==========================================
echo.

if not exist "%HOSTS_FILE%" (
    echo  [ERROR] File not found: %HOSTS_FILE%
    echo.
    pause
    exit /b 1
)

findstr /C:"%NEW_ENTRY%" "%HOSTS_FILE%" >nul
if %errorlevel% equ 0 (
    echo  [INFO] Roblox thumbnails are already fixed.
    echo.
    echo  To revert, open this file and delete the last line:
    echo  %HOSTS_FILE%
    echo.
    echo  Entry: %NEW_ENTRY%
    echo.
    pause
    exit /b 0
)

copy "%HOSTS_FILE%" "%TEMP%\hosts_backup" >nul

echo.>> "%HOSTS_FILE%"
echo %NEW_ENTRY%>> "%HOSTS_FILE%"

if %errorlevel% neq 0 (
    echo  [ERROR] Failed to write to hosts file.
    echo  Trying alternative method...
    copy "%TEMP%\hosts_backup" "%TEMP%\hosts_new" >nul
    echo.>> "%TEMP%\hosts_new"
    echo %NEW_ENTRY%>> "%TEMP%\hosts_new"
    copy /Y "%TEMP%\hosts_new" "%HOSTS_FILE%" >nul
    del "%TEMP%\hosts_new" >nul 2>&1
)

del "%TEMP%\hosts_backup" >nul 2>&1

ipconfig /flushdns >nul 2>&1

echo  ==========================================
echo    [SUCCESS] Thumbnails fixed!
echo  ==========================================
echo.
echo  Restart your Roblox client to apply changes.
echo.
echo  Modified file: %HOSTS_FILE%
echo  Added entry:   %NEW_ENTRY%
echo.
pause
endlocal
