@echo off
setlocal EnableDelayedExpansion

call :InstallVirtualCamera "%~dp0"

endlocal & (
    exit /b %ERRORLEVEL%
)

:: Modified version of standard install script that is more permissable and
:: will continue even if 32-bit install failed.
::
:: Copied from "./build64/install/data/obs-plugins/win-dshow/virtualcam-uninstall.bat"
:InstallVirtualCamera
    setlocal EnableDelayedExpansion

    set "root=%~dp1"
    set "root=!root:~0,-1!"
    set "virtual_cam_guid=A3FCE0F5-3493-419F-958A-ABA1250EC20B"

    call :Command gsudo cache on

    set "win_dshow_32=!root!\build32\install\data\obs-plugins\win-dshow"
    cd /d "!win_dshow_32!"
    if exist "!win_dshow_32!\obs-virtualcam-module32.dll" (
        call :Command sudo regsvr32.exe /u /s "!win_dshow_32!\obs-virtualcam-module32.dll"
    ) else (
        call :Command sudo regsvr32.exe /u /s obs-virtualcam-module32.dll
    )

    set "win_dshow_64=!root!\build64\install\data\obs-plugins\win-dshow"
    cd /d "!win_dshow_64!"
    if exist "!win_dshow_64!\obs-virtualcam-module64.dll" (
        call :Command sudo regsvr32.exe /u /s "!win_dshow_64!\obs-virtualcam-module64.dll"
    ) else (
        call :Command sudo regsvr32.exe /u /s obs-virtualcam-module64.dll
    )

    call :Command gsudo cache off
exit /b

:Command
setlocal EnableDelayedExpansion
    set "_command=%*"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    !_command!
exit /b
