%% Initialize environments
clearEnviornments();

%% parameters about Cepstrum
cepstrumPoint = 31; % cepstrum dimension size
FFTPoint = 2 ^ 9;  % FFT point
sourceFilePath = 'D:\名城大学\研究室\演習\data\M007_ATR503_A01_T01.raw'; % Path
dataType = "int16"; % data type
samplingRate = 8000; % sampling frequency [Hz]
startPoint = 8863;  % start point
time = 0.03; % time [s]
destinationFilePath = "D:\名城大学\研究室\演習\data\";  % path
repeatSize = 100;   % repeat size of basic period
thresholdValue = 0.05;    % threshold value

%% get impulse response of cepstrum
[peakPointOfCepstrum, impulseResponseOfCepstrum] = getImpulseResponseOfCepstrum( ...
    cepstrumPoint, ...  % cepstrum point (dimension)
    FFTPoint, ...   % FFT Point
    sourceFilePath, ...   % raw file Path
    dataType, ...   % data type
    samplingRate, ...   % sampling freqeuncy
    startPoint, ... % start point
    time, ...    % extract time
    thresholdValue ... % threshold
);

%% Save files
% generate speech synthesis
[usualSignal, halfSignal, doubleSignal] = getSynthesizedSignals( ...
    peakPointOfCepstrum, ...    % peak point of cepstrum
    FFTPoint, ...   % FFT point
    impulseResponseOfCepstrum, ...   % impulse response
    repeatSize ... % repeat size
);

% save signal to file
writeSignalsToFile( ...
    destinationFilePath, ...   % file path
    dataType, ...   % data type
    usualSignal, ...
    halfSignal, ...
    doubleSignal ... % generated signal
)
