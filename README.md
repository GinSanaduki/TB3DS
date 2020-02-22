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
https://github.com/GinSanaduki/TB3DS/releases/download/V1.0.0/TB3DS.zip

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

Tesseract developed by Google, Ray Smith, Hewlett-Packard.

https://github.com/UB-Mannheim/tesseract/wiki
5.00 Alpha
manual
https://gammasoft.jp/blog/tesseract-ocr-install-on-windows/

library
https://github.com/tesseract-ocr/tessdata_best
jpn.traineddata
https://github.com/tesseract-ocr/tessdata_best/blob/master/jpn.traineddata
jpn_vert.traineddata
https://github.com/tesseract-ocr/tessdata_best/blob/master/jpn_vert.traineddata

# GREP方式にした経緯

画像に情報がまぎれている分には、散在情報となるのに対し、tesseractでテキストファイルに変換し、スクレイピングで行志向テーブル形式のファイルないしデータベースのテーブルに入った時点で対象になるので、メモリ上で逐一保管し照会後に削除すれば、別に問題ではない。  
裏を返せばそういうことだ。  

あまりに面倒くさかったので、散在情報としてある程度抽出したのをサクラエディタとかでGrepして検索してもらうことにした。  
考えるのが疲れた。tesseractも、発展途上だから、まれではあるが、誤字があったりもするんだよ。名前の誤字はないんだが、失効年月日の「令和」が「信和」になっていたときはなんだかな、となった。  

Hiromitsu Takagi@HiromitsuTakagi

官報をそのまま扱う時点では個人情報が記載されていても散在情報であり個人情報保護法第4章の対象外であるところ、スクレイピングして各個人一人ひとりを行とするテーブル（個人情報ファイル）を作成した時点で「個人データ」に該当し、個人情報保護法第4章の規制がかかる。  
https://mobile.twitter.com/HiromitsuTakagi/status/1107842005231497218


# 解像度などのはなし

官報PDFの中身は官報をスキャンした画像ファイル1ページがそのページ番号のファイルにひもづいている。  
だいたい教員免許のページは、旅先死亡人のたずねと共になっているので、2ページくらいになる。  
基本的なUNIXコマンドでまかなえないプロセスというのは、「PDF」を「画像ファイル」にするプロセスと、「画像ファイル」からOCRでテキストに起こすプロセスだ。  
PDFを画像ファイルに起こす上で、有用な形式はPNG、PPM、TIFFが思い付く。  
PNGならPoppler、ImageMagickにGhostscriptの組み合わせなら基本3つはできる。  
本当は、Popplerでもできるはずなのだが、PPMとTIFFは失敗した。  
TIFFオプションはなんだったんだ・・・。  

結果を書くと、PopplerでPNGに変換するのが一番いい。  
ImageMagickの変換では、解像度の問題以前に、ラスタイメージに変換するので、解像度を高くしてもOCRの精度にはなかなか結び付かないのだ。  
Popplerで変換する際のデフォルトのDPIは150だが、一番精度がいいのは450だった。300あたりでも十分（必要以外の部分のテキストの精度に差異が出た）だが、450にしておくのが安全だろう。  
着目するべきは、解像度を上げれば上げるだけ精度が良くなるわけではなく、600の場合にはむしろ精度が落ちた点にある。   
特に人名の漢字の誤認識が増えたのは致命的だ。  
人名のブラックリストが主なのだから。  
PNG変換時のDPIが600で、OCRのDPIを450に指定しても劣化した精度に変化はなかった。  
OCRもDPIを指定できる（指定しない場合、DPI75となる）ので、450を指定しておくと一番精度が高かった。  
Popplerの場合はポータブル版（インストール不要）があり、Tesseractもポータブル版があるにはあるのだが、バージョンが低い。  
Tesseractは、OCRエンジンに文字読み取りのために学習済みテストデータファイルを読み込ませる必要があるが、Tesseractのポータブル版では、バージョンの高い学習データファイルとの互換性がないために動いてくれないのだ。  
そのため、2019年10月10日に出た後方互換性のある5.0.0 alphaバージョンをインストールして実行した。  
速度は落ちるが、速度は気にしていないので、ベスト版テストデータで実施している。  
PNGが150DPIでOCRが75DPIだと、大阪府が犬阪府とか出たり、記号が乱れたり、1行まるまる認識できなかったりなどしたが、それもなくなった。重複した文字が並ぶケースが増えたが、それはAWKでなんとかすればいいだけだ。  
あと、Tesseractの解析オプションは、psmで指定できるが、デフォルトで最適だった。  
https://blog.machine-powers.net/2018/08/02/learning-tesseract-command-utility/

4とか6とかのほうがいい結果が出ることもあるらしいが、官報OCRでは3がベストな選択だったわけだ。  

サンプルとして、  
pdftoppm.exe -png -r 450 76.pdf 76_450.png
tesseract.exe 76_450.png-1.png sample_76_dpi450_pdftoppm.txt -l jpn --psm 3 --dpi 450
が、一番精度がよく官報をテキストにできていた。  
必要な項目によって、縦書きだったり横書きだったりまちまちなので、縦書きが必要ならばjpnをjpn_vertにするといいだろう。  
実際は、OCRでの解像度が75dpiから200dpiでは変化がないが、250dpiから変化が生じ始める。  
500dpiで計測したが、その時点から多少怪しくなっていたので、450dpiが元のPDFのスキャン画像の解像度なのかもしれない。  

