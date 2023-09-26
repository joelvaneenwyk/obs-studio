@echo off
setlocal

set "ENABLE_RELEASE_BUILD=ON"
set "ENABLE_BROWSER=ON"
set "ENABLE_VLC=ON"
set "VIRTUALCAM-GUID=A3FCE0F5-3493-419F-958A-ABA1250EC20B"

if "%~1"=="clean" call :Clean
call :RunCommand git pull --rebase
call :RunCommand git submodule update --init --recursive
call :RunCommand pwsh -NoProfile -File "%~dp0CI/windows/01_install_dependencies.ps1"
call :RunCommand pwsh -NoProfile -File "%~dp0CI/build-windows.ps1" -Package -Verbose -BuildArch x64 -BuildConfiguration Release
call :RunCommand pwsh -NoProfile -File "%~dp0CI/build-windows.ps1" -Package -Verbose -BuildArch x86 -BuildConfiguration Release

goto:eof

:Clean
    if exist "%~dp0build32" call :RunCommand rmdir /s /q "%~dp0build32"
    if exist "%~dp0build64" call :RunCommand rmdir /s /q "%~dp0build64"
    if exist "%~dp0.build" call :RunCommand rmdir /s /q "%~dp0.build"
exit /b

:RunCommand
setlocal EnableDelayedExpansion
    set "_command=%*"
    set "_command=!_command:   = !"
    set "_command=!_command:  = !"
    echo ##[cmd] !_command!
    !_command!
exit /b

::
:: Below is for reference on what the build script passes to CMake.
::

:: --log-level=ERROR
:: -B build64
:: -DBUILD_FOR_DISTRIBUTION="OFF"
:: -DBUILD_FOR_DISTRIBUTION=$(if (Test-Path Env:BUILD_FOR_DISTRIBUTION) { "ON" } else { "OFF" })
:: -DCEF_ROOT_DIR:PATH="Z:\obs-build-dependencies\cef_binary_5060_windows_x64"
:: -DCMAKE_GENERATOR_PLATFORM="x64"
:: -DCMAKE_INSTALL_PREFIX="build64/install"
:: -DCMAKE_INSTALL_PREFIX=${BuildDirectoryActual}/install
:: -DCMAKE_PREFIX_PATH:PATH="Z:\obs-build-dependencies\windows-deps-2023-04-12-x64"
:: -DCMAKE_SYSTEM_VERSION="10.0.18363.657"
:: -DCOPIED_DEPENDENCIES=OFF
:: -DCOPY_DEPENDENCIES=ON
:: -DENABLE_BROWSER=ON
:: -DENABLE_VLC=ON
:: -DGPU_PRIORITY_VAL=""
:: -DGPU_PRIORITY_VAL=${Env:GPU_PRIORITY_VAL}
:: -DRESTREAM_CLIENTID=${Env:RESTREAM_CLIENTID}
:: -DRESTREAM_HASH=${Env:RESTREAM_HASH}
:: -DTWITCH_CLIENTID=${Env:TWITCH_CLIENTID}
:: -DTWITCH_HASH=${Env:TWITCH_HASH}
:: -DVIRTUALCAM_GUID=${Env:VIRTUALCAM-GUID}
:: -DVLC_PATH:PATH="Z:\obs-studio/../obs-build-dependencies/vlc-3.0.0-git"
:: -DVLC_PATH:PATH=${CheckoutDir}/../obs-build-dependencies/vlc-${WindowsVlcVersion}
:: -DYOUTUBE_CLIENTID_HASH=${Env:YOUTUBE_CLIENTID_HASH}
:: -DYOUTUBE_CLIENTID=${Env:YOUTUBE_CLIENTID}
:: -DYOUTUBE_SECRET_HASH=${Env:YOUTUBE_SECRET_HASH}
:: -DYOUTUBE_SECRET=${Env:YOUTUBE_SECRET}
:: -G Visual Studio 17 2022
:: -S .
:: -Wno-deprecated
:: -Wno-dev
