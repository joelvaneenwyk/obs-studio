echo off
setlocal EnableDelayedExpansion

call :Install "%~dp0build64\install\data\obs-plugins\win-dshow\virtualcam-install.bat"
if "%ERRORLEVEL%"=="0" goto:eof

call :Install "%~dp0.build\windows-release\rundir\Release\data\obs-plugins\win-dshow\virtualcam-install.bat"
if "%ERRORLEVEL%"=="0" goto:eof

call :Install "%~dp0.build\windows-debug\rundir\Debug\data\obs-plugins\win-dshow\virtualcam-install.bat"
if "%ERRORLEVEL%"=="0" goto:eof

call :Install "C:\Program Files\obs-studio\data\obs-plugins\win-dshow\virtualcam-install.bat"
if "%ERRORLEVEL%"=="0" goto:eof

:Install
setlocal
if not exist "%~1" exit /b 10
sudo call "%~1"
exit /b 0
