@echo off
setlocal EnableDelayedExpansion

call :InstallVirtualCamera "%~dp0"
REM call :InstallVirtualCameraExternal

endlocal & (
    exit /b %ERRORLEVEL%
)

:: Modified version of standard install script that is more permissable and
:: will continue even if 32-bit install failed.
::
:: Copied from "./build64/install/data/obs-plugins/win-dshow/virtualcam-install.bat"
:InstallVirtualCamera
    setlocal EnableDelayedExpansion

    set "root=%~dp1"
    set "root=!root:~0,-1!"
    set "win_dshow=!root!\build64\install\data\obs-plugins\win-dshow"
    @cd /d "!win_dshow!"

    :checkDLL
        echo Checking for 32-bit Virtual Cam registration...
        gsudo reg query "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{A3FCE0F5-3493-419F-958A-ABA1250EC20B}" >nul 2>&1
        if "%ERRORLEVEL%"=="0" (
            echo 32-bit Virtual Cam found, skipped install...
        ) else (
            echo 32-bit Virtual Cam not found, installing...
            goto install32DLL
        )

    :CheckDLLContinue
        echo Checking for 64-bit Virtual Cam registration...
        gsudo reg query "HKLM\SOFTWARE\Classes\CLSID\{A3FCE0F5-3493-419F-958A-ABA1250EC20B}" >nul 2>&1
        if "%ERRORLEVEL%"=="0" (
            echo 64-bit Virtual Cam found, skipping install...
            echo.
        ) else (
            echo 64-bit Virtual Cam not found, installing...
            goto install64DLL
        )
        goto endSuccess

    :install32DLL
        echo Installing 32-bit Virtual Cam...
        if exist "%~dp0\data\obs-plugins\win-dshow\obs-virtualcam-module32.dll" (
            gsudo regsvr32.exe /i /s "%~dp0\data\obs-plugins\win-dshow\obs-virtualcam-module32.dll"
        ) else (
            gsudo regsvr32.exe /i /s obs-virtualcam-module32.dll
        )
        reg query "HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{A3FCE0F5-3493-419F-958A-ABA1250EC20B}" >nul 2>&1
        if "%ERRORLEVEL%"=="0" (
            echo 32-bit Virtual Cam successfully installed
        ) else (
            echo 32-bit Virtual Cam installation failed
            goto end
        )
        goto checkDLLContinue

    :install64DLL
        echo Installing 64-bit Virtual Cam...
        if exist "%~dp0\data\obs-plugins\win-dshow\obs-virtualcam-module64.dll" (
            gsudo regsvr32.exe /i /s "%~dp0\data\obs-plugins\win-dshow\obs-virtualcam-module64.dll"
        ) else (
            gsudo regsvr32.exe /i /s obs-virtualcam-module64.dll
        )
        reg query "HKLM\SOFTWARE\Classes\CLSID\{A3FCE0F5-3493-419F-958A-ABA1250EC20B}" >nul 2>&1
        if "%ERRORLEVEL%"=="0" (
            echo 64-bit Virtual Cam successfully installed
            echo.
            goto endSuccess
        ) else (
            echo 64-bit Virtual Cam installation failed
            echo.
            goto end
        )

    :endSuccess
        echo Virtual Cam installed!
        echo.

    :end
        pause
        exit

:InstallVirtualCameraExternal
    setlocal EnableDelayedExpansion

    call :Install "%~dp0build64\install\data\obs-plugins\win-dshow\virtualcam-install.bat"
    if "%ERRORLEVEL%"=="0" goto:eof

    call :Install "%~dp0.build\windows-release\rundir\Release\data\obs-plugins\win-dshow\virtualcam-install.bat"
    if "%ERRORLEVEL%"=="0" goto:eof

    call :Install "%~dp0.build\windows-debug\rundir\Debug\data\obs-plugins\win-dshow\virtualcam-install.bat"
    if "%ERRORLEVEL%"=="0" goto:eof

    call :Install "C:\Program Files\obs-studio\data\obs-plugins\win-dshow\virtualcam-install.bat"
    if "%ERRORLEVEL%"=="0" goto:eof

    echo [obs-studio] ERROR: Failed to find script to install virtual camera.
exit /b 99

:Install
    setlocal EnableDelayedExpansion
    if not exist "%~1" exit /b 10
    call :Command gsudo "C:\Windows\System32\cmd.exe" /d /c "%~1"
exit /b 0

:Command
setlocal EnableDelayedExpansion
    set "_command=%*"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    !_command!
exit /b
