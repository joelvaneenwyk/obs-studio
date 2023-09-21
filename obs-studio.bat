@echo off
goto:$Main

:TryRunOBS
    setlocal EnableDelayedExpansion
    set "obs_path=%~1"
    if not exist "%obs_path%\obs64.exe" exit /b 10
    set cmd_args=start "OBS" /D "%obs_path%" "%obs_path%\obs64.exe" --startvirtualcam --minimize-to-tray
    echo ##[cmd] !cmd_args!
    !cmd_args!
exit /b 0

:Command
    setlocal EnableDelayedExpansion
    set "command=%*"
    set "command=!command:   = !"
    set "command=!command:  = !"
    echo ##[cmd] !command!
    !command!
exit /b

:StartOBS
    echo [obs-studio] Closing open instances of OBS Studio...
    taskkill /im "obs-browser-page.exe" /f > nul 2>&1
    taskkill /im "D:\Projects\obs-studio\build64\install\bin\64bit\obs64.exe" /f > nul 2>&1
    taskkill /im "obs64.exe" /f > nul 2>&1
    taskkill /im "OBS Studio" /f > nul 2>&1

    call :TryRunOBS "%~dp0build64\install\bin\64bit"
    if "%ERRORLEVEL%"=="0" goto:$StartEnd

    call :TryRunOBS "%~dp0build64\rundir\RelWithDebInfo\bin\64bit"
    if "%ERRORLEVEL%"=="0" goto:$StartEnd

    call :TryRunOBS "C:\Program Files\obs-studio\bin\64bit"
    if "%ERRORLEVEL%"=="0" goto:$StartEnd

    exit /b 99
    :$StartEnd
exit /b 0

:$Main

call :StartOBS
if "%ERRORLEVEL%"=="0" (
    goto:$End
)
:: ) else (
    echo [obs-studio] WARNING: Failed to find OBS Studio executable. Attempting to build from source...
    if exist "%~dp0build.bat" call "%~dp0build.bat"
    call :StartOBS

    if errorlevel 1 (
        echo [obs-studio] ERROR: Failed to find OBS Studio executable even after building source.
        exit /b 98
    )
:: )

:$End
echo [obs-studio] Launch complete.
