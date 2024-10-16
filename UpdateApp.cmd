@echo off
echo --------------------------------------------------------
echo -
echo     PBFMIS APPLICATION UPDATER
echo     Update latest application from the source repository 
echo     Ver. 1.2 maintained by SDF
echo -
echo --------------------------------------------------------

set "source_folder=\\Appserver\pbfmis\Live"
set "destination_folder=C:\PBOAPP"
set "log_file=C:\PBOAPP\log.txt"

for /f "delims=" %%a in ('sigcheck64.exe -q -n -nobanner "%source_folder%\\Province Centralized System.exe"') do set "source_vers=%%a"
for /f "delims=" %%a in ('sigcheck64.exe -q -n -nobanner "%destination_folder%\\Province Centralized System.exe"') do set "dest_vers=%%a"

if defined source_vers (
    echo Source file version: %source_vers%
    echo Destination file version: %dest_vers%
    if "%source_vers%" gtr "%dest_vers%" (
        echo Source version is greater. Proceed with copy.
        choice /c CA /n /m "Press [C] to copy or [A] to abort: "
        if errorlevel 2 (
            echo Aborted. No files copied.
        ) else (
            xcopy "%source_folder%" "%destination_folder%" /s /i
            echo Files copied successfully.
        )
    ) else if "%source_vers%" equ "%dest_vers%" (
        echo Source version is equal to destination. Abort copy.
    ) else (
        echo Source version is not greater. Abort copy.
    )
) else (
    echo File version not available. Cannot copy the file.
)

for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set "DateTime=%%a"
set "Yr=%DateTime:~0,4%"
set "Mon=%DateTime:~4,2%"
set "Day=%DateTime:~6,2%"
set "Hour=%DateTime:~8,2%"
set "Min=%DateTime:~10,2%"
set "Sec=%DateTime:~12,2%"

rem Combine date and time into a single timestamp
set "Timestamp=%Yr%%Mon%%Day%_%Hour%h%Min%m%Sec%s%"

ren "%destination_folder%\log.txt" "%~n1_%Timestamp%.txt"

echo Copied %source_folder% to %destination_folder% at %Hour%:%Min%:%Sec% on %Mon%/%Day%/%Yr% >> "%log_file%"

pause
