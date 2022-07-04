# MATLAB

## ここのリポジトリについて

+ 学習の際に作成したソースコードを管理する為のリポジトリ
+ 現在はケプストラム分析がメイン

---

## 作成したクラスについて

---

### **FileManipulator** : ファイルの入出力を扱うクラス

+ インスタンスを生成する際に必要なパラメータ
  + inputFilePath : 入力として使用したいファイル(拡張子はrawを想定)のパス
  + outputFilePath : 合成後の出力先のパス(拡張子はrawを想定)
  + samplingFrequency : 入力音声信号のサンプリング周波数の値
  + dataType : 入力信号のデータ型

---

### **Cepstrum** : ケプストラムを扱うクラス

+ インスタンスを生成する際に必要なパラメータ
  + extractedSignal : 分析したい範囲の信号を抽出した音声信号
  + samplingFrequency : サンプリング周波数
  + FFTPoint : FFTを行う際の次元数
  + maxCepstrumDimension : 低次のケフレンシー成分を抽出する際の最大次元数(使用する際は指定したい次元数 + 1で入力)
  + threshold : 有声音か無声音の判定を行う際の閾値
  + repeatNumber : 重畳加算を行う際に繰り返す回数
  + basicPeriodGain : 重畳加算をする際の基本周期の間隔の利得

---

### **CepstrumVocoder** : ケプストラムのボコーダーを扱うクラス

+ インスタンスを生成する際に必要なパラメータ
  + originalSignal : 入力する音声信号全体
  + samplingFrequency : サンプリング周波数[Hz]
  + frameLength : フレーム長 [ms]
  + frameShift : フレームシフト長 [ms]
  + FFTPoint : FFTを行う際の次元数

---