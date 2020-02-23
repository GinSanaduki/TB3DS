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
TROISLIST="EditedHTML_Deux/TroisList.txt"
TROISHASH="EditedHTML_Deux/TroisHash.tsv"
QUATREHASH="EditedHTML_Deux/QuatreHash.tsv"
TODAY_CINQLIST="EditedHTML_Deux/TodayCinqList.txt"
TARGETLINK="EditedHTML_Deux/TargetLink.tsv"
TARGETLINK_Deux="EditedHTML_Deux/TargetLink_Deux.tsv"
TARGETLINK_Trois="EditedHTML_Deux/TargetLink_Trois.tsv"
TARGETLINK_Quatre="EditedHTML_Deux/TargetLink_Quatre.tsv"
 TODAY_PNGHASH="EditedHTML_Deux/TargetLink_PNGHash_"$DATE".tsv"
 TODAY_TXTHASH="EditedHTML_Deux/TargetLink_TXTHash_"$DATE".tsv"




awk -f AWKScripts/01_UPDATE/03_SubSystem/01_EditHTML_Deux_SubSystem_01.awk $EDITFILE_ORIGIN | \
LinuxTools/gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/02_EditHTML_Deux_SubSystem_02.awk | \
unix2dos > $EXTRACTLIST

: > $EXEC_SHELL
: > $TROISLIST

awk 'BEGIN{FS = "\t";}{print $3;}' $EXTRACTLIST | \
awk '{sub("https://kanpou.npb.go.jp/","EditedHTML_Trois/");print;}' > $TROISLIST

# �������t��HTML����擾�����n�C�p�[�����N�̃��X�g�ɑΉ�����UTF-8��HTML���i�[����f�B���N�g���𖳏����ɐ���
awk 'BEGIN{FS = "/";}{print "mkdir -p "$1"/"$2"/"$3" > nul 2>&1";}' $TROISLIST > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

: > $EXEC_SHELL

# ���YUTF-8�t�@�C�������݂��Ȃ��A�܂��͋�t�@�C���ł���ꍇ�A�擾��10�b�̃C���^�[�o�����󂯂�
awk -f AWKScripts/01_UPDATE/03_SubSystem/03_EditHTML_Deux_SubSystem_03.awk $TROISLIST > $EXEC_SHELL
sh $EXEC_SHELL

: > $EXEC_SHELL

# TROISLIST�̃t�@�C���ɑ΂���n�b�V���l���擾
awk '{print "sha512sum "$0;}' $TROISLIST > $EXEC_SHELL

: > $TROISHASH

sh $EXEC_SHELL | \
awk '{print $2"\t"$1;}' | \
unix2dos > $TROISHASH

: > $EXEC_SHELL

# �������t��HTML����擾�����n�C�p�[�����N�̃��X�g�ɑΉ�����Shift-JIS�ϊ����HTML���i�[����f�B���N�g���𖳏����ɐ���
awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk 'BEGIN{FS = "/";}{print "mkdir -p "$1"/"$2"/"$3" > nul 2>&1";}' > $EXEC_SHELL

sh $EXEC_SHELL

: > $EXEC_SHELL

# nkf32�ŕϊ�
awk -f AWKScripts/01_UPDATE/03_SubSystem/04_EditHTML_Deux_SubSystem_04.awk $TROISLIST > $EXEC_SHELL
xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

# QuatreLIST�̃t�@�C���ɑ΂���n�b�V���l���擾
: > $EXEC_SHELL
awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk '{print "sha512sum "$0;}'  > $EXEC_SHELL

: > $QUATREHASH

sh $EXEC_SHELL | \
awk '{print $2"\t"$1;}' | \
unix2dos > $QUATREHASH

# Cinq�ɃR�s�[
: > $EXEC_SHELL

awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk 'BEGIN{FS = "/";}{Tex = $0; des = "EditedHTML_Cinq/"$4; print "cp -p "$0" "des" > nul 2>&1";}'  > $EXEC_SHELL

awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk 'BEGIN{FS = "/";}{print "EditedHTML_Cinq/"$4;}'  > $TODAY_CINQLIST

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

# �u����E���Ƌ����グ�����v�A�u����E���Ƌ��󎸌��v�Œ��o
fgrep '<span class="text">' EditedHTML_Cinq/*.html | \
fgrep -f $TODAY_CINQLIST | \
fgrep -A 1 -e "����E���Ƌ����グ����" -e "����E���Ƌ��󎸌�" | \
sed -e 's/-/:/g' | \
tr -d '\t' | \
sed -e 's/:/\t/g' | \
awk '{if(NR % 3){ORS="\t"} else {ORS="\n"};print;}' | \
awk 'BEGIN{FS = "\t";}{print $1"\t"$2"\t"$3"\t"$4;}' | \
sed -e 's/"//g' | \
sed -e 's/<span class=text>//g' | \
sed -e 's/<\/span>//g' | \
LinuxTools/gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/10_EditHTML_Deux_SubSystem_10.awk | \
awk 'BEGIN{FS = "\t";}{print $1"\t"$2"\t"$4"\t"$5;}' | \
unix2dos > $TARGETLINK

: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/11_EditHTML_Deux_SubSystem_11.awk $TARGETLINK | \
unix2dos > $EXEC_SHELL
sh $EXEC_SHELL | \
awk '{if(NR % 2 == 1){print;}}' | \
tr -d '\t' | \
sed -e 's/"//g' | \
sed -e 's/<a href=//g' | \
sed -e 's/>//g' | \
unix2dos > $TARGETLINK_Deux

paste -d '\t' $TARGETLINK $TARGETLINK_Deux | \
unix2dos > $TARGETLINK_Trois

## ��Ƃ��āAhttps://kanpou.npb.go.jp/20191211/20191211h00150/20191211h001500031f.html
## �̏ꍇ�A20191211�����s�����ŁAh00150���{��150���A00031f��31�y�[�W�A�Ƃ����Ӗ��B
## PDF�v���O�C���̃\�[�X�́Ahttps://kanpou.npb.go.jp/20191211/20191211h00150/pdf/20191211h001500031.pdf

awk 'BEGIN{FS = "\t";}{Tex = $5; Tex2 = $5; sub("f.html","",Tex); sub("f.html",".pdf",Tex2); print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"Tex"\t"Tex2;}' $TARGETLINK_Trois | \
unix2dos > $TARGETLINK_Quatre

## ���݂��Ȃ��ꍇ�A�܂��͋�t�@�C���̏ꍇ�AAcquiredPDF�Ɍ����ă_�E�����[�h
## TODO : 
#
# poppler-0.68.0_x86/poppler-0.68.0/bin/pdftoppm.exe�̃R�}���h����
: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/07_EditHTML_Deux_SubSystem_07.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

sh $EXEC_SHELL

# C:/Program Files/Tesseract-OCR/tesseract.exe�̃R�}���h����
# �����낵��CPU�ƃ�������H���Ԃ��̂ŁAxargs��P�I�v�V������0�ɂ���ƔߎS�Ȃ��ƂɁE�E�E
: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/08_EditHTML_Deux_SubSystem_08.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

sh $EXEC_SHELL

# �I�[�ɕ����������K����������̂ŁA�ŏI�s�����Ankf32��Shift-JIS�ɕϊ�
: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/09_EditHTML_Deux_SubSystem_09.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

# �u����E���Ƌ���v����$TARGETLINK_Quatre��4�J�����ڂ́u�֌W�v�����O�������̂܂ł𒊏o
: > $EXEC_SHELL
LinuxTools/gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/12_EditHTML_Deux_SubSystem_12.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

