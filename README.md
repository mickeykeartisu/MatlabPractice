# MATLAB

## ここのリポジトリについて

基本的には練習や勉強を通して作成したクラスや音声処理のデータのバックアップとして保存しており公開する予定は今の所無い.  
今後かなりしっかりとリポジトリを作成する事が出来れば公開する可能性もある.

---

## 作成したクラスについて

### **Cepstrum** : ケプストラムを扱うクラス

+ オブジェクト作成に必要なパラメータ
  + originalSignalPath : 開きたい音声信号のファイルパス(拡張子 : raw)
  + samplingFrequency : サンプリング周波数 [Hz]
  + dataType : データ型
  + startPoint : 取り出したい信号のスタートの点
  + continueTime : 抽出したい範囲の時間 [s]
  + FFTPoint : フーリエ変換の際の次元数
  + maxCepstrumDimension : 低次ケプストラムの最大の次元数
  + threshold : ケプストラム最大の値(基本周期の値)が有声音か無声音化を判定する為の閾値
  + repeatNumber : 重畳加算をする際の重畳回数
  + peakPointOfCepstrumGain : 重畳加算をする際の基本周期のゲイン
  + synthesizedFilePath : 合成した音声信号の保存先のパス

+ オブジェクトが保持しているプロパティ
  + originalSignalPath : 開きたい音声信号のファイルパス(拡張子 : raw)
  + samplingFrequency : サンプリング周波数 [Hz]
  + dataType : データ型
  + originalSignal : 開いた音声信号
  + startPoint : 取り出したい信号のスタートの点
  + continueTime : 抽出したい範囲の時間 [s]
  + windowSize : ハミング窓の大きさ
  + extractedSignal : 特定の範囲を抽出した音声信号
  + hammingWindow : ハミング窓
  + multipledSignal : 窓関数を乗じた音声信号
  + FFTPoint : フーリエ変換の際の次元数
  + linearAmplitudedSpectral : 振幅スペクトル(真数)
  + maxCepstrumDimension : 低次ケプストラムの最大の次元数
  + threshold : ケプストラム最大の値(基本周期の値)が有声音か無声音化を判定する為の閾値
  + cepstrum : ケプストラム
  + peakPointOfCepstrum : ケプストラムのピークポイント
  + maxValueOfCepstrum : ケプストラムのピークポイントの最大値
  + basicPeriod : 基本周期
  + basicFrequency : 基本周波数
  + lowQuefrency : ケプストラムの低次元成分(低ケフレンシー)
  + linearAmplitudedSpectralEnvelope : 真数の振幅スペクトル包絡
  + impulseResponseOfCepstrum : ケプストラムのインパルス応答
  + repeatNumber : 重畳加算をする際の重畳回数
  + peakPointOfCepstrumGain : 重畳加算をする際の基本周期のゲイン
  + synthesizedSignal : ケプストラムのインパルス応答から重畳加算された音声信号
  + synthesizedFilePath : 合成した音声信号の保存先のパス

### STFT(Short Time Fourier Transform) : STFTを扱うクラス
+ 