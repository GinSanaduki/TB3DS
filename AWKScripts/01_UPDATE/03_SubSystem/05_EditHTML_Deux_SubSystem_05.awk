#! /usr/bin/gawk
# 05_EditHTML_Deux_SubSystem_05.awk
# gawk.exe -f AWKScripts/01_UPDATE/03_SubSystem/05_EditHTML_Deux_SubSystem_05.awk

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
}

{
	Tex = "https://kanpou.npb.go.jp/";
	Tex2 = $1;
	gsub("EditedHTML_Cinq/","",Tex2);
	Tex = Tex substr(Tex2,1,8)"/"substr(Tex2,1,14)"/pdf/"Tex2;
	sub("f.html",".pdf",Tex);
	print $1"\t"$2"\t"$3"\t"$4"\t"Tex;
}

