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
# test
DATE="20191215"
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

# 当日日付のHTMLから取得したハイパーリンクのリストに対応したUTF-8のHTMLを格納するディレクトリを無条件に生成
awk 'BEGIN{FS = "/";}{print "mkdir -p "$1"/"$2"/"$3" > nul 2>&1";}' $TROISLIST > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

: > $EXEC_SHELL

# 当該UTF-8ファイルが存在しない、または空ファイルである場合、取得し10秒のインターバルを空ける
awk -f AWKScripts/01_UPDATE/03_SubSystem/03_EditHTML_Deux_SubSystem_03.awk $TROISLIST > $EXEC_SHELL
sh $EXEC_SHELL

: > $EXEC_SHELL

# TROISLISTのファイルに対するハッシュ値を取得
awk '{print "sha512sum "$0;}' $TROISLIST > $EXEC_SHELL

: > $TROISHASH

sh $EXEC_SHELL | \
awk '{print $2"\t"$1;}' | \
unix2dos > $TROISHASH

: > $EXEC_SHELL

# 当日日付のHTMLから取得したハイパーリンクのリストに対応したShift-JIS変換後のHTMLを格納するディレクトリを無条件に生成
awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk 'BEGIN{FS = "/";}{print "mkdir -p "$1"/"$2"/"$3" > nul 2>&1";}' > $EXEC_SHELL

sh $EXEC_SHELL

: > $EXEC_SHELL

# nkf32で変換
awk -f AWKScripts/01_UPDATE/03_SubSystem/04_EditHTML_Deux_SubSystem_04.awk $TROISLIST > $EXEC_SHELL
xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

# QuatreLISTのファイルに対するハッシュ値を取得
: > $EXEC_SHELL
awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk '{print "sha512sum "$0;}'  > $EXEC_SHELL

: > $QUATREHASH

sh $EXEC_SHELL | \
awk '{print $2"\t"$1;}' | \
unix2dos > $QUATREHASH

# Cinqにコピー
: > $EXEC_SHELL

awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk 'BEGIN{FS = "/";}{Tex = $0; des = "EditedHTML_Cinq/"$4; print "cp -p "$0" "des" > nul 2>&1";}'  > $EXEC_SHELL

awk '{sub("EditedHTML_Trois/","EditedHTML_Quatre/");print;}' $TROISLIST | \
awk 'BEGIN{FS = "/";}{print "EditedHTML_Cinq/"$4;}'  > $TODAY_CINQLIST

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

# 「教育職員免許状取上げ処分」、「教育職員免許状失効」で抽出
fgrep '<span class="text">' EditedHTML_Cinq/*.html | \
fgrep -f $TODAY_CINQLIST | \
fgrep -A 1 -e "教育職員免許状取上げ処分" -e "教育職員免許状失効" | \
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

## 例として、https://kanpou.npb.go.jp/20191211/20191211h00150/20191211h001500031f.html
## の場合、20191211が発行日時で、h00150が本紙150号、00031fが31ページ、という意味。
## PDFプラグインのソースは、https://kanpou.npb.go.jp/20191211/20191211h00150/pdf/20191211h001500031.pdf

awk 'BEGIN{FS = "\t";}{Tex = $5; Tex2 = $5; sub("f.html","",Tex); sub("f.html",".pdf",Tex2); print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"Tex"\t"Tex2;}' $TARGETLINK_Trois | \
unix2dos > $TARGETLINK_Quatre

## 存在しない場合、または空ファイルの場合、AcquiredPDFに向けてダウンロード
## TODO : 
#
# poppler-0.68.0_x86/poppler-0.68.0/bin/pdftoppm.exeのコマンド生成
: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/07_EditHTML_Deux_SubSystem_07.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

sh $EXEC_SHELL

# C:/Program Files/Tesseract-OCR/tesseract.exeのコマンド生成
# おそろしくCPUとメモリを食いつぶすので、xargsのPオプションを0にすると悲惨なことに・・・
: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/08_EditHTML_Deux_SubSystem_08.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

sh $EXEC_SHELL

# 終端に文字化けが必ず発生するので、最終行を取り、nkf32でShift-JISに変換
: > $EXEC_SHELL
awk -f AWKScripts/01_UPDATE/03_SubSystem/09_EditHTML_Deux_SubSystem_09.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

# 「教育職員免許状」から$TARGETLINK_Quatreの4カラム目の「関係」を除外したものまでを抽出
: > $EXEC_SHELL
LinuxTools/gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/12_EditHTML_Deux_SubSystem_12.awk $TARGETLINK_Quatre | \
unix2dos > $EXEC_SHELL

xargs -P 0 -a $EXEC_SHELL -r -I{} sh -c '{}'

