%% パラメータを設定
inputFilePath = "D:\名城大学\研究室\演習\data\M007_ATR503_A01_T01_44k.wav";

% 音声ファイルを取得する
audioFileManipulator = AudioFileManipulator( ...
    inputFilePath ...
);

% 音声ファイルの量子化ビット数を16[bit]に変換する
audioFileManipulator.quantize();

% 基本周波数と非周期性パラメータを抽出する
[basicFrequency, aperiodicityParameter] = exstraightsource(audioFileManipulator.signal, audioFileManipulator.information.SampleRate);
fprintf("basic frequency : %d\naperiodicity parameter : %d\n", basicFrequency, aperiodicityParameter);

