#! /usr/bin/gawk
# 05_AssaiVivace.awk

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

function AssaiVivace(){
	# 本日分のAcquiredHTML_SJIS/未返納教員免許状一覧_文部科学省_YYYYMMDD.txtの存在確認
	# 前日以前のものに対するHTMLの確認は、行っても意味がない。
	# そのため、最後にXLSXとCSVのハッシュ照合を取り、XLSXがハッシュ表と食い違う場合はその日付の生成物6種（ハッシュ表、HTML3種、XLSX、CSV）を削除する。
	# XLSXがハッシュ表と一致しCSVが不一致となった場合は、CSVを作成し直す。
	# 各日付における重複確認は、後々にまとめてハッシュ表をソートし日付で降順ソートして、重複対象を出力し、対象を削除していく。
	print FNAME_SJIS"が存在するか確認します・・・" > "con";
	close("con");
	cmd = CALL_BUSYBOX" ls \""FNAME_SJIS"\" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	# 文字コード変換により存在していない場合、文字コード変換を行う
	if(ret == 1){
		AssaiVivace_Sub00();
		return 0;
	}
	# 現在のハッシュリストを確認する
	print FNAME_SJIS"は文字コード変換済です。" > "con";
	print FNAME_HASH"に"FNAME_SJIS"の記載があるかを確認します・・・" > "con";
	close("con");
	delete HashTable;
	GetHashTable();
	BitField01 = 0;
	BitField02 = 0;
	len = length(HashTable);
	if(len == 1){
		AssaiVivace_Sub00();
		return 0;
	}
	UTF8Line = "";
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_SJIS){
			BitField01 = 1;
		}
		if(HashTableLine[1] == FNAME_UTF8){
			UTF8Line = HashTableLine[1];
			BitField02 = 1;
		}
		if(BitField01 == 1 && BitField02 == 1){
			break;
		}
		delete HashTableLine;
	}
	if(BitField01 == 0){
		AssaiVivace_Sub00();
		return 0;
	}
	print FNAME_HASH"に"FNAME_SJIS"の記載を確認しました。" > "con";
	print FNAME_HASH"のハッシュ値が一致するかを確認します。" > "con";
	close("con");
	AssaiVivace_CompareHash = ReturnHashValue(FNAME_SJIS);
	
	if(HashTableLine[2] != AssaiVivace_CompareHash){
		print FNAME_HASH"のハッシュ値が不一致でした。" > "con";
		print "文字コードの再変換を行います。" > "con";
		close("con");
		AssaiVivace_Sub00();
		return 0;
	}
	print FNAME_HASH"のハッシュ値が一致しました。" > "con";
	print FNAME_SJIS"の確認を終了します。" > "con";
	close("con");
	delete HashTableLine;
}

# ------------------------------------------------------------------------------------------------------------------------

function AssaiVivace_Sub01(){
	print FNAME_UTF8"から"FNAME_SJIS"への文字コード変換を行います・・・" > "con";
	close("con");
	# HTMLで波ダッシュが出現するが、これが後々ややこしいことになる。
	# iconvやnkfで変換した際の文字コードが「U+301C」になるが、
	# Windowsでは「U+FF5E」となるため、「U+301C」を持ち込むと、
	# テキストエディタなどで文字化けと認識されてしまう。
	# そのため、変換を文字コード変換後にかけている。
	# https://xhtml.exblog.jp/11578228/
	# 波ダッシュ問題 : タイトルはいつも後付け
	cmd1 = CALL_NKF32" -s \""FNAME_UTF8"\" | ";
	cmd2 = CALL_BUSYBOX" sed \"s/\\xe3\\x80\\x9c/\\xef\\xbd\\x9e/g\" | ";
	cmd3 = CALL_NKF32" -Lw > \""FNAME_SJIS"\"";
	cmd = cmd1 cmd2 cmd3;
	ExecCmd(cmd);
	print FNAME_UTF8"から"FNAME_SJIS"への文字コード変換が完了しました。" > "con";
	close("con");
}

# ------------------------------------------------------------------------------------------------------------------------

function AssaiVivace_Sub00(){
	AssaiVivace_Sub01();
	AssaiVivace_Sub00_RetHash = ReturnHashValue(FNAME_SJIS);
	# ファイル名、ハッシュ値
	delete HashTable;
	GetHashTable();
	UTF8Line = "";
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_UTF8){
			UTF8Line = HashTable[i];
			delete HashTableLine;
			break;
		}
		delete HashTableLine;
	}
	delete HashTable;
	print UTF8Line > FNAME_HASH;
	print FNAME_SJIS","AssaiVivace_Sub00_RetHash > FNAME_HASH;
	close(FNAME_HASH);
}

# ------------------------------------------------------------------------------------------------------------------------

