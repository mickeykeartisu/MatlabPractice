%% ファイルを操作する際のパラメータ
inputFilePath = "D:\名城大学\研究室\演習\data\M007_ATR503_A01_T01.raw";
outputFilePath = "D:\名城大学\研究室\演習\data\outputTest.raw";
samplingFrequency = 8000;
dataType = "int16";

%% ファイル操作用のオブジェクトを生成
fileManipulator = FileManipulator( ...
    inputFilePath, ...
    outputFilePath, ...
    samplingFrequency, ...
    dataType ...
);

% プロパティを表示する
fileManipulator.displayProperties();

%% 分析をする際のパラメータ
startPoint = 8863;  % スタート位置
FFTPoint = 2 ^ 10;  % FFTを行う際の次元数
maxCepstrumDimension = 31;  % 高ケフレンシー成分
threshold = 0.01;   % 有声音か無声音かを判定する際の閾値
repeatNumber = 100; % 基本周期で繰り返す回数
basicPeriodGain = 1;    % 基本周期の間隔のゲイン

%% 分析する為のオブジェクトを生成
cepstrum = Cepstrum( ...
    fileManipulator.originalSignal(startPoint : startPoint + 2400 - 1), ...
    fileManipulator.samplingFrequency, ...
    FFTPoint, ...
    maxCepstrumDimension, ...
    threshold, ...
    repeatNumber, ...
    basicPeriodGain ...
);

% プロパティを表示して再生する
cepstrum.displayProperties();
soundsc(cepstrum.synthesizedSignal, cepstrum.samplingFrequency);