@echo off
rem 05_Exec_UPDATE.bat
pushd "%~dp0"
pushd ..\

LinuxTools\busybox.exe sh ShellScripts/01_UPDATE/01_CALL_UPDATE.sh

pause

exit /b

