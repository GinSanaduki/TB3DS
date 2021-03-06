#! /usr/bin/gawk
# 08_EditHTML_Deux_SubSystem_08.awk
# gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/08_EditHTML_Deux_SubSystem_08.awk

# ------------------------------------------------------------------------------------------------------------------------

# Copyright 2019 The LOTLTHNBR Project Authors, GinSanaduki.
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
# TB3DS Scripts provides a function to obtain a list of teachers became a disciplinary dismissal disposal
# and to inquire by license number.
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

BEGIN{
	FS = "\t";
	cmd_base = "\"C:/Program Files/Tesseract-OCR/tesseract.exe\"";
	option = "-l jpn --psm 3 --dpi 450";
}

{
	HashFile = "TXTHash/"$6".txt";
	# PNG変換後のTXTに対するハッシュ値ファイルの存在を確認
	print "ls "HashFile" > nul 2>&1";
	print "RetCode01=$?";
	# 正常終了の場合、ハッシュ値を検証
	FromFile = "ConvertedPNG/"$6".png";
	ToFile = "ConvertedTXT/"$6;
	ToFile_02 = "ConvertedTXT/"$6".txt";
	print "BitField=1";
	print "test $RetCode01 -eq 0 && sha512sum -s -c "HashFile;
	print "RetCode02=$?";
	# RetCode01かRetCode02が0以外の場合、tesseract.exeを実行
	cmd01 = "echo Convert START... : From "FromFile" , To "ToFile_02;
	cmd02 = cmd_base" "FromFile" "ToFile" "option" > nul 2>&1";
	cmd03 = "echo Convert Completed. : "ToFile_02;
	cmd04 = "sha512sum "ToFile_02" > "HashFile;
	print "test $RetCode01 -ne 0 -o $RetCode02 -ne 0 && "cmd01" && "cmd02" && BitField=2";
	print "RetCode03=$?";
	print "test $RetCode01 -eq 0 -a $RetCode02 -eq 0 && BitField=0";
	print "RetCode04=$?";
	print "test $RetCode04 -ne 0 -a $BitField -eq 1 && echo Convert Failed. : "ToFile_02;
	print "test $BitField -eq 0 && echo Convert Skipped. : "ToFile_02;
	print "test $RetCode03 -eq 0 -a $BitField -eq 2 && "cmd03" && "cmd04;
}

