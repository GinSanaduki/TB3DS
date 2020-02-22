#! /usr/bin/gawk
# 08_Largo.awk

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

function Largo(Largo_XLSX){
	# CSVに関しては、無条件で変換する（XLSX内のファイル内から引きこまなければわからないからだ）
	# 拡張子を除外
	len_Largo_XLSX_minus5 = length(Largo_XLSX) - 5;
	Largo_DirName = substr(Largo_XLSX,1,len_Largo_XLSX_minus5);
	Largo_FileName = Largo_XLSX;
	MD(Largo_DirName);
	Unzip(Largo_FileName,Largo_DirName);
	UMLCleaner(Largo_DirName);
	nkfSJIS(Largo_DirName);
	InsCRLF(Largo_DirName);
	ExplorerSheetName(Largo_DirName);
	# ExtractSharedStringsとExtractsheet_ZEN_TODOUFUKENを並列実行
	# Largo_CMD01 = ExtractSharedStrings(Largo_DirName);
	# Largo_CMD02 = Extractsheet_ZEN_TODOUFUKEN(Largo_DirName);
	# Largo_Sub01(Largo_CMD01,Largo_CMD02);
	ExtractSharedStrings(Largo_DirName);
	Extractsheet_ZEN_TODOUFUKEN(Largo_DirName);
	OuterJoin(Largo_DirName);
	UMLCleaner02(Largo_DirName);
}

# ------------------------------------------------------------------------------------------------------------------------

# むしろshellのI/Oで遅くなったので、やめる
function Largo_Sub01(Largo_Sub01_CMD01,Largo_Sub01_CMD02){
	print "#! /bin/sh" > GENE_EXECSHELL;
	# ashで実行するため、「\」を「/」に置換
	gsub("\\\\","/",Largo_Sub01_CMD01);
	gsub("\\\\","/",Largo_Sub01_CMD02);
	print Largo_Sub01_CMD01" & " > GENE_EXECSHELL;
	print Largo_Sub01_CMD02" & " > GENE_EXECSHELL;
	print "wait" > GENE_EXECSHELL;
	print "exit" > GENE_EXECSHELL;
	print "" > GENE_EXECSHELL;
	close(GENE_EXECSHELL);
	# 並列処理のため
	ExecCmd(EXEC_SHELL);
	ExecCmd(RM_SHELL);
}

# ------------------------------------------------------------------------------------------------------------------------

