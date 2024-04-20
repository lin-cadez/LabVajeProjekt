@echo off
rmdir /s /q temp
mkdir temp
cd temp

del addresses.txt
REM Clear the existing content of addresses.txt
echo. > addresses.txt

REM Get IPv4 addresses of all devices on the network and save them to addresses.txt
for /f "tokens=1" %%a in ('arp -a ^| findstr /R "\<[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\>"') do (
    echo %%a >> addresses.txt
)

set "tempFile=temp.txt"
echo. > %tempFile%

REM Loop through each line in addresses.txt
for /f "tokens=*" %%a in (addresses.txt) do (
    REM Check if the line starts with "192.168."
    echo %%a | findstr /R "^192\.168\." > nul
    if not errorlevel 1 (
        REM If the line starts with "192.168.", append it to the temporary file
        echo %%a >> %tempFile%
    )
)
REM Overwrite addresses.txt with the content of the temporary file
move /y %tempFile% addresses.txt > nul

REM Ping the remaining IPv4 addresses starting with "192.168."
for /f "tokens=*" %%a in (addresses.txt) do (
    ping -n 1 %%a | findstr /i /r ", Received = [0-9]*" > nul
    if not errorlevel 1 (
        echo %%a
    )
)

cls
echo OVERVIEW
type addresses.txt | findstr /r "[0-9]" > temp.txt
copy temp.txt addresses.txt > nul
del temp.txt

for /f "tokens=*" %%a in (addresses.txt) do (
    echo %%a
)



cd ..

pause