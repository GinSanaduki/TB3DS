@echo off
rem Deploy_ShellScripts.bat
pushd "%~dp0"
pushd ..\ShellScripts

..\LinuxTools\busybox_glob.exe rm ./01_UPDATE/*.sh
..\LinuxTools\busybox_glob.exe rm ./02_INTEGRITY_MONITORING/*.sh
..\LinuxTools\busybox_glob.exe rm ./03_DETECTOR/01_Main/*.sh
..\LinuxTools\busybox_glob.exe rm ./03_DETECTOR/02_Allegro/*.sh
..\LinuxTools\busybox_glob.exe rm ./03_DETECTOR/03_Adagio/*.sh
..\LinuxTools\busybox_glob.exe rm ./03_DETECTOR/04_Menuet/*.sh
..\LinuxTools\busybox_glob.exe rm ./03_DETECTOR/05_Cadenza/*.sh
..\LinuxTools\busybox_glob.exe rm ./03_DETECTOR/06_Vivace/*.sh
..\LinuxTools\busybox_glob.exe rm ./04_COMMON/*.sh

..\LinuxTools\busybox_glob.exe cp UTF8/01_UPDATE/*.sh ./01_UPDATE
..\LinuxTools\busybox_glob.exe cp UTF8/02_INTEGRITY_MONITORING/*.sh ./02_INTEGRITY_MONITORING
..\LinuxTools\busybox_glob.exe cp UTF8/03_DETECTOR/01_Main/*.sh ./03_DETECTOR/01_Main
..\LinuxTools\busybox_glob.exe cp UTF8/03_DETECTOR/02_Allegro/*.sh ./03_DETECTOR/02_Allegro
..\LinuxTools\busybox_glob.exe cp UTF8/03_DETECTOR/03_Adagio/*.sh ./03_DETECTOR/03_Adagio
..\LinuxTools\busybox_glob.exe cp UTF8/03_DETECTOR/04_Menuet/*.sh ./03_DETECTOR/04_Menuet
..\LinuxTools\busybox_glob.exe cp UTF8/03_DETECTOR/05_Cadenza/*.sh ./03_DETECTOR/05_Cadenza
..\LinuxTools\busybox_glob.exe cp UTF8/03_DETECTOR/06_Vivace/*.sh ./03_DETECTOR/06_Vivace
..\LinuxTools\busybox_glob.exe cp UTF8/04_COMMON/*.sh ./04_COMMON

..\LinuxTools\nkf32.exe -s -Lw --overwrite ./01_UPDATE/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./02_INTEGRITY_MONITORING/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./03_DETECTOR/01_Main/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./03_DETECTOR/02_Allegro/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./03_DETECTOR/03_Adagio/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./03_DETECTOR/04_Menuet/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./03_DETECTOR/05_Cadenza/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./03_DETECTOR/06_Vivace/*.sh
..\LinuxTools\nkf32.exe -s -Lw --overwrite ./04_COMMON/*.sh

exit /b

