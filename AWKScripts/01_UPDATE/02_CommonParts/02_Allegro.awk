#! /usr/bin/gawk
# 02_Allegro.awk

# ------------------------------------------------------------------------------------------------------------------------

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

function Allegro(){
	# 本日分のAcquiredHTML_UTF8/List_of_disciplinary_dismissal_disposal_YYYYMMDD.txtの存在確認
	print FNAME_UTF8"が存在するか確認します・・・" > "con";
	close("con");
	cmd = CALL_BUSYBOX" ls \""FNAME_UTF8"\" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	# 取得していない場合、取得する
	if(ret == 1){
		Allegro_Sub00();
		return 0;
	}
	# 現在のハッシュリストを確認する
	print FNAME_UTF8"は取得済です。" > "con";
	print FNAME_HASH"に"FNAME_UTF8"の記載があるかを確認します・・・" > "con";
	close("con");
	GetHashTable();
	BitField = 0;
	len = length(HashTable);
	if(len == 0){
		Allegro_Sub00();
		return 0;
	}
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_UTF8){
			BitField = 1;
			break;
		}
		delete HashTableLine;
	}
	if(BitField == 0){
		Allegro_Sub00();
		return 0;
	}
	print FNAME_HASH"に"FNAME_UTF8"の記載を確認しました。" > "con";
	print FNAME_HASH"のETag値、Last-Modified値が一致するかを確認します。" > "con";
	close("con");
	Allegro_Sub03();
	if(HashTableLine[3] != ETag){
		print FNAME_HASH"のETag値が不一致でした。" > "con";
		print "再取得を行います。" > "con";
		close("con");
		Allegro_Sub00();
		return 0;
	}
	if(HashTableLine[4] != YYYYMMDDHHmmSS){
		print FNAME_HASH"のLast-Modified値が不一致でした。" > "con";
		print "再取得を行います。" > "con";
		close("con");
		Allegro_Sub00();
		return 0;
	}
	print FNAME_HASH"のETag値、Last-Modified値が一致しました。" > "con";
	print FNAME_UTF8"の確認を終了します。" > "con";
	close("con");
	delete HashTableLine;
}

# ------------------------------------------------------------------------------------------------------------------------

function Allegro_Sub01(){
	print "国立印刷局HPへの接続が可能か確認します・・・" > "con";
	close("con");
	ret = EditHTTPResponse();
	if(ret == 0){
		print "国立印刷局HPへの接続は問題ありませんでした。" > "con";
		close("con");
	} else {
		print "国立印刷局HPへの接続に失敗しました。" > "con";
		print "システムを終了します。" > "con";
		close("con");
		exit 99;
	}
	print "クローラを起動させたため、5秒インターバルを発生させます。" > "con";
	close("con");
	SLEEP();
	print "国立印刷局HPからHTMLのダウンロードを開始します・・・。" > "con";
	close("con");
	GetContents(MEXT_URL,FNAME_UTF8);
	print "国立印刷局HPからのHTMLのダウンロードが完了しました。" > "con";
	close("con");
}

# ------------------------------------------------------------------------------------------------------------------------

function Allegro_Sub00(){
	Allegro_Sub01();
	Allegro_Sub00_RetHash = ReturnHashValue(FNAME_UTF8);
	# ファイル名、ハッシュ値、ETag値、Last-ModifiedのYYYYMMDDHHmmSS表記
	# 本日分のリセットも兼ねている
	print FNAME_UTF8","Allegro_Sub00_RetHash","ETag","YYYYMMDDHHmmSS > FNAME_HASH;
	close(FNAME_HASH);
}

# ------------------------------------------------------------------------------------------------------------------------

function Allegro_Sub03(){
	print "国立印刷局HPへの接続が可能か確認します・・・" > "con";
	close("con");
	ret = EditHTTPResponse();
	if(ret == 0){
		print "国立印刷局HPへの接続は問題ありませんでした。" > "con";
		close("con");
	} else {
		print "国立印刷局HPへの接続に失敗しました。" > "con";
		print "システムを終了します。" > "con";
		close("con");
		exit 99;
	}
}

# ------------------------------------------------------------------------------------------------------------------------

