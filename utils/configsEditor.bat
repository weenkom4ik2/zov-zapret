@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
color 4

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

:: ---------- Admin (soft) ----------
net session >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [!] Administrator rights required.
    echo      Right-click this file -^> "Run as administrator".
    echo.
    pause
    exit /b 1
)

:menu
cls
echo.
echo  ============================================
echo   ZOV ZAPRET CONFIGS
echo  ============================================
echo.
echo   [1] Export current config as code (lines)
echo   [2] Apply code (paste lines, end with END)
echo   [3] Show current lists/settings
echo   [0] Exit
echo.
set "choice="
set /p "choice=Select: "

if "%choice%"=="1" goto export_code
if "%choice%"=="2" goto apply_code
if "%choice%"=="3" goto show_current
if "%choice%"=="0" goto end
goto menu

:: ---------- Export ----------
:export_code
cls
echo.
echo  [*] Building code from current lists and settings...
echo.

set "STRATEGY=manual"
if exist "%SCRIPT_DIR%active_strategy.txt" set /p STRATEGY=<"%SCRIPT_DIR%active_strategy.txt"
set "STRATEGY=!STRATEGY:.bat=!"
set "STRATEGY=!STRATEGY: =!"
set "GF=0"
if exist "%SCRIPT_DIR%.gamefilter_on" set "GF=1"
set "IPF=none"
if exist "%SCRIPT_DIR%.ipset_loaded" set "IPF=loaded"
if exist "%SCRIPT_DIR%.ipset_any" set "IPF=any"

echo  ===== CODE START =====
echo S=%STRATEGY%
echo G=%GF%
echo I=%IPF%
for %%f in ("%SCRIPT_DIR%lists\*.txt") do (
    set "REL=%%~f"
    set "REL=!REL:%SCRIPT_DIR%=!"
    echo L=!REL!
    for /f "usebackq delims=" %%L in ("%%~f") do (
        if not "%%L"=="" echo E=!REL!^|%%L
    )
)
echo END
echo  ===== CODE END =====
echo.
echo  Copy all lines between START and END (including END).
echo  To apply: [2], paste all lines, last line must be END.
echo.
pause
goto menu

:: ---------- Apply ----------
:apply_code
cls
echo.
echo  Paste code lines one by one. Last line must be END.
echo  To cancel, type CANCEL on empty line.
echo.
set "PLAIN=%TEMP%\zov_%RANDOM%.txt"
> "%PLAIN%" echo.
set "CANCELED=0"

:apply_loop
set "LINE="
set /p "LINE=>"
if "!LINE!"=="" goto apply_loop
if /i "!LINE!"=="CANCEL" goto apply_cancel
if /i "!LINE!"=="END" goto apply_ready
>>"%PLAIN%" echo !LINE!
goto apply_loop

:apply_ready
echo.
echo  Parsed:
echo  ------------------------------
type "%PLAIN%"
echo  ------------------------------
set "confirm="
set /p "confirm=Apply? (y/n): "
if /i not "%confirm%"=="y" goto apply_cancel

:: delete old referenced lists
for /f "usebackq tokens=1,* delims==" %%k in ("%PLAIN%") do (
    if /i "%%k"=="L" (
        set "REL=%%l"
        set "FULL=%SCRIPT_DIR%!REL!"
        if exist "!FULL!" del "!FULL!" >nul 2>&1
        for %%D in ("!FULL!") do (
            if not "%%~dpD"=="" if not exist "%%~dpD" mkdir "%%~dpD" >nul 2>&1
        )
    )
)
:: write list lines
for /f "usebackq tokens=1,* delims==" %%k in ("%PLAIN%") do (
    if /i "%%k"=="E" (
        set "LVAL=%%l"
        for /f "tokens=1,* delims=|" %%p in ("!LVAL!") do (
            set "REL=%%p"
            set "ENTRY=%%q"
            set "FULL=%SCRIPT_DIR%!REL!"
            >>"!FULL!" echo !ENTRY!
        )
    )
)
:: apply settings
set "STRATEGY=manual"
set "GF=0"
set "IPF=none"
for /f "usebackq tokens=1,* delims==" %%k in ("%PLAIN%") do (
    if /i "%%k"=="S" set "STRATEGY=%%l"
    if /i "%%k"=="G" set "GF=%%l"
    if /i "%%k"=="I" set "IPF=%%l"
)
> "%SCRIPT_DIR%active_strategy.txt" echo %STRATEGY%.bat
if "%GF%"=="1" ( > "%SCRIPT_DIR%.gamefilter_on" echo 1 ) else ( if exist "%SCRIPT_DIR%.gamefilter_on" del "%SCRIPT_DIR%.gamefilter_on" >nul 2>&1 )
if exist "%SCRIPT_DIR%.ipset_loaded" del "%SCRIPT_DIR%.ipset_loaded" >nul 2>&1
if exist "%SCRIPT_DIR%.ipset_any" del "%SCRIPT_DIR%.ipset_any" >nul 2>&1
if /i "%IPF%"=="loaded" > "%SCRIPT_DIR%.ipset_loaded" echo 1
if /i "%IPF%"=="any"    > "%SCRIPT_DIR%.ipset_any" echo 1

echo  [+] Applied. Restart service: service.bat -^> Remove Services, then Install Service
del "%PLAIN%" >nul 2>&1
pause
goto menu

:apply_cancel
del "%PLAIN%" >nul 2>&1
echo  Cancelled.
pause
goto menu

:: ---------- Show current ----------
:show_current
cls
echo --- settings ---
if exist "%SCRIPT_DIR%active_strategy.txt" (
    set /p S=<"%SCRIPT_DIR%active_strategy.txt"
    echo strategy=!S!
) else (
    echo strategy=manual
)
if exist "%SCRIPT_DIR%.gamefilter_on" ( echo game_filter=1 ) else ( echo game_filter=0 )
if exist "%SCRIPT_DIR%.ipset_loaded" ( echo ipset_filter=loaded ) else (
    if exist "%SCRIPT_DIR%.ipset_any" ( echo ipset_filter=any ) else ( echo ipset_filter=none )
)
echo.
echo --- lists ---
for %%f in ("%SCRIPT_DIR%lists\*.txt") do (
    set "REL=%%~f"
    set "REL=!REL:%SCRIPT_DIR%=!"
    set "N=0"
    for /f "usebackq delims=" %%L in ("%%~f") do set /a N+=1
    echo !REL! [!N! lines]
)
pause
goto menu

:end
exit /b 0