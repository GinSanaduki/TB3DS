#! /usr/bin/gawk
# 07_EditHTML_Deux_SubSystem_07.awk
# gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/07_EditHTML_Deux_SubSystem_07.awk

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
	cmd_base = "poppler-0.68.0_x86/poppler-0.68.0/bin/pdftoppm.exe"
	option = "-png -r 450";
}

{
	HashFile = "PNGHash/"$6".txt";
	# PDF変換後のPNGに対するハッシュ値ファイルの存在を確認
	print "ls "HashFile" > nul 2>&1";
	print "RetCode01=$?";
	# 正常終了の場合、ハッシュ値を検証
	FromFile = "AcquiredPDF/"$7;
	ToFile = "ConvertedPNG/"$6;
	ToFile_02 = "ConvertedPNG/"$6"-1.png";
	ToFile_03 = "ConvertedPNG/"$6".png";
	print "BitField=1";
	print "test $RetCode01 -eq 0 && sha512sum -s -c "HashFile;
	print "RetCode02=$?";
	# RetCode01かRetCode02が0以外の場合、pdftoppm.exeを実行
	cmd01 = "echo Convert START... : From "FromFile" , To "ToFile_03;
	cmd02 = cmd_base" "option" "FromFile" "ToFile" > nul 2>&1";
	cmd03 = "mv "ToFile_02" "ToFile_03" > nul 2>&1";
	cmd04 = "echo Convert Completed. : "ToFile_03;
	cmd05 = "sha512sum "ToFile_03" > "HashFile;
	print "test $RetCode01 -eq 0 -a $RetCode02 -eq 0 && BitField=0";
	print "test $BitField -eq 0 && echo Convert Skipped. : "ToFile_03;
	print "test $BitField -ne 0 && echo Convert START... : From "FromFile" , To "ToFile_03" && "cmd_base" "option" "FromFile" "ToFile" > nul 2>&1";
	print "RetCode03=$?";
	print "test $BitField -ne 0 -a $RetCode03 -ne 0 && echo Convert Failed. : "ToFile_03;
	print "test $BitField -ne 0 -a $RetCode03 -eq 0 && mv "ToFile_02" "ToFile_03" > nul 2>&1 && echo Convert Completed. : "ToFile_03" && sha512sum "ToFile_03" > "HashFile;
}

