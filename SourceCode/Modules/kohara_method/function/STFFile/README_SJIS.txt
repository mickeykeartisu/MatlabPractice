
	STFFile - MATLAB用STFファイル関連ツール

河原先生が開発しているMATLAB版STRAIGHTでSTFファイルを利用するための
ツール集です。MATLAB版STRAIGHTを使わない人には役に立たないと思います。
なお、このバージョンは、古いSTRAIGHTであるLegacy-STRAIGHTだけでなく、
最新のTANDEM-STRAIGHTもサポートしています。

readSTFFile: STFファイルを読み込むための関数
writeSTFFile: STRAIGHTオブジェクトをSTFファイルとして書き込むための関数。
  ここで、STRAIGHTオブジェクトとは、TANDEM-STRAIGHTではMATLAB版STRAIGHT
  内部でも用いられているTANDEM-STRAIGHT用のオブジェクトで、Legacy-STRAIGHT
  では、STFファイルを独自にオブジェクト化（STFオブジェクト）したものです。
createSTFObject: Legacy-STRAIGHTと併せて用いる上記のSTFオブジェクトを生成
  するための関数
testSTF: Legacy-STRAIGHTの関数を使用し、STFファイルの読み書きのテストを
  行うスクリプト
testTandemSTF: TANDEM-STRAIGHTの関数を使用し、STFファイルの読み書きの
  テストを行うスクリプト
