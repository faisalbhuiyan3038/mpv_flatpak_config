@echo off
setlocal EnableDelayedExpansion

echo Updating uosc configuration to add paste button...

set CONFIG_FILE=script-opts\uosc.conf

REM Check if file exists
if not exist "%CONFIG_FILE%" (
    echo Error: %CONFIG_FILE% not found!
    echo Make sure you run this script from your mpv config directory.
    exit /b 1
)

REM Check if paste button already exists
findstr /C:"content_paste:script-binding uosc/paste-to-open" "%CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo Paste button already exists in config!
    goto :end
)

REM Create a backup
copy "%CONFIG_FILE%" "%CONFIG_FILE%.backup" >nul

REM Create a temporary file
set TEMP_FILE=%TEMP%\uosc_temp.conf

REM Process the file line by line
for /f "usebackq tokens=*" %%a in ("%CONFIG_FILE%") do (
    set line=%%a
    
    REM Check if this is the controls line
    echo !line! | findstr /C:"controls=" >nul
    if not errorlevel 1 (
        REM Found controls line, check if it has gap,prev,items
        echo !line! | findstr /C:"gap,prev,items" >nul
        if not errorlevel 1 (
            REM Replace pattern with paste button
            set line=!line:gap,prev,items=command:content_paste:script-binding uosc/paste-to-open?Paste and play from clipboard,gap,prev,items!
        )
    )
    
    REM Write to temp file
    echo !line!>>"%TEMP_FILE%"
)

REM Replace original with modified file
move /y "%TEMP_FILE%" "%CONFIG_FILE%" >nul

REM Verify it worked
findstr /C:"content_paste:script-binding uosc/paste-to-open" "%CONFIG_FILE%" >nul
if errorlevel 1 (
    echo Failed to update config automatically.
    echo Your original config has been backed up to %CONFIG_FILE%.backup
    echo You may need to manually add the paste button to your controls line.
) else (
    echo Successfully added paste button to uosc config!
)

:end
echo Done! 