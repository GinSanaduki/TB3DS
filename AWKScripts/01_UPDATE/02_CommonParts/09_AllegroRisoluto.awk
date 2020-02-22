#! /usr/bin/gawk
# 09_AllegroRisoluto.awk

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

function AllegroRisoluto(AllegroRisoluto_XLSX){
	AllegroRisoluto_XLSX_DIR = gensub(/.xlsx$/,"","g",AllegroRisoluto_XLSX);
	AllegroRisoluto_DefineCSVTitle = GenerateDefineCSVTitle(AllegroRisoluto_XLSX_DIR);
	AllegroRisoluto_Sub01();
	AllegroRisoluto_Sub02();
	AllegroRisoluto_DefineCSV_RetHash = ReturnHashValue(AllegroRisoluto_DefineCSVTitle);
	AllegroRisoluto_DefineXLSX_RetHash = ReturnHashValue(AllegroRisoluto_XLSX);
	# CSVファイル名、ハッシュ値、生成元のXLSX名、XLSXのハッシュ値
	AllegroRisoluto_InsertText = AllegroRisoluto_DefineCSVTitle","AllegroRisoluto_DefineCSV_RetHash","AllegroRisoluto_XLSX","AllegroRisoluto_DefineXLSX_RetHash;
	AllegroRisoluto_Sub03(AllegroRisoluto_XLSX);
	RMTMP();
}

# ------------------------------------------------------------------------------------------------------------------------

function AllegroRisoluto_Sub01(){
	AllegroRisoluto_Line_RewardGiver = SearchLine(AllegroRisoluto_XLSX_DIR,KEYWORD_08);
	AllegroRisoluto_Line_LicenseNumber = SearchLine(AllegroRisoluto_XLSX_DIR,KEYWORD_09);
	AllegroRisoluto_Line_Curriculum = SearchLine(AllegroRisoluto_XLSX_DIR,KEYWORD_10);
	split(AllegroRisoluto_Line_RewardGiver,AllegroRisoluto_Line_RewardGiverArrays,",");
	split(AllegroRisoluto_Line_LicenseNumber,AllegroRisoluto_Line_LicenseNumberArrays,",");
	split(AllegroRisoluto_Line_Curriculum,AllegroRisoluto_Line_CurriculumArrays,",");
	AllegroRisoluto_ColAlphabet_RewardGiver = AllegroRisoluto_Line_RewardGiverArrays[2];
	AllegroRisoluto_ColAlphabet_LicenseNumber = AllegroRisoluto_Line_LicenseNumberArrays[2];
	AllegroRisoluto_ColAlphabet_Curriculum = AllegroRisoluto_Line_CurriculumArrays[2];
	AllegroRisoluto_RowNumber_RewardGiver = AllegroRisoluto_Line_RewardGiverArrays[3];
	AllegroRisoluto_RowNumber_LicenseNumber = AllegroRisoluto_Line_LicenseNumberArrays[3];
	AllegroRisoluto_RowNumber_Curriculum = AllegroRisoluto_Line_CurriculumArrays[3];
	delete AllegroRisoluto_Line_RewardGiverArrays;
	delete AllegroRisoluto_Line_LicenseNumberArrays;
	delete AllegroRisoluto_Line_CurriculumArrays;
}

function AllegroRisoluto_Sub02(){
	DelugeMyth(AllegroRisoluto_XLSX_DIR,AllegroRisoluto_ColAlphabet_RewardGiver,AllegroRisoluto_ColAlphabet_LicenseNumber,AllegroRisoluto_ColAlphabet_Curriculum,AllegroRisoluto_RowNumber_RewardGiver,AllegroRisoluto_RowNumber_LicenseNumber,AllegroRisoluto_RowNumber_Curriculum);
	GenerateDefineCSV(AllegroRisoluto_XLSX_DIR,AllegroRisoluto_DefineCSVTitle,AllegroRisoluto_ColAlphabet_RewardGiver,AllegroRisoluto_ColAlphabet_LicenseNumber,AllegroRisoluto_ColAlphabet_Curriculum);
}

function AllegroRisoluto_Sub03(AllegroRisoluto_Sub03_XLSX){
	delete HashTable;
	GetHashTable();
	UTF8Line = "";
	SJISLine = "";
	EDITLine = "";
	XLSXLine = "";
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
	for(i in HashTable){
		split(HashTable[i],HashTableLine,",");
		if(HashTableLine[1] == AllegroRisoluto_Sub03_XLSX){
			XLSXLine = HashTable[i];
			delete HashTableLine;
			break;
		}
		delete HashTableLine;
	}
	delete HashTable;
	print UTF8Line > FNAME_HASH;
	print SJISLine > FNAME_HASH;
	print EDITLine > FNAME_HASH;
	print XLSXLine > FNAME_HASH;
	print AllegroRisoluto_InsertText > FNAME_HASH;
	close(FNAME_HASH);
}

