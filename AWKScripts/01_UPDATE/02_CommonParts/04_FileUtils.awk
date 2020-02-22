#! /usr/bin/gawk
# 04_FileUtils.awk

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

function GetHashValue(GetHashValue_FileName){
	cmd = CALL_BUSYBOX" sha512sum \""GetHashValue_FileName"\"";
	GetHashValue_hash = RetTextExecCmd(cmd);
	return substr(GetHashValue_hash,1,64);
}

# ------------------------------------------------------------------------------------------------------------------------

function GetHashTable(){
	cmd = CALL_BUSYBOX" cat \""FNAME_HASH"\"";
	cnt = 1;
	while(cmd | getline esc){
		HashTable[cnt] = esc;
		cnt++;
	}
	close(cmd);
}

# ------------------------------------------------------------------------------------------------------------------------

function Unzip(UZ_FNAME,UZ_DIRNAME){
	UnzipCMD = CALL_BUSYBOX" unzip -q \""UZ_FNAME"\" -d \""UZ_DIRNAME"\"";
	ExecCmd(UnzipCMD);
}

# ------------------------------------------------------------------------------------------------------------------------

function UMLCleaner(TargetDir){
	deltarget = TargetDir"/_rels";
	RM(deltarget);
	deltarget = TargetDir"/docProps";
	RM(deltarget);
	deltarget = TargetDir"/xl/_rels";
	RM(deltarget);
	deltarget = TargetDir"/xl/printerSettings";
	RM(deltarget);
	deltarget = TargetDir"/xl/theme";
	RM(deltarget);
	deltarget = TargetDir"/xl/calcChain.xml";
	RM(deltarget);
	deltarget = TargetDir"/xl/styles.xml";
	RM(deltarget);
	deltarget = TargetDir"/xl/worksheets/_rels";
	RM(deltarget);
	deltarget = TargetDir"/[Content_Types].xml";
	RM(deltarget);
	UMLCleaner_CMD1 = CALL_BUSYBOX" find "TargetDir" -type f | ";
	UMLCleaner_CMD2 = CALL_BUSYBOX" xargs -I% mv % "TargetDir;
	UMLCleaner_CMD = UMLCleaner_CMD1 UMLCleaner_CMD2;
	ExecCmd(UMLCleaner_CMD);
	deltarget = TargetDir"/xl";
	RM(deltarget);
}

# ------------------------------------------------------------------------------------------------------------------------

function nkfSJIS(NKF_DIRNAME){
	nkfSJISCMD_01 = CALL_BUSYBOX_GLOB" ls -1 \""NKF_DIRNAME"\" | ";
	nkfSJISCMD_02 = CALL_BUSYBOX" fgrep -e \".xml\"";
	nkfSJISCMD = nkfSJISCMD_01 nkfSJISCMD_02;
	esc = "";
	while(nkfSJISCMD | getline esc){
		esc2 = "ConvertedSJIS_"esc;
		nkfSJISCMD2 = CALL_NKF32" -s -Lw \""NKF_DIRNAME"/"esc"\" > \""NKF_DIRNAME"/"esc2"\"";
		ExecCmd(nkfSJISCMD2);
	}
	close(nkfSJISCMD);
	esc = "";
}

# ------------------------------------------------------------------------------------------------------------------------

function InsCRLF(InsCRLF_DIRNAME){
	InsCRLFCMD_01 = CALL_BUSYBOX_GLOB" ls -1 \""InsCRLF_DIRNAME"\" | ";
	InsCRLFCMD_02 = CALL_BUSYBOX" fgrep -e \".xml\" | "
	InsCRLFCMD_03 = CALL_BUSYBOX" fgrep -e \"ConvertedSJIS_\"";
	InsCRLFCMD = InsCRLFCMD_01 InsCRLFCMD_02 InsCRLFCMD_03;
	print "#! /bin/sh" > GENE_EXECSHELL;
	esc = "";
	while(InsCRLFCMD | getline esc){
		esc2 = esc;
		gsub("ConvertedSJIS_","InsertedCRLF_",esc2);
		# Bourne Shellで実行するためと、カンマ区切りのセルという迷惑な代物が存在したため
		InsCRLFCMD2_01 = "cat \""InsCRLF_DIRNAME"/"esc"\" | ";
		InsCRLFCMD2_02 = "sed -e 's/></>\\\n</g' | ";
		InsCRLFCMD2_03 = "sed -e 's/,/、/g' > \""InsCRLF_DIRNAME"/"esc2"\" & ";
		InsCRLFCMD2 = InsCRLFCMD2_01 InsCRLFCMD2_02 InsCRLFCMD2_03;
		print InsCRLFCMD2 > GENE_EXECSHELL;
	}
	close(cmd);
	esc = "";
	print "wait" > GENE_EXECSHELL;
	print "exit" > GENE_EXECSHELL;
	print "" > GENE_EXECSHELL;
	close(GENE_EXECSHELL);
	# 並列処理のため
	ExecCmd(EXEC_SHELL);
	ExecCmd(RM_SHELL);
}

# ------------------------------------------------------------------------------------------------------------------------

function ExplorerSheetName(ExplorerSheetName_DIRNAME){
	# 不要ファイルの削除
	# 1. <sheet name=でgrep
	# 2. 連番を振る
	# EXCELは、<sheets>タグの中で、ゼロオリジンで見て、何番目にある、という見方をする
	# 3. 全都道府県の行を除外
	# 4. カンマ区切りの3カラム目を切り出す
	# 5. 出力されたファイルを削除
	ExplorerSheetNameCMD01 = CALL_BUSYBOX" fgrep -e \"<sheet name=\" "ExplorerSheetName_DIRNAME"/InsertedCRLF_workbook.xml | ";
	ExplorerSheetNameCMD02 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/01_ExplorerSheetName_SubSystem_01.awk -v Dir="ExplorerSheetName_DIRNAME" | ";
	ExplorerSheetNameCMD03 = CALL_BUSYBOX" fgrep -v -e \""KEYWORD_04"\" | ";
	ExplorerSheetNameCMD04 = CALL_BUSYBOX" cut -f 3 -d \",\" | ";
	ExplorerSheetNameCMD05 = CALL_BUSYBOX" xargs -P 4 -I{} rm \"{}\" > "OUT_DEVNULL;
	ExplorerSheetNameCMD = ExplorerSheetNameCMD01 ExplorerSheetNameCMD02 ExplorerSheetNameCMD03 ExplorerSheetNameCMD04 ExplorerSheetNameCMD05;
	ExecCmd(ExplorerSheetNameCMD);
	# workbook.xml系列の削除
	ExplorerSheetNameCMD_02_01 = CALL_BUSYBOX" find "ExplorerSheetName_DIRNAME" -type f | ";
	ExplorerSheetNameCMD_02_02 = CALL_BUSYBOX" fgrep -e \"workbook.xml\" | ";
	ExplorerSheetNameCMD_02_03 = CALL_BUSYBOX" xargs -P 4 -I{} rm \"{}\" > "OUT_DEVNULL;
	ExplorerSheetNameCMD_02 = ExplorerSheetNameCMD_02_01 ExplorerSheetNameCMD_02_02 ExplorerSheetNameCMD_02_03;
	ExecCmd(ExplorerSheetNameCMD_02);
	# 残存ファイル名の修正
	ExplorerSheetNameCMD_03_01 = CALL_BUSYBOX" find "ExplorerSheetName_DIRNAME" -type f | ";
	ExplorerSheetNameCMD_03_02 = CALL_BUSYBOX" fgrep -e \"sheet\"";
	ExplorerSheetNameCMD_03 = ExplorerSheetNameCMD_03_01 ExplorerSheetNameCMD_03_02;
	esc = "";
	while(ExplorerSheetNameCMD_03 | getline esc){
		esc2 = gensub(/sheet[0-9]+?.xml/,"sheet_ZEN_TODOUFUKEN.xml","g",esc);
		ExplorerSheetNameCMD_04 = CALL_BUSYBOX" mv \""esc"\" \""esc2"\"";
		ExecCmd(ExplorerSheetNameCMD_04);
	}
	close(ExplorerSheetNameCMD_03);
	esc = "";
}

# ------------------------------------------------------------------------------------------------------------------------

function ExtractSharedStrings(ExtractSharedStrings_DIRNAME){
	ExtractSharedStrings_InputFileName = ExtractSharedStrings_DIRNAME"/InsertedCRLF_sharedStrings.xml";
	ExtractSharedStrings_OutputFileName = ExtractSharedStrings_DIRNAME"/Extracted_sharedStrings.csv";
	ExtractSharedStringsCMD01 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/02_ExtractSharedStrings_SubSystem_01.awk "ExtractSharedStrings_InputFileName" | ";
	ExtractSharedStringsCMD02 = CALL_BUSYBOX" fgrep -v -e \"<phoneticPr fontId=\" -e \"<rPh sb=\" -e \"</rPh>\" -e \"</si>\" -e \"<si>\" | ";
	ExtractSharedStringsCMD03 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/03_ExtractSharedStrings_SubSystem_02.awk | ";
	ExtractSharedStringsCMD04 = CALL_BUSYBOX" fgrep -v -e \""KEYWORD_05"\" | ";
	ExtractSharedStringsCMD05 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/04_ExtractSharedStrings_SubSystem_03.awk | ";
	ExtractSharedStringsCMD06 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/05_ExtractSharedStrings_SubSystem_04.awk";
	ExtractSharedStringsCMD = ExtractSharedStringsCMD01 ExtractSharedStringsCMD02 ExtractSharedStringsCMD03 ExtractSharedStringsCMD04 ExtractSharedStringsCMD05 ExtractSharedStringsCMD06" > \""ExtractSharedStrings_OutputFileName"\"";
	ExecCmd(ExtractSharedStringsCMD);
	# return ExtractSharedStringsCMD;
}

# ------------------------------------------------------------------------------------------------------------------------

function Extractsheet_ZEN_TODOUFUKEN(Extractsheet_ZEN_TODOUFUKEN_DIRNAME){
	Extractsheet_ZEN_TODOUFUKEN_InputFileName = Extractsheet_ZEN_TODOUFUKEN_DIRNAME"/InsertedCRLF_sheet_ZEN_TODOUFUKEN.xml";
	Extractsheet_ZEN_TODOUFUKEN_OutputFileName = Extractsheet_ZEN_TODOUFUKEN_DIRNAME"/Extracted_sheet_ZEN_TODOUFUKEN.csv";
	Extractsheet_ZEN_TODOUFUKENCMD_01 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/06_Extractsheet_ZEN_TODOUFUKEN_SubSystem_01.awk \""Extractsheet_ZEN_TODOUFUKEN_InputFileName"\" | ";
	Extractsheet_ZEN_TODOUFUKENCMD_02 = CALL_BUSYBOX" fgrep -v -e \"<row r=\" -e \"<f>VLOOKUP\" -e \"</row>\" | ";
	Extractsheet_ZEN_TODOUFUKENCMD_03 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/07_Extractsheet_ZEN_TODOUFUKEN_SubSystem_02.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_04 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/08_Extractsheet_ZEN_TODOUFUKEN_SubSystem_03.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_05 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/09_Extractsheet_ZEN_TODOUFUKEN_SubSystem_04.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_06 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/10_Extractsheet_ZEN_TODOUFUKEN_SubSystem_05.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_07 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/11_Extractsheet_ZEN_TODOUFUKEN_SubSystem_06.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_08 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/12_Extractsheet_ZEN_TODOUFUKEN_SubSystem_07.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_09 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/13_Extractsheet_ZEN_TODOUFUKEN_SubSystem_08.awk | ";
	Extractsheet_ZEN_TODOUFUKENCMD_10 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/14_Extractsheet_ZEN_TODOUFUKEN_SubSystem_09.awk";
	Extractsheet_ZEN_TODOUFUKENCMD = Extractsheet_ZEN_TODOUFUKENCMD_01 Extractsheet_ZEN_TODOUFUKENCMD_02 Extractsheet_ZEN_TODOUFUKENCMD_03 Extractsheet_ZEN_TODOUFUKENCMD_04 Extractsheet_ZEN_TODOUFUKENCMD_05 Extractsheet_ZEN_TODOUFUKENCMD_06 Extractsheet_ZEN_TODOUFUKENCMD_07 Extractsheet_ZEN_TODOUFUKENCMD_08 Extractsheet_ZEN_TODOUFUKENCMD_09 Extractsheet_ZEN_TODOUFUKENCMD_10" > \""Extractsheet_ZEN_TODOUFUKEN_OutputFileName"\"";
	ExecCmd(Extractsheet_ZEN_TODOUFUKENCMD);
	# return Extractsheet_ZEN_TODOUFUKENCMD;
}

# ------------------------------------------------------------------------------------------------------------------------

function OuterJoin(OuterJoin_DIRNAME){
	OuterJoin_InputFileName = OuterJoin_DIRNAME"/Extracted_sheet_ZEN_TODOUFUKEN.csv";
	OuterJoin_OutputFileName = OuterJoin_DIRNAME"/"KEYWORD_06;
	OuterJoinCMD_01 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/15_OuterJoin_SubSystem_01.awk -v Dir="OuterJoin_DIRNAME" \""OuterJoin_InputFileName"\" | ";
	OuterJoinCMD_02 = CALL_BUSYBOX" sort -k 3n,3 -k 2f,2 -t \",\" | ";
	OuterJoinCMD_03 = CALL_BUSYBOX" unix2dos";
	OuterJoinCMD = OuterJoinCMD_01 OuterJoinCMD_02 OuterJoinCMD_03 " > \""OuterJoin_OutputFileName"\"";
	ExecCmd(OuterJoinCMD);
}

# ------------------------------------------------------------------------------------------------------------------------

function UMLCleaner02(UMLCleaner02_DIRNAME){
	UMLCleaner02CMD_01 = CALL_BUSYBOX" find "UMLCleaner02_DIRNAME" -type f | ";
	UMLCleaner02CMD_02 = CALL_BUSYBOX" fgrep -v -e \""KEYWORD_06"\" | ";
	UMLCleaner02CMD_03 = CALL_BUSYBOX" xargs -P 4 -I{} rm \"{}\" > "OUT_DEVNULL;
	UMLCleaner02CMD = UMLCleaner02CMD_01 UMLCleaner02CMD_02 UMLCleaner02CMD_03;
	ExecCmd(UMLCleaner02CMD);
}

# ------------------------------------------------------------------------------------------------------------------------

function GenerateDefineCSVTitle(GenerateDefineCSVTitle_DIRNAME){
	GenerateDefineCSVTitle_InputFileName = GenerateDefineCSVTitle_DIRNAME"/"KEYWORD_06;
	GenerateDefineCSVTitleCMD_01 = CALL_BUSYBOX" fgrep -e \""KEYWORD_07"\" \""GenerateDefineCSVTitle_InputFileName"\" | ";
	GenerateDefineCSVTitleCMD_02 = CALL_BUSYBOX" cut -f 5 -d \",\"";
	GenerateDefineCSVTitleCMD = GenerateDefineCSVTitleCMD_01 GenerateDefineCSVTitleCMD_02;
	GenerateDefineCSVTitle_TitleLine = RetTextExecCmd(GenerateDefineCSVTitleCMD);
	match(GenerateDefineCSVTitle_TitleLine,/[平成|令和][0-9]{1,2}年[0-9]{1,2}月/);
	GenerateDefineCSVTitle_CSVTitle_FROM = substr(GenerateDefineCSVTitle_TitleLine,RSTART - 1,RLENGTH + 1);
	GenerateDefineCSVTitle_TitleLine_02 = GenerateDefineCSVTitle_TitleLine;
	gsub(GenerateDefineCSVTitle_CSVTitle_FROM,"",GenerateDefineCSVTitle_TitleLine_02);
	match(GenerateDefineCSVTitle_TitleLine_02,/[平成|令和][0-9]{1,2}年[0-9]{1,2}月/);
	GenerateDefineCSVTitle_CSVTitle_To = substr(GenerateDefineCSVTitle_TitleLine_02,RSTART - 1,RLENGTH + 1);
	GenerateDefineCSVTitle_DIR = gensub(/AcquiredXLSX\//,"","g",GenerateDefineCSVTitle_DIRNAME);
	GenerateXLSXNAME = gensub(/From_[0-9]{6}_To_[0-9]{6}_/,"","g",GenerateDefineCSVTitle_DIR);
	GenerateDefineCSVTitle_FROMYYYYMM = RepYears(GenerateDefineCSVTitle_CSVTitle_FROM);
	GenerateDefineCSVTitle_ToYYYYMM = RepYears(GenerateDefineCSVTitle_CSVTitle_To);
	GeneName = "DefineCSV/Define_Gene_"strftime("%Y%m%d",systime())"_XML_From_"GenerateDefineCSVTitle_FROMYYYYMM"_To_"GenerateDefineCSVTitle_ToYYYYMM"_OriginXLSX_"GenerateXLSXNAME".csv";
	return GeneName;
}

# ------------------------------------------------------------------------------------------------------------------------

function ReturnHashValue(ReturnHashValue_FileName){
	print ReturnHashValue_FileName"のハッシュ値を取得します・・・" > "con";
	close("con");
	return GetHashValue(ReturnHashValue_FileName);
}

# ------------------------------------------------------------------------------------------------------------------------

function SearchLine(SearchCols_DIR,SearchCols_WORD){
	SearchLine_InputFileName = SearchCols_DIR"/"KEYWORD_06;
	SearchLineCMD = CALL_BUSYBOX" fgrep -e \""SearchCols_WORD"\" \""SearchLine_InputFileName"\"";
	while(SearchLineCMD | getline SearchLine_ResultLine){
		split(SearchLine_ResultLine,SearchLine_ResultLineArrays,",");
		if(SearchLine_ResultLineArrays[5] == ColSearchWord01 || 
			SearchLine_ResultLineArrays[5] == ColSearchWord02 || 
			SearchLine_ResultLineArrays[5] == ColSearchWord03){
			delete SearchLine_ResultLineArrays;
			break;
		}
		delete SearchLine_ResultLineArrays;
	}
	close(SearchLineCMD);
	return SearchLine_ResultLine;
}

# ------------------------------------------------------------------------------------------------------------------------

function DelugeMyth(DelugeMyth_DIR,DelugeMyth_NOAHsARKCOL01,DelugeMyth_NOAHsARKCOL02,DelugeMyth_NOAHsARKCOL03,DelugeMyth_NOAHsARKROW01,DelugeMyth_NOAHsARKROW02,DelugeMyth_NOAHsARKROW03){
	DelugeMyth_InputFileName = DelugeMyth_DIR"/"KEYWORD_06;
	DelugeMyth_OutPutFileName = DelugeMyth_DIR"/"KEYWORD_11;
	DelugeMythCMD01 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/16_DelugeMyth_SubSystem_01.awk";
	DelugeMythCMD02 = "-v DelugeMyth_NOAHsARKCOL01="DelugeMyth_NOAHsARKCOL01;
	DelugeMythCMD03 = "-v DelugeMyth_NOAHsARKCOL02="DelugeMyth_NOAHsARKCOL02;
	DelugeMythCMD04 = "-v DelugeMyth_NOAHsARKCOL03="DelugeMyth_NOAHsARKCOL03;
	DelugeMythCMD05 = "-v DelugeMyth_NOAHsARKROW01="DelugeMyth_NOAHsARKROW01;
	DelugeMythCMD06 = "-v DelugeMyth_NOAHsARKROW02="DelugeMyth_NOAHsARKROW02;
	DelugeMythCMD07 = "-v DelugeMyth_NOAHsARKROW03="DelugeMyth_NOAHsARKROW03;
	DelugeMythCMD = DelugeMythCMD01" "DelugeMythCMD02" "DelugeMythCMD03" "DelugeMythCMD04" "DelugeMythCMD05" "DelugeMythCMD06" "DelugeMythCMD07" "DelugeMyth_InputFileName" > \""DelugeMyth_OutPutFileName"\"";
	ExecCmd(DelugeMythCMD);
}

# ------------------------------------------------------------------------------------------------------------------------

function GenerateDefineCSV(GenerateDefineCSV_DIR,GenerateDefineCSV_OUT,GenerateDefineCSV_COL01,GenerateDefineCSV_COL02,GenerateDefineCSV_COL03){
	GenerateDefineCSV_InputFileName = GenerateDefineCSV_DIR"/"KEYWORD_11;
	GenerateDefineCSV_OutPutFileName = GenerateDefineCSV_OUT;
	GenerateDefineCSVCMD_01 = CALL_GAWK" -f AWKScripts/01_UPDATE/03_SubSystem/17_GenerateDefineCSV_SubSystem_01.awk";
	GenerateDefineCSVCMD_02 = "-v GenerateDefineCSV_COL01="GenerateDefineCSV_COL01;
	GenerateDefineCSVCMD_03 = "-v GenerateDefineCSV_COL02="GenerateDefineCSV_COL02;
	GenerateDefineCSVCMD_04 = "-v GenerateDefineCSV_COL03="GenerateDefineCSV_COL03;
	GenerateDefineCSVCMD = GenerateDefineCSVCMD_01" "GenerateDefineCSVCMD_02" "GenerateDefineCSVCMD_03" "GenerateDefineCSVCMD_04" "GenerateDefineCSV_InputFileName" > \""GenerateDefineCSV_OutPutFileName"\"";
	ExecCmd(GenerateDefineCSVCMD);
}

# ------------------------------------------------------------------------------------------------------------------------

