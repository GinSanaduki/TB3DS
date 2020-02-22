#! /usr/bin/gawk
# 06_AdagioSostenuto.awk

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

function AdagioSostenuto(){
	# 本日分のEditedHTML/未返納教員免許状一覧_文部科学省_YYYYMMDD.txtの存在確認
	# 前日以前のものに対するHTMLの確認は、行っても意味がない。
	# そのため、最後にXLSXとCSVのハッシュ照合を取り、XLSXがハッシュ表と食い違う場合はその日付の生成物6種（ハッシュ表、HTML3種、XLSX、CSV）を削除する。
	# XLSXがハッシュ表と一致しCSVが不一致となった場合は、CSVを作成し直す。
	# 各日付における重複確認は、後々にまとめてハッシュ表をソートし日付で降順ソートして、重複対象を出力し、対象を削除していく。
	print FNAME_EDIT"が存在するか確認します・・・" > "con";
	close("con");
	cmd = CALL_BUSYBOX" ls \""FNAME_EDIT"\" > "OUT_DEVNULL;
	ret = RetExecCmd(cmd);
	# 編集処理により存在していない場合、編集処理を行う
	if(ret == 1){
		AdagioSostenuto_Sub00();
		return 0;
	}
	# 現在のハッシュリストを確認する
	print FNAME_EDIT"は編集済です。" > "con";
	print FNAME_HASH"に"FNAME_EDIT"の記載があるかを確認します・・・" > "con";
	close("con");
	delete HashTable;
	GetHashTable();
	BitField01 = 0;
	BitField02 = 0;
	BitField03 = 0;
	len = length(HashTable);
	if(len == 2){
		AdagioSostenuto_Sub00();
		return 0;
	}
	UTF8Line = "";
	SJISLine = "";
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == FNAME_EDIT){
			BitField01 = 1;
		}
		if(HashTableLine[1] == FNAME_SJIS){
			SJISLine = HashTableLine[1];
			BitField02 = 1;
		}
		if(HashTableLine[1] == FNAME_UTF8){
			UTF8Line = HashTableLine[1];
			BitField03 = 1;
		}
		if(BitField01 == 1 && BitField02 == 1 && BitField03 == 1){
			break;
		}
		delete HashTableLine;
	}
	if(BitField01 == 0){
		AdagioSostenuto_Sub00();
		return 0;
	}
	print FNAME_HASH"に"FNAME_EDIT"の記載を確認しました。" > "con";
	print FNAME_HASH"のハッシュ値が一致するかを確認します。" > "con";
	close("con");
	AdagioSostenuto_CompareHash = ReturnHashValue(FNAME_EDIT);
	
	if(HashTableLine[2] != AdagioSostenuto_CompareHash){
		print FNAME_HASH"のハッシュ値が不一致でした。" > "con";
		print "文字コードの再変換を行います。" > "con";
		close("con");
		AdagioSostenuto_Sub00();
		return 0;
	}
	print FNAME_HASH"のハッシュ値が一致しました。" > "con";
	print FNAME_EDIT"の確認を終了します。" > "con";
	close("con");
	delete HashTableLine;
}

# ------------------------------------------------------------------------------------------------------------------------

function AdagioSostenuto_Sub01(){
	print FNAME_SJIS"から"FNAME_EDIT"への編集処理を行います・・・" > "con";
	close("con");
	# AcquiredHTML_ShiftJIS/未返納教員免許状一覧_文部科学省.txtを吸い上げる。
	cmd = CALL_BUSYBOX" cat "FNAME_SJIS;
	cnt = 1;
	while(cmd | getline esc){
		SJISArrays[cnt] = esc;
		cnt++;
	}
	close(cmd);
	# SJISArraysの各配列内容からタブ文字を削除する。
	for(i in SJISArrays){
		gsub("\t","",SJISArrays[i]);
	}
	
	# SJISArraysの各配列内容から空行を削除する。
	for(i in SJISArrays){
		if(SJISArrays[i] != ""){
			print SJISArrays[i] > FNAME_EDIT;
		}
	}
	delete SJISArrays;
	
	# ハッシュ値取得のため、ファイルI/Oストリームを閉じる。
	close(FNAME_EDIT);
	print FNAME_SJIS"から"FNAME_EDIT"への編集処理が完了しました。" > "con";
	close("con");
}

# ------------------------------------------------------------------------------------------------------------------------

function AdagioSostenuto_Sub00(){
	AdagioSostenuto_Sub01();
	AdagioSostenuto_Sub00_RetHash = ReturnHashValue(FNAME_EDIT);
	# ファイル名、ハッシュ値
	delete HashTable;
	GetHashTable();
	UTF8Line = "";
	SJISLine = "";
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
	delete HashTable;
	print UTF8Line > FNAME_HASH;
	print SJISLine > FNAME_HASH;
	print FNAME_EDIT","AdagioSostenuto_Sub00_RetHash > FNAME_HASH;
	close(FNAME_HASH);
}

# ------------------------------------------------------------------------------------------------------------------------

