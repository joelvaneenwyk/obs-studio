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

:$Main

taskkill /im "obs-browser-page.exe" /f > nul 2>&1
taskkill /im "D:\Projects\obs-studio\build64\install\bin\64bit\obs64.exe" /f > nul 2>&1
taskkill /im "obs64.exe" /f > nul 2>&1
taskkill /im "OBS Studio" /f > nul 2>&1

call :TryRunOBS "%~dp0build64\install\bin\64bit"
if "%ERRORLEVEL%"=="0" goto:eof

call :TryRunOBS "%~dp0build64\rundir\RelWithDebInfo\bin\64bit"
if "%ERRORLEVEL%"=="0" goto:eof

call :TryRunOBS "C:\Program Files\obs-studio\bin\64bit"
if "%ERRORLEVEL%"=="0" goto:eof
