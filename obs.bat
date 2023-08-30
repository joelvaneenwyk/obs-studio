@echo off
setlocal EnableDelayedExpansion

taskkill /im "obs-browser-page.exe" /f
taskkill /im "D:\Projects\obs-studio\build64\install\bin\64bit\obs64.exe" /f
taskkill /im "obs64.exe" /f
taskkill /im "OBS Studio" /f

call :RunOBS "%~dp0build64\install\bin\64bit"
if "%ERRORLEVEL%"=="0" goto:eof

call :RunOBS "%~dp0build64\rundir\RelWithDebInfo\bin\64bit"
if "%ERRORLEVEL%"=="0" goto:eof

call :RunOBS "C:\Program Files\obs-studio\bin\64bit"
if "%ERRORLEVEL%"=="0" goto:eof

:RunOBS
    setlocal
    if not exist "%~1\obs64.exe" exit /b 10
    set "_cmd=start "OBS" /D "%~1" "%~1\obs64.exe" "
    echo %_cmd%
    %_cmd%
exit /b 0
