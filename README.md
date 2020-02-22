# TB3DS

<p align="center">
    <a href="https://opensource.org/licenses/BSD-3-Clause"><img src="https://img.shields.io/badge/license-bsd-orange.svg" alt="Licenses"></a>
</p>

## Introduction

TB3DS Scripts provides a function to obtain a list of disciplinary dismissal disposal.
This Scripts needs GAWK(the GNU implementation of the AWK programming language) version 4.0 or later and BusyBox developed by Erik Andersen, Rob Landley, Denys Vlasenko and others.  

官報に記載されている教育職員免許状失効公告の内容をPDFからテキスト化し、サクラエディタなどでGREPできるようにする段階までを、googleのTesseract OCRとfreedesktop.orgのPoppler、GNUプロジェクトのGAWKとDenys Vlasenkoがメンテナーであるbusyboxを使用し、収集していきます。
担任の教職員に教員免許状を確認すれば、教育委員会の採用担当に限らず、保護者の方でも確認を行うことができます。

LOTLTHNBRはGAWK、busyboxのバイナリで動作します。
googleのTesseract OCRをインストールする必要があります（手順は、後で書いておきます）。

以下のリンクからダウンロードするか、releaseのタグからダウンロードして、zipファイルを解凍し、subbat内の05_Exec_UPDATE.batというバッチファイルをクリックするだけで起動します。
https://github.com/GinSanaduki/LOTLTHNBR_Win_WithES/releases/download/v1.0.0/LOTLTHNBR_Win_WithES.zip

## TB3DSに対するバグレポートは随時受け付けますが、それ以外の苦情は基本的に受け付けませんのであしからず。

GAWK 5.0.1 Download ezwinports from SourceForge.net

https://sourceforge.net/projects/ezwinports/files/gawk-5.0.1-w32-bin.zip/download

BusyBox Official

https://www.busybox.net/

BusyBox -w32
http://frippery.org/busybox/

Download

http://frippery.org/files/busybox/busybox.exe

BusyBox Wildcard expansion

https://frippery.org/busybox/globbing.html

Download

https://frippery.org/files/busybox/busybox_glob.exe

nkf32 developed by Itaru Ichikawa and others.

Download

https://www.vector.co.jp/soft/win95/util/se295331.html

Poppler developed by freedesktop.org.

https://poppler.freedesktop.org/

Download
http://blog.alivate.com.au/poppler-windows/
poppler-0.68.0_x86
http://blog.alivate.com.au/wp-content/uploads/2018/10/poppler-0.68.0_x86.7z

