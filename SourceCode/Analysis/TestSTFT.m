%% ファイルを操作する際のパラメータ
inputFilePath = "D:\名城大学\研究室\演習\data\F009_ATR503_A01_T01_8k.raw";
outputFilePath = "D:\名城大学\研究室\演習\data\F009_ATR503_A01_T01_8kVocoder.raw";
samplingFrequency = 8000;
dataType = "int16";

%% ファイル操作用のオブジェクトを生成
fileManipulator = FileManipulator( ...
    inputFilePath, ...
    outputFilePath, ...
    samplingFrequency, ...
    dataType ...
);

%% STFTオブジェクトを生成する際のパラメータ
FFTPoint = 2 ^ 10;  % FFTを行う際の次元数
maxCepstrumDimension = 31;  % 高ケフレンシー成分の最大値
threshold = 0.15;   % 有声音か無声音かを判定する際の閾値
repeatNumber = 100; % 基本周期で繰り返す回数
basicPeriodGain = 1;    % 基本周期の間隔のゲイン
frameLength = 32;  % フレーム長 [ms]
frameShift = 8;   % シフト長 [ms]

%% STFTオブジェクトを生成
stft = STFT( ...
    fileManipulator.originalSignal, ...
    fileManipulator.samplingFrequency, ...
    frameLength, ...
    frameShift, ...
    FFTPoint ...
);

% 基本周波数を計算して重畳加算する
stft.calculateBasicFrequenciesAndSynthesize( ...
    maxCepstrumDimension, ...
    threshold, ...
    repeatNumber, ...
    basicPeriodGain ...
);

plot(stft.synthesizedSignal);
soundsc(stft.synthesizedSignal, stft.samplingFrequency);
fileManipulator.writeSignal(stft.synthesizedSignal);