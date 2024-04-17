@echo off
setlocal EnableDelayedExpansion

SET /P control_code=Vnesite kodo, ki ustavi delovanje programa: 
del admin.txt 2>nul
echo > admin.txt

rem dobim sezna prepovedanih spletnih strani
set /a index=0

ipconfig /flushdns

:input_loop
echo Naslove spletnih strani vnasaj na nacin: example.com
set "website=stop_it" 
SET /P "website=Enter website link (press Enter to stop): "
IF "%website%"=="stop_it" goto end_input
set /a index+=1
echo %website%
set "websites[!index!]=!website!"
goto input_loop

:end_input
echo.
echo Websites stored in array:
for /l %%i in (1,1,!index!) do (
    echo !websites[%%i]!
)

echo.
echo ------------------Program is running------------------



:check_websites
set /p "admin_password="<admin.txt
if "%control_code%" == "%admin_password%" (
    del admin.txt
    exit
)


for /l %%i in (1,1,%index%) do (
    set "website=!websites[%%i]!"

    ipconfig /displaydns | findstr /i "!website!" >nul
    if not errorlevel 1 (
        echo You visited !website!
        msg * "Zaznana cenzurirana spletna stran."
        goto :positive
    )
)
timeout /t 4 >nul

goto :check_websites


:positive
cd /d C:\Users

:choose_random_dir
set "dirs="
set /a count=0
for /d %%A in (*) do (
    set /a count+=1
    set "dirs[!count!]=%%A"
)
if %count% equ 0 (
    echo !cd!
    goto :end_script
)
set /a "random_number=%random% %% count + 1"
cd "!dirs[%random_number%]!"
set "dirs[%random_number%]="

goto :choose_random_dir

:end_script
echo Prenehaj z uporabo! Izklapljam računalnik čez 20s.
timeout /t 20 /nobreak >nul
set /p "admin_password="<admin.txt
if "%control_code%" == "%admin_password%" (
    del admin.txt
    exit
)
echo LIN KONC JE
rem shutdown /s /f /t 0