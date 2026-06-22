@echo off
setlocal
color 6
set "flagFile=%~dp0region_flag.txt"

if exist "%flagFile%" (
    REM Файл существует — уже был запуск, устанавливаем русский регион
    echo RECREATING RU
    powershell -Command "Set-WinSystemLocale -SystemLocale 'ru-RU' -ErrorAction SilentlyContinue"
    powershell -Command "Set-WinUserLanguageList -LanguageList 'ru-RU' -Force -ErrorAction SilentlyContinue"
    powershell -Command "Set-Culture -CultureInfo 'ru-RU' -ErrorAction SilentlyContinue"
    powershell -Command "Set-WinHomeLocation -GeoId 244 -ErrorAction SilentlyContinue"
    del "%flagFile%"
    echo REGION: RU
) else (
    REM Первый запуск — устанавливаем английский регион
    echo RECREATING US
powershell -Command "$LangList = New-Object -TypeName System.Collections.Generic.List[System.String]; $LangList.Add('en-US'); Set-WinUserLanguageList -LanguageList $LangList -Force"
    powershell -Command "Set-WinSystemLocale -SystemLocale 'en-US' -ErrorAction SilentlyContinue"
    powershell -Command "Set-Culture -CultureInfo 'en-US' -ErrorAction SilentlyContinue"
    powershell -Command "Set-WinHomeLocation -GeoId 244 -ErrorAction SilentlyContinue"
    echo REGION: US
    echo 1 > "%flagFile%"
)

echo UPDATE DONE. RESTART FOR FULL FOCUS. WIN + SPACE WILL NOT CHANGE YOUR LANGUAGE!! TO SET IT BACK GO TO "PARAMETERS -> LANGUAGE" AND ADD BACK LANGUAGE U WANT
pause