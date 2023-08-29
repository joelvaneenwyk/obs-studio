@echo off
setlocal
call :RunCommand git submodule update --init --recursive
call :RunCommand pwsh -NoProfile -File "%~dp0CI/windows/01_install_dependencies.ps1"
call :RunCommand pwsh -NoProfile -File "%~dp0CI/build-windows.ps1" -Package
goto:eof

:RunCommand
    setlocal EnableDelayedExpansion
    set "_cmd=%*"
    echo %_cmd%
    %_cmd%
exit /b
