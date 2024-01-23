@echo off
goto:$Main

:: Modified version of standard install script that is more permissable and
:: will continue even if 32-bit install failed.
::
:: Copied from "./build64/install/data/obs-plugins/win-dshow/virtualcam-install.bat"
:SetupVirtualCamera
    setlocal EnableDelayedExpansion

    set "root=%~dp0"
    set "root=!root:~0,-1!"

    call :InstallVirtualCamera "!root!" "32" %*
    call :InstallVirtualCamera "!root!" "64" %*

    if "!OBS_SUDO_STATE!"=="" goto:$SkipSudoCacheRestore
        call :Command gsudo cache off
    :$SkipSudoCacheRestore
exit /b

:InstallVirtualCamera
    set "root_path=%~1"
    set "architecture=%~2"
    set "command=%~3"
    set "virtual_cam_guid=A3FCE0F5-3493-419F-958A-ABA1250EC20B"
    set "registry_path_32=HKLM\SOFTWARE\Classes\CLSID\{%virtual_cam_guid%}"
    set "registry_path_64=HKLM\SOFTWARE\Classes\WOW6432Node\CLSID\{%virtual_cam_guid%}"
    set "win_dshow_root=%root_path%\build%architecture%\install\data\obs-plugins\win-dshow"
    set "regsvr=C:\Windows\System32\regsvr32.exe"
    set "module_name=obs-virtualcam-module!architecture!.dll"
    set "module_path=!win_dshow_root!\!module_name!"

    if "!architecture!"=="32" (
        set "registry_path=!registry_path_32!"
    ) else (
        set "registry_path=!registry_path_64!"
    )

    if not exist "!module_path!" (
        echo [ERROR] Failed to find !architecture!-bit Virtual Cam module.
        exit /b 99
    )

    if "!command!"=="uninstall" (
        set target_camera_state=0
        set "regsvr_arguments=/u /s"
    ) else (
        set target_camera_state=1
        set "regsvr_arguments=/i /s"
        set command=install
    )

    goto:$CheckVirtualCameraEnd
    :$CheckVirtualCamera
        set virtual_camera_exists=1
        call :Sudo reg query "!registry_path!" >nul 2>&1
        if errorlevel 1 ( set virtual_camera_exists=0 )
        if "!virtual_camera_exists!"=="!target_camera_state!" ( exit /b 0 )
    exit /b 99
    :$CheckVirtualCameraEnd

    echo Checking !architecture!-bit Virtual Cam registration...
    call :$CheckVirtualCamera
    if "!ERRORLEVEL!"=="0" (
        echo !architecture!-bit Virtual Cam already !command!ed, skipped !command!...
        exit /b 0
    )

    call :Sudo !regsvr! !regsvr_arguments! "!module_path!"
    call :$CheckVirtualCamera
    if not "!ERRORLEVEL!"=="0" (
        echo [ERROR] !architecture!-bit Virtual Cam !command! failed.
        exit /b 88
    )
    echo !architecture!-bit Virtual Cam successfully !command!ed
exit /b 0

:Command
setlocal EnableDelayedExpansion
    set "_command=%*"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    !_command!
exit /b

:Sudo
    if not "%OBS_SUDO_STATE%"=="" goto:$SkipSudoCache
        set OBS_SUDO_STATE=1
        call :Command gsudo cache on
    :$SkipSudoCache

    call :Command gsudo %*
exit /b

::
:: Main
::
:$Main
setlocal EnableExtensions
    call :SetupVirtualCamera %*
exit /b

