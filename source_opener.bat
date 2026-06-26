@echo off
setlocal enabledelayedexpansion

call :browse_files "%~dp0"
goto end

:end
echo ?Finished?.
pause
exit /b

:browse_files
set "current_dir=%~1"

:loop
cls
color 4
echo Browsing directory: "%current_dir%"
echo.

set count=0
for /f "delims=" %%A in ('dir "%current_dir%" /b') do (
    set /a count+=1
    set "item[!count!]=%%A"
    set "full_path=%current_dir%\%%A"
    for /f "usebackq tokens=1" %%H in (`attrib "%full_path%"`) do (
        set "attributes=%%H"
        if "%%H"=="<DIR>" (
            set "type=Folder"
        ) else (
            set "type=File"
        )
    )
    echo %attributes% | find "H" >nul && set "hidden=" || set "hidden="
    echo !count!. %%A  !hidden!
)
echo 0. Exit
echo.

set /p choice=Enter the number of your choice: 

if "%choice%"=="0" goto :eof

if not defined item[%choice%] (
    echo Invalid selection, please try again.
    pause
    goto loop
)

set "selected_item=!item[%choice%]!"
set "selected_path=%current_dir%\!selected_item!"

for /f "usebackq tokens=1" %%H in (`attrib "%selected_path%"`) do (
    set "attributes=%%H"
    if "%%H"=="<DIR>" (
        call :browse_files "%selected_path%"
        goto loop
    ) else (
        start "" "%selected_path%"
        echo Opening "%selected_item%"...
        pause
    )
)

goto loop
