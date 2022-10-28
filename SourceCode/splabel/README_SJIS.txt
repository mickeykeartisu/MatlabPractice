
	splabel  - MATLABでspwave用ラベルファイルを扱うためのライブラリ


はじめに
--------

MATLABで、spwave用ラベルファイルを読み込んだり、表示したりするための
ライブラリです。


使用方法
--------

SPLOADLABEL: ラベル読み込み関数。spwave用ラベルを読み込みます。

LABEL = SPLOADLABEL(FILENAME);  'sec'（秒フォーマット）ラベル用
LABEL = SPLOADLABEL(FILENAME, FORMAT);  
LABEL = SPLOADLABEL(FILENAME, FORMAT, FS);  'point'（ポイントフォーマット）ラベル用

 LABEL: ラベルの構造体です。time（秒）、phoneme（音素）、data（データ）の
        フィールドが用意されています。例えば、k番目のラベルの音素には、
        label(k).phoneme でアクセスできます。
 FORMAT: 時間のフォーマットです。'sec', 'msec', 'point'から選択します。
 FS: ポイントフォーマットにおけるサンプリング周波数を指定します。


SPPLOTLABEL: ラベルプロット関数。すでにプロットされている図（音声波形や
             スペクトログラム）の上に重ねてラベルをプロットします。
主な使い方は以下の通りです（他にもありますが、詳細はhelp spplotlabelを参照下さい）。

SPPLOTLABEL(LABEL);  'sec'（秒フォーマット）ラベル用
SPPLOTLABEL(LABEL, LINESPEC);  'sec'（秒フォーマット）ラベル用
SPPLOTLABEL(LABEL, LINESPEC, FONTSIZE);  'sec'（秒フォーマット）ラベル用
SPPLOTLABEL(LABEL, FORMAT);			
SPPLOTLABEL(LABEL, FORMAT, LINESPEC);	
SPPLOTLABEL(LABEL, FORMAT, LINESPEC, FONTSIZE);

 LINESPEC: plot関数と同様の線種の設定のための引数です。
           例えば、'b:'などが指定できます。
 FONTSIZE: 音素の表示に用いるフォントサイズです。デフォルトは16です。
 FORMAT: すでにプロットされている図における時間のフォーマットです。
         'sec', 'msec', 'point'から選択します。


使用例
------

testlabel.m を参照して下さい。


--
坂野秀樹（Banno Hideki）
