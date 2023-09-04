@echo off
setlocal

set "ENABLE_RELEASE_BUILD=ON"
set "ENABLE_BROWSER=ON"
set "ENABLE_VLC=ON"
set "VIRTUALCAM-GUID=A3FCE0F5-3493-419F-958A-ABA1250EC20B"

call :RunCommand git pull --rebase
call :RunCommand git submodule update --init --recursive
call :RunCommand pwsh -NoProfile -File "%~dp0CI/windows/01_install_dependencies.ps1"


REM --log-level=ERROR
REM -B build64
REM -DBUILD_FOR_DISTRIBUTION="OFF"
REM -DBUILD_FOR_DISTRIBUTION=$(if (Test-Path Env:BUILD_FOR_DISTRIBUTION) { "ON" } else { "OFF" })
REM -DCEF_ROOT_DIR:PATH="D:\Projects\obs-build-dependencies\cef_binary_5060_windows_x64"
REM -DCMAKE_GENERATOR_PLATFORM="x64"
REM -DCMAKE_INSTALL_PREFIX="build64/install"
REM -DCMAKE_INSTALL_PREFIX=${BuildDirectoryActual}/install
REM -DCMAKE_PREFIX_PATH:PATH="D:\Projects\obs-build-dependencies\windows-deps-2023-04-12-x64"
REM -DCMAKE_SYSTEM_VERSION="10.0.18363.657"
REM -DCOPIED_DEPENDENCIES=OFF
REM -DCOPY_DEPENDENCIES=ON
REM -DENABLE_BROWSER=ON
REM -DENABLE_VLC=ON
REM -DGPU_PRIORITY_VAL=""
REM -DGPU_PRIORITY_VAL=${Env:GPU_PRIORITY_VAL}
REM -DRESTREAM_CLIENTID=${Env:RESTREAM_CLIENTID}
REM -DRESTREAM_HASH=${Env:RESTREAM_HASH}
REM -DTWITCH_CLIENTID=${Env:TWITCH_CLIENTID}
REM -DTWITCH_HASH=${Env:TWITCH_HASH}
REM -DVIRTUALCAM_GUID=${Env:VIRTUALCAM-GUID}
REM -DVLC_PATH:PATH="D:\Projects\obs-studio/../obs-build-dependencies/vlc-3.0.0-git"
REM -DVLC_PATH:PATH=${CheckoutDir}/../obs-build-dependencies/vlc-${WindowsVlcVersion}
REM -DYOUTUBE_CLIENTID_HASH=${Env:YOUTUBE_CLIENTID_HASH}
REM -DYOUTUBE_CLIENTID=${Env:YOUTUBE_CLIENTID}
REM -DYOUTUBE_SECRET_HASH=${Env:YOUTUBE_SECRET_HASH}
REM -DYOUTUBE_SECRET=${Env:YOUTUBE_SECRET}
REM -G Visual Studio 17 2022
REM -S .
REM -Wno-deprecated
REM -Wno-dev
call :RunCommand pwsh -NoProfile -File "%~dp0CI/build-windows.ps1" -Package -Verbose -BuildConfiguration Release

goto:eof

:RunCommand
    setlocal EnableDelayedExpansion
    set "_cmd=%*"
    echo %_cmd%
    %_cmd%
exit /b
