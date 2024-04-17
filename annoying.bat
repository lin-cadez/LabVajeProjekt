@echo off
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
    REM Check if the line contains a valid IPv4 address
    for /f "tokens=1-4 delims=." %%b in ("%%a") do (
        if %%b GEQ 0 if %%b LEQ 255 if %%c GEQ 0 if %%c LEQ 255 if %%d GEQ 0 if %%d LEQ 255 (
            REM If the line contains a valid IPv4 address, append it to the temporary file
            echo %%a >> %tempFile%
        )
    )
)

REM Overwrite addresses.txt with the content of the temporary file
move /y %tempFile% addresses.txt > nul


for /f "tokens=*" %%a in (addresses.txt) do (
    
   start run.bat %%a
   taskkill /f /im run.bat
)


pause