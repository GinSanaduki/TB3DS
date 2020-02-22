#! /usr/bin/gawk
# 02_EditHTML_Deux_SubSystem_02.awk
# gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/02_EditHTML_Deux_SubSystem_02.awk

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
	tag_dt = "";
	tag_dt_year = "";
}

/^<dt>.*?<\/dt>/{
	gsub("</dt>","");
	gsub("<dt>","");
	gsub(" ","");
	# 令和元年MM月DD日
	tag_dt = $0;
	temp = tag_dt;
	# yyyymmddに変換
	tag_dt_year = convYear();
	next;
}

/^<li><a href=/{
	gsub("<br>","");
	gsub("</a></li>","");
	gsub("<li><a href=\".","https://kanpou.npb.go.jp");
	gsub("\">","\t");
	split($0,Arrays,"\t");
	print tag_dt"\t"tag_dt_year"\t"Arrays[1]"\t"Arrays[2];
	delete Arrays;
}

function convYear(){
	gsub("元","1",temp);
	gsub("年",",",temp);
	gsub("月",",",temp);
	gsub("日","",temp);
	split(temp,ArrayYears,",");
	GenGou = substr(ArrayYears[1],1,2);
	Nen = substr(ArrayYears[1],3);
	switch(GenGou){
		case "令和":
			yyyy = Nen + 2018;
			break;
		case "平成":
			yyyy = Nen + 1988;
			break;
		case "昭和":
			yyyy = Nen + 1875;
			break;
		case "大正":
			yyyy = Nen + 1911;
			break;
		case "明治":
			yyyy = Nen + 1867;
			break;
		default:
			print "Convert Error.";
			exit 99;
	}
	if(length(ArrayYears[2]) == 1){
		ArrayYears[2] = "0"ArrayYears[2];
	}
	if(length(ArrayYears[3]) == 1){
		ArrayYears[3] = "0"ArrayYears[3];
	}
	yyyymmdd = yyyy ArrayYears[2] ArrayYears[3];
	delete ArrayYears;
	return yyyymmdd;
}

