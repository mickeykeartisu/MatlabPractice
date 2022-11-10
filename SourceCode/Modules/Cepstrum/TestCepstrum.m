clc;
clear;

%% ファイルを操作する際のパラメータ
inputFilePath = "vaiueo2d.wav";
audioFileManipulator = AudioFileManipulator( ...
    inputFilePath ...
);

%% 分析をする際のパラメータ
startPoint = 3748;  % スタート位置
FFTPoint = 2 ^ 10;  % FFTを行う際の次元数
maxCepstrumDimension = [5, 10, 20];  % 高ケフレンシー成分
threshold = 0.01;   % 有声音か無声音かを判定する際の閾値
repeatNumber = 100; % 基本周期で繰り返す回数
basicPeriodGain = 1;    % 基本周期の間隔のゲイン
continue_time = 32;
continue_point = int32(continue_time * audioFileManipulator.information.SampleRate / 1000);
max_value = 2 ^ (audioFileManipulator.information.BitsPerSample - 1) - 1;

hold on;
legend;
for dimension_index = 1 : length(maxCepstrumDimension)
    cepstrum = Cepstrum( ...
        audioFileManipulator.signal(startPoint : startPoint + continue_point - 1), ...
        audioFileManipulator.information.SampleRate, ...
        FFTPoint, ...
        maxCepstrumDimension(dimension_index), ...
        threshold, ...
        repeatNumber, ...
        basicPeriodGain ...
    );
    cepstrum.displayProperties();
    spectrum_dB = 20 * log10(cepstrum.linearAmplitudedSpectralEnvelope ./ max(cepstrum.linearAmplitudedSpectralEnvelope));
    plot((1 : floor(length(spectrum_dB) / 2)) ./ floor(length(spectrum_dB) / 2) .* floor(audioFileManipulator.information.SampleRate / 2), spectrum_dB(1 : floor(length(spectrum_dB) / 2)), "DisplayName", "Cepstrum " + int2str(maxCepstrumDimension(dimension_index)) + " 次");
end

xlabel("frequency [Hz]");
ylabel("spectrum [dB]");