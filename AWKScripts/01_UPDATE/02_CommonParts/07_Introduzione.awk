#! /usr/bin/gawk
# 07_Introduzione.awk

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

function Introduzione(){
	# 本日分のAcquiredXLSX/GetDate_YYYYMMDD_UnderText_From_YYYYMM_To_YYYYMMDD_（xlsx本来の名前）の生成
	Introduzione_OutXLSXName = Introduzione_SubSystem01();
	# 本日分のAcquiredXLSX/GetDate_YYYYMMDD_UnderText_From_YYYYMM_To_YYYYMMDD_（xlsx本来の名前）の存在確認
	print Introduzione_OutXLSXName"が存在するか確認します・・・" > "con";
	close("con");
	cmd = CALL_BUSYBOX" ls \""Introduzione_OutXLSXName"\" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	# 取得していない場合、取得する
	if(ret == 1){
		Introduzione_SubSystem00(Introduzione_SubSystem01_ReplaceLinks,Introduzione_OutXLSXName);
		return Introduzione_OutXLSXName;
	}
	# 現在のハッシュリストを確認する
	print Introduzione_OutXLSXName"は取得済です。" > "con";
	print FNAME_HASH"に"Introduzione_OutXLSXName"の記載があるかを確認します・・・" > "con";
	close("con");
	delete HashTable;
	GetHashTable();
	BitField01 = 0;
	BitField02 = 0;
	BitField03 = 0;
	BitField04 = 0;
	len = length(HashTable);
	if(len == 3){
		Introduzione_SubSystem00(Introduzione_SubSystem01_ReplaceLinks,Introduzione_OutXLSXName);
		return Introduzione_OutXLSXName;
	}
	UTF8Line = "";
	SJISLine = "";
	EDITLine = "";
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == Introduzione_OutXLSXName){
			BitField01 = 1;
		}
		if(HashTableLine[1] == FNAME_EDIT){
			BitField02 = 1;
		}
		if(HashTableLine[1] == FNAME_SJIS){
			SJISLine = HashTableLine[1];
			BitField03 = 1;
		}
		if(HashTableLine[1] == FNAME_UTF8){
			UTF8Line = HashTableLine[1];
			BitField04 = 1;
		}
		if(BitField01 == 1 && BitField02 == 1 && BitField03 == 1 && BitField04 == 1){
			break;
		}
		delete HashTableLine;
	}
	if(BitField01 == 0){
		Introduzione_SubSystem00(Introduzione_SubSystem01_ReplaceLinks,Introduzione_OutXLSXName);
		return Introduzione_OutXLSXName;
	}
	print FNAME_HASH"に"Introduzione_OutXLSXName"の記載を確認しました。" > "con";
	print FNAME_HASH"のハッシュ値が一致するかを確認します。" > "con";
	close("con");
	Introduzione_CompareHash = ReturnHashValue(Introduzione_OutXLSXName);
	
	if(HashTableLine[2] != Introduzione_CompareHash){
		print FNAME_HASH"のハッシュ値が不一致でした。" > "con";
		print Introduzione_OutXLSXName"の再取得を行います。" > "con";
		close("con");
		Introduzione_SubSystem00(Introduzione_SubSystem01_ReplaceLinks,Introduzione_OutXLSXName);
		return Introduzione_OutXLSXName;
	}
	print FNAME_HASH"のハッシュ値が一致しました。" > "con";
	# XLSXについては、2019年現在、Last-Modifiedが2013年となる。
	# 今回は、Last-Modifiedもあてにならないので、ETagとContent-Lengthが一致するかで判別する。
	# 実際に取得してみるのもいいが、それだとチェックする意味がない。
	# HTTP/1.1 200 OK
	# Date: Wed, 13 Nov 2019 15:47:09 GMT
	# Server: Apache
	# Last-Modified: Fri, 06 Dec 2013 02:54:24 GMT
	# ETag: "3ff50902-20c0f-4ecd4c37fd800"
	# Accept-Ranges: bytes
	# Content-Length: 134159
	# Keep-Alive: timeout=15, max=100
	# Connection: Keep-Alive
	# Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
	# Length: 134159 (131K) [application/vnd.openxmlformats-officedocument.spreadsheetml.sheet]
	print FNAME_HASH"のETag値、Content-Length値が一致するかを確認します。" > "con";
	close("con");
	Introduzione_SubSystem05(Introduzione_SubSystem01_ReplaceLinks);
	if(HashTableLine[3] != ETag){
		print FNAME_HASH"のETag値が不一致でした。" > "con";
		print "再取得を行います。" > "con";
		close("con");
		Introduzione_SubSystem00(Introduzione_SubSystem01_ReplaceLinks,Introduzione_OutXLSXName);
		return Introduzione_OutXLSXName;
	}
	if(HashTableLine[4] != ContentLength){
		print FNAME_HASH"のContent-Length値が不一致でした。" > "con";
		print "再取得を行います。" > "con";
		close("con");
		Introduzione_SubSystem00(Introduzione_SubSystem01_ReplaceLinks,Introduzione_OutXLSXName);
		return Introduzione_OutXLSXName;
	}
	print FNAME_HASH"のETag値、Content-Length値が一致しました。" > "con";
	print Introduzione_OutXLSXName"の確認を終了します。" > "con";
	close("con");
	delete HashTableLine;
	return Introduzione_OutXLSXName;
}

# ------------------------------------------------------------------------------------------------------------------------

function Introduzione_SubSystem00(Introduzione_SubSystem00_LINK,Introduzione_SubSystem00_XLSX){
	Introduzione_SubSystem03(Introduzione_SubSystem00_LINK,Introduzione_SubSystem00_XLSX);
	Introduzione_SubSystem00_RetHash = ReturnHashValue(Introduzione_SubSystem00_XLSX);
	# ファイル名、ハッシュ値、ETag値、Contents-Length値
	delete HashTable;
	GetHashTable();
	UTF8Line = "";
	SJISLine = "";
	EDITLine = "";
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_UTF8){
			UTF8Line = HashTable[i];
			delete HashTableLine;
			break;
		}
		delete HashTableLine;
	}
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_SJIS){
			SJISLine = HashTable[i];
			delete HashTableLine;
			break;
		}
		delete HashTableLine;
	}
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_EDIT){
			EDITLine = HashTable[i];
			delete HashTableLine;
			break;
		}
		delete HashTableLine;
	}
	delete HashTable;
	print UTF8Line > FNAME_HASH;
	print SJISLine > FNAME_HASH;
	print EDITLine > FNAME_HASH;
	print Introduzione_OutXLSXName","Introduzione_SubSystem00_RetHash","ETag","ContentLength > FNAME_HASH;
	close(FNAME_HASH);
}

# ------------------------------------------------------------------------------------------------------------------------

function Introduzione_SubSystem01(){
	Introduzione_SubSystem01_ReplaceLinks = Introduzione_SubSystem02();
	split(Introduzione_SubSystem01_ReplaceLinks,Introduzione_SubSystem01_ReplaceLinksLine,",");
	Introduzione_SubSystem01_ReplaceLinks = Introduzione_SubSystem01_ReplaceLinksLine[1];
	Introduzione_SubSystem01_KeyText = Introduzione_SubSystem01_ReplaceLinksLine[2];
	delete Introduzione_SubSystem01_ReplaceLinksLine;
	# 取得ファイル名を作成
	split(Introduzione_SubSystem01_ReplaceLinks,Introduzione_SubSystem01_ReplaceLinksLine,"/");
	OriginXLSX = Introduzione_SubSystem01_ReplaceLinksLine[length(Introduzione_SubSystem01_ReplaceLinksLine)];
	delete Introduzione_SubSystem01_ReplaceLinksLine;
	Introduzione_SubSystem01_KeyText_02 = Introduzione_SubSystem01_KeyText;
	gsub(KEYWORD_01,"",Introduzione_SubSystem01_KeyText_02);
	gsub("（","",Introduzione_SubSystem01_KeyText_02);
	gsub("）","",Introduzione_SubSystem01_KeyText_02);
	gsub("～","_",Introduzione_SubSystem01_KeyText_02);
	Introduzione_SubSystem01_KeyText_03 = RepYears(Introduzione_SubSystem01_KeyText_02);
	FromYYYYMM = substr(Introduzione_SubSystem01_KeyText_03,1,6);
	ToYYYYMM = substr(Introduzione_SubSystem01_KeyText_03,8,6);
	Introduzione_SubSystem01_ReturnName_01 = DIR_ACQUIREDXLSX"/Acquisition_"strftime("%Y%m%d",systime());
	Introduzione_SubSystem01_ReturnName_02 = "_UnderText_From_"FromYYYYMM;
	Introduzione_SubSystem01_ReturnName_03 = "_To_"ToYYYYMM;
	Introduzione_SubSystem01_ReturnName_04 = "_Origin_"OriginXLSX;
	Introduzione_SubSystem01_ReturnName = Introduzione_SubSystem01_ReturnName_01 Introduzione_SubSystem01_ReturnName_02 Introduzione_SubSystem01_ReturnName_03 Introduzione_SubSystem01_ReturnName_04;
	return Introduzione_SubSystem01_ReturnName;
}

# ------------------------------------------------------------------------------------------------------------------------

function Introduzione_SubSystem02(){
	# キーワードの存在する行番号を特定
	cmd1 = CALL_BUSYBOX" cat \""FNAME_EDIT"\" | ";
	cmd2 = CALL_BUSYBOX" fgrep -n -e \""KEYWORD_01"\""
	cmd = cmd1 cmd2;
	LineNum = RetTextExecCmd(cmd);
	split(LineNum,LineNumArrays,":");
	Introduzione_SubSystem02_LineNum = LineNumArrays[1];
	Introduzione_SubSystem02_KeyText = LineNumArrays[2];
	delete LineNumArrays;
	cmd = CALL_BUSYBOX" egrep -n -e \""KEYWORD_02"\" "FNAME_EDIT;
	cnt = 1;
	while(cmd | getline XLSXLink){
		XLSXLinkArrays[cnt] = XLSXLink;
		cnt++;
	}
	close(cmd);
	cnt = 1;
	for(i in XLSXLinkArrays){
		split(XLSXLinkArrays[i],XLSXLinkArraysLine,":");
		val = LineNum - XLSXLinkArraysLine[1];
		# 順序が<href>タグ、表示文字の順のため、減算して1以上にならなければ対象のURLではない。
		if(val > 0){
			# インデックスに減算した値を設定する
			XLSXLinkArrays2[val] = XLSXLinkArraysLine[2];
		}
		delete XLSXLinkArraysLine;
	}
	# インデックスの昇順にソート
	PROCINFO["sorted_in"] = "@ind_str_asc";
	# 1つ目の値が対象となる
	Introduzione_SubSystem02_LinksText = "";
	for(k in XLSXLinkArrays2){
		Introduzione_SubSystem02_LinksText = XLSXLinkArrays2[k];
		break;
	}
	delete XLSXLinkArrays2;
	Introduzione_SubSystem02_LinksText_02 = Introduzione_SubSystem02_LinksText;
	gsub("<a href=",KEYWORD_03,Introduzione_SubSystem02_LinksText_02);
	gsub("\"","",Introduzione_SubSystem02_LinksText_02);
	gsub(">","",Introduzione_SubSystem02_LinksText_02);
	# 「,」区切りで返却する
	return Introduzione_SubSystem02_LinksText_02","Introduzione_SubSystem02_KeyText;
}

# ------------------------------------------------------------------------------------------------------------------------

function Introduzione_SubSystem03(Introduzione_SubSystem03_LINK,Introduzione_SubSystem03_XLSX){
	print "文科省HPに存在する"Introduzione_SubSystem03_LINK"への接続が可能か確認します・・・" > "con";
	close("con");
	ret = EditHTTPResponse_02(Introduzione_SubSystem03_LINK);
	if(ret == 0){
		print "文科省HPに存在する"Introduzione_SubSystem03_LINK"への接続は問題ありませんでした。" > "con";
		close("con");
	} else {
		print "文科省HPに存在する"Introduzione_SubSystem03_LINK"への接続に失敗しました。" > "con";
		print "システムを終了します。" > "con";
		close("con");
		exit 99;
	}
	print "クローラを起動させたため、5秒インターバルを発生させます。" > "con";
	close("con");
	SLEEP();
	print "文科省HPから"Introduzione_SubSystem03_LINK"のダウンロードを開始します・・・。" > "con";
	print "ダウンロード時のファイル名は"Introduzione_SubSystem03_XLSX"となります。" > "con";
	close("con");
	GetContents(Introduzione_SubSystem03_LINK,Introduzione_SubSystem03_XLSX);
	print "文科省HPからの"Introduzione_SubSystem03_LINK"のダウンロードが完了しました。" > "con";
	close("con");
}

# ------------------------------------------------------------------------------------------------------------------------

function Introduzione_SubSystem05(Introduzione_SubSystem05_LINK){
	print "文科省HPに存在する"Introduzione_SubSystem05_LINK"への接続が可能か確認します・・・" > "con";
	close("con");
	ret = EditHTTPResponse_02(Introduzione_SubSystem05_LINK);
	if(ret == 0){
		print "文科省HPに存在する"Introduzione_SubSystem05_LINK"への接続は問題ありませんでした。" > "con";
		close("con");
	} else {
		print "文科省HPに存在する"Introduzione_SubSystem05_LINK"への接続に失敗しました。" > "con";
		print "システムを終了します。" > "con";
		close("con");
		exit 99;
	}
}

# ------------------------------------------------------------------------------------------------------------------------

