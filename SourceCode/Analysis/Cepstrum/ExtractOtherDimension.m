%% clear cache
clc;
clear variables;

%% open audio file
inputFilePath = "vaiueo2d.wav";
audioFileManipulator = AudioFileManipulator( ...
    inputFilePath ...
);

window_mode = "hamming";
fft_point = 2 ^ 11;
threshold = 0.001;
frame_length = 32;
hop_length = 8;
maxCepstrumDimension = [5, 10, 20];  % 高ケフレンシー成分の最大値
repeatNumber = 100; % 基本周期で繰り返す回数
basicPeriodGain = 1;    % 基本周期の間隔のゲイン

%% CepstrumVocoderオブジェクトを生成
cepstrumVocoder = CepstrumVocoder( ...
    audioFileManipulator.signal, ...
    audioFileManipulator.information.SampleRate, ...
    frame_length, ...
    hop_length, ...
    fft_point ...
);

for dimension_index = 1 : length(maxCepstrumDimension)
    % 基本周波数を計算して重畳加算する
    cepstrumVocoder.calculateBasicFrequenciesAndSynthesize( ...
        maxCepstrumDimension(dimension_index), ...
        0.01, ...
        repeatNumber, ...
        basicPeriodGain ...
    );
    plot((1 : length(cepstrumVocoder.basicFrequencies)) ./ (audioFileManipulator.information.SampleRate / 1000), cepstrumVocoder.basicFrequencies, "DisplayName", "Cepstrum" + int2str(maxCepstrumDimension(dimension_index)));
    legend;
    hold on;
end

title("Cepstrum Comparison")
xlabel("time [s]");
ylabel("basic frequency(f0) [Hz]")