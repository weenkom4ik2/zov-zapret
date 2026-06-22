@echo off
setlocal
color 6

REM Define flag file to check if the script has run before
set "flagFile=%~dp0region_flag.txt"

REM Function to simulate delay
set "delay=82"  REM milliseconds

:ChooseRegion
echo Please select your region:
echo 1. Germany
echo 2. USA
echo 3. Norway
echo 4. Netherlands
echo 5. Russia
set /p choice=Enter the number of your choice: 

REM Simulate delay
powershell -Command "Start-Sleep -Milliseconds %delay%"

if "%choice%"=="1" goto SetGermany
if "%choice%"=="2" goto SetUSA
if "%choice%"=="3" goto SetNorway
if "%choice%"=="4" goto SetNetherlands
if "%choice%"=="5" goto SetRussia

echo Invalid selection. Please try again.
goto ChooseRegion

:SetGermany
echo You selected Germany.
if exist "%flagFile%" (
    echo Reapplying German region...
) else (
    echo Setting German region...
)
powershell -Command "Set-WinSystemLocale -SystemLocale 'de-DE' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinUserLanguageList -LanguageList 'de-DE' -Force -ErrorAction SilentlyContinue"
powershell -Command "Set-Culture -CultureInfo 'de-DE' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinHomeLocation -GeoId 94 -ErrorAction SilentlyContinue"  # Germany
echo REGION: Germany
echo 1 > "%flagFile%"
pause
exit /b

:SetUSA
echo You selected USA.
if exist "%flagFile%" (
    echo Reapplying US region...
) else (
    echo Setting US region...
)
powershell -Command "Set-WinSystemLocale -SystemLocale 'en-US' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinUserLanguageList -LanguageList 'en-US' -Force -ErrorAction SilentlyContinue"
powershell -Command "Set-Culture -CultureInfo 'en-US' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinHomeLocation -GeoId 244 -ErrorAction SilentlyContinue"  # US
echo REGION: US
echo 1 > "%flagFile%"
pause
exit /b

:SetNorway
echo You selected Norway.
if exist "%flagFile%" (
    echo Reapplying Norway region...
) else (
    echo Setting Norway region...
)
powershell -Command "Set-WinSystemLocale -SystemLocale 'nb-NO' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinUserLanguageList -LanguageList 'nb-NO' -Force -ErrorAction SilentlyContinue"
powershell -Command "Set-Culture -CultureInfo 'nb-NO' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinHomeLocation -GeoId 89 -ErrorAction SilentlyContinue"  # Norway
echo REGION: Norway
echo 1 > "%flagFile%"
pause
exit /b

:SetNetherlands
echo You selected Netherlands.
if exist "%flagFile%" (
    echo Reapplying Netherlands region...
) else (
    echo Setting Netherlands region...
)
powershell -Command "Set-WinSystemLocale -SystemLocale 'nl-NL' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinUserLanguageList -LanguageList 'nl-NL' -Force -ErrorAction SilentlyContinue"
powershell -Command "Set-Culture -CultureInfo 'nl-NL' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinHomeLocation -GeoId 151 -ErrorAction SilentlyContinue"  # Netherlands
echo REGION: Netherlands
echo 1 > "%flagFile%"
pause
exit /b

:SetRussia
echo You selected Russia.
if exist "%flagFile%" (
    echo Reapplying Russia region...
) else (
    echo Setting Russia region...
)
powershell -Command "Set-WinSystemLocale -SystemLocale 'ru-RU' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinUserLanguageList -LanguageList 'ru-RU' -Force -ErrorAction SilentlyContinue"
powershell -Command "Set-Culture -CultureInfo 'ru-RU' -ErrorAction SilentlyContinue"
powershell -Command "Set-WinHomeLocation -GeoId 244 -ErrorAction SilentlyContinue"  # Russia
echo REGION: Russia
echo 1 > "%flagFile%"
pause
exit /b