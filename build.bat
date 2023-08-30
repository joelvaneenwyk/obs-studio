@echo off
setlocal

set "ENABLE_RELEASE_BUILD=ON"
set "ENABLE_BROWSER=ON"
set "ENABLE_VLC=ON"
set "VIRTUALCAM_GUID=A3FCE0F5-3493-419F-958A-ABA1250EC20B"

call :RunCommand git pull --rebase
call :RunCommand git submodule update --init --recursive
call :RunCommand pwsh -NoProfile -File "%~dp0CI/windows/01_install_dependencies.ps1"
call :RunCommand pwsh -NoProfile -File "%~dp0CI/build-windows.ps1" -Package -Verbose
goto:eof

:RunCommand
    setlocal EnableDelayedExpansion
    set "_cmd=%*"
    echo %_cmd%
    %_cmd%
exit /b

REM  + Invoke-External: cmake
REM -S .
REM -B build64
REM -G Visual Studio 17 2022
REM -DCMAKE_GENERATOR_PLATFORM="x64"
REM -DCMAKE_SYSTEM_VERSION="10.0.18363.657"
REM -DCMAKE_PREFIX_PATH:PATH="D:\Projects\obs-build-dependencies\windows-deps-2023-04-12-x64"
REM -DCEF_ROOT_DIR:PATH="D:\Projects\obs-build-dependencies\cef_binary_5060_windows_x64"
REM -DENABLE_BROWSER=ON
REM -DVLC_PATH:PATH="D:\Projects\obs-studio/../obs-build-dependencies/vlc-3.0.0-git"
REM -DENABLE_VLC=ON
REM -DCMAKE_INSTALL_PREFIX="build64/install"
REM -DVIRTUALCAM_GUID=""
REM -DTWITCH_CLIENTID=""
REM -DTWITCH_HASH=""
REM -DRESTREAM_CLIENTID=""
REM -DRESTREAM_HASH=""
REM -DYOUTUBE_CLIENTID=""
REM -DYOUTUBE_CLIENTID_HASH=""
REM -DYOUTUBE_SECRET=""
REM -DYOUTUBE_SECRET_HASH=""
REM -DGPU_PRIORITY_VAL=""
REM -DCOPIED_DEPENDENCIES=OFF
REM -DCOPY_DEPENDENCIES=ON
REM -DBUILD_FOR_DISTRIBUTION="OFF"
REM -Wno-deprecated
REM -Wno-dev
REM --log-level=ERROR

REM "-G", ${CmakeGenerator}
REM "-DCMAKE_GENERATOR_PLATFORM=${GeneratorPlatform}",
REM "-DCMAKE_SYSTEM_VERSION=${CmakeSystemVersion}",
REM "-DCMAKE_PREFIX_PATH:PATH=${CmakePrefixPath}",
REM "-DCEF_ROOT_DIR:PATH=${CefDirectory}",
REM "-DENABLE_BROWSER=ON",
REM "-DVLC_PATH:PATH=${CheckoutDir}/../obs-build-dependencies/vlc-${WindowsVlcVersion}",
REM "-DENABLE_VLC=ON",
REM "-DCMAKE_INSTALL_PREFIX=${BuildDirectoryActual}/install",
REM "-DVIRTUALCAM_GUID=${Env:VIRTUALCAM-GUID}",
REM "-DTWITCH_CLIENTID=${Env:TWITCH_CLIENTID}",
REM "-DTWITCH_HASH=${Env:TWITCH_HASH}",
REM "-DRESTREAM_CLIENTID=${Env:RESTREAM_CLIENTID}",
REM "-DRESTREAM_HASH=${Env:RESTREAM_HASH}",
REM "-DYOUTUBE_CLIENTID=${Env:YOUTUBE_CLIENTID}",
REM "-DYOUTUBE_CLIENTID_HASH=${Env:YOUTUBE_CLIENTID_HASH}",
REM "-DYOUTUBE_SECRET=${Env:YOUTUBE_SECRET}",
REM "-DYOUTUBE_SECRET_HASH=${Env:YOUTUBE_SECRET_HASH}",
REM "-DGPU_PRIORITY_VAL=${Env:GPU_PRIORITY_VAL}",
REM "-DCOPIED_DEPENDENCIES=OFF",
REM "-DCOPY_DEPENDENCIES=ON",
REM "-DBUILD_FOR_DISTRIBUTION=$(if (Test-Path Env:BUILD_FOR_DISTRIBUTION) { "ON" } else { "OFF" })",
REM "$(if (Test-Path Env:CI) { "-DOBS_BUILD_NUMBER=${Env:GITHUB_RUN_ID}" })",
REM "$(if (Test-Path Variable:$Quiet) { "-Wno-deprecated -Wno-dev --log-level=ERROR" })"
