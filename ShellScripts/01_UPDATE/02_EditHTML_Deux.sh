#! /bin/sh
# 02_EditHTML_Deux.sh
# busybox sh ShellScripts/01_UPDATE/02_EditHTML_Deux.sh

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2019 The LOTLTHNBR Project Authors, GinSanaduki.
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
# LOTLTHNBR Scripts provides a function to obtain a list of non-returned license numbers of teacher licenses 
# from the Ministry of Education, Culture, Sports, Science and Technology from the website of the Ministry 
# of Education, Culture, Sports, Science and Technology, and to inquire by license number.
# This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later 
# and BusyBox developed by Erik Andersen, Rob Landley, Denys Vlasenko and others.
# GAWK 5.0.1 Download ezwinports from SourceForge.net
# https://sourceforge.net/projects/ezwinports/files/gawk-5.0.1-w32-bin.zip/download
# BusyBox Official
# https://www.busybox.net/
# BusyBox -w32
# http://frippery.org/busybox/
# Download
# http://frippery.org/files/busybox/busybox.exe
# BusyBox Wildcard expansion
# https://frippery.org/busybox/globbing.html
# Download
# https://frippery.org/files/busybox/busybox_glob.exe

# ------------------------------------------------------------------------------------------------------------------------

DATE=`date +%Y%m%d`
EDITFILE_ORIGIN="EditedHTML/List_of_disciplinary_dismissal_disposal_"$DATE".txt"
EXTRACTLIST="EditedHTML_Deux/ExtractList_"$DATE".tsv"
EXEC_SHELL="EditedHTML_Deux/ExecShell.sh"

awk -f AWKScripts/01_UPDATE/03_SubSystem/01_EditHTML_Deux_SubSystem_01.awk $EDITFILE_ORIGIN | \
LinuxTools/gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/02_EditHTML_Deux_SubSystem_02.awk | \
unix2dos > $EXTRACTLIST

: > $EXEC_SHELL

awk 'BEGIN{FS = "\t";}{print $3;}' $EXTRACTLIST | \
awk '{sub("https://kanpou.npb.go.jp/","EditedHTML_Trois/");print;}' | \
awk 'BEGIN{FS = "/";}{print "mkdir -p "$1"/"$2"/"$3" > nul 2>&1";}' > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

: > $EXEC_SHELL

awk 'BEGIN{FS = "\t";}{print $3;}' $EXTRACTLIST | \
awk '{sub("https://kanpou.npb.go.jp/","EditedHTML_Trois/");print;}' | \
awk -f AWKScripts/01_UPDATE/03_SubSystem/03_EditHTML_Deux_SubSystem_03.awk > $EXEC_SHELL

sh $EXEC_SHELL

