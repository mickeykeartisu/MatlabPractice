%% 分析をする際のパラメータ
originalSignalPath = "D:\名城大学\研究室\演習\data\M007_ATR503_A01_T01.raw"; % 分析元の音声信号のパス
samplingFrequency = 8000;   %　サンプリング周波数 [Hz]
dataType = "int16"; % データの型
startPoint = 8863;  % 抽出する最初のポイント
continueTime = 0.03;    % 抽出する時間
FFTPoint = 2 ^ 16;  % FFTを行う際の次元数
maxCepstrumPoint = 31;  % 高ケフレンシー成分
threshold = 0.035;   % 有声音か無声音かを判定する際の閾値
repeatNumber = 100; % 基本周期で繰り返す回数
peakPointOfCepstrumGain = 0.5;    % 基本周期の間隔のゲイン
synthesizedFilePath ="D:\名城大学\研究室\演習\data\halfPeriodSynthesizedSignal.raw";   % 合成した音声信号の保存先のパス

%% 分析する為のオブジェクトを生成
cepstrum = Cepstrum( ...
    originalSignalPath, ...
    samplingFrequency, ...
    dataType, ...
    startPoint, ...
    continueTime, ...
    FFTPoint, ...
    maxCepstrumPoint, ...
    threshold, ...
    repeatNumber, ...
    peakPointOfCepstrumGain, ...
    synthesizedFilePath ...
);

cepstrum.displayInformation();

%% 信号を描画する
row = 2;    % 行サイズ
column = 1; % 列サイズ

subplot(row, column, 1);
plot(cepstrum.linearAmplitudedSpectral);
xlim([0 20000]);

subplot(row, column, 2);
plot(cepstrum.linearAmplitudedSpectralEnvelope);
xlim([0 20000]);
