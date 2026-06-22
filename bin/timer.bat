@echo off
setlocal enabledelayedexpansion
color 2
mode con: cols=20 lines=5

rem Получение начального времени в миллисекундах
for /f "tokens=1-4 delims=:.," %%a in ("%time%") do (
    set /a "sh=%%a*3600000 + %%b*60000 + %%c*1000 + %%d"
)

:loop
    rem Получение текущего времени
    for /f "tokens=1-4 delims=:.," %%a in ("%time%") do (
        rem Удаление ведущих нулей
        set "hh=%%a"
        set "mm=%%b"
        set "ss=%%c"
        set "ms=%%d"

        rem Удаляем ведущие нули
        for %%A in (!hh!) do if %%A lss 10 set "hh=%%A"
        for %%A in (!mm!) do if %%A lss 10 set "mm=%%A"
        for %%A in (!ss!) do if %%A lss 10 set "ss=%%A"
        for %%A in (!ms!) do if %%A lss 10 set "ms=%%A"

        rem Перевод в числа без ведущих нулей
        set /a "ch=hh*3600000 + mm*60000 + ss*1000 + ms"
    )

    set /a "elapsed=ch - sh"
    if !elapsed! lss 0 set /a "elapsed+=86400000"

    set /a "h=elapsed/3600000"
    set /a "m=(elapsed%%3600000)/60000"
    set /a "s=(elapsed%%60000)/1000"
    set /a "ms=elapsed%%1000"

    if !h! lss 10 set "h=0!h!"
    if !m! lss 10 set "m=0!m!"
    if !s! lss 10 set "s=0!s!"
    if !ms! lss 10 set "ms=00!ms!"
    if !ms! gtr 9 if !ms! lss 100 set "ms=0!ms!"
    if !ms! gtr 99 set "ms=!ms!"

    set "timeText=!h!:!m!:!s!.!ms!"

    echo !timeText!

    goto loop