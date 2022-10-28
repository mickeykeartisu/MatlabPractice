clc;
clear variables;

inputFilePath = "D:/名城大学/研究室/演習/data/M007_ATR503_A01_T01.wav";
audioFileManipulator = AudioFileManipulator( ...
    inputFilePath ...
);

%% 分析をする際のパラメータ
start_point = 8863;  % スタート位置
continue_time = 30; % [ms]
continue_point = continue_time / 1000 * audioFileManipulator.information.SampleRate;
mode = "hamming";
fft_point = 2 ^ 10;

autocorrelationFunction = AutocorrelationFunction( ...
    audioFileManipulator.signal(start_point : start_point + continue_point - 1), ...
    mode ...
);
autocorrelationFunction.calculate_autocorrelations();

autocorrelationFunction_with_fourier = AutocorrelationFunction( ...
    audioFileManipulator.signal(start_point : start_point + continue_point - 1), ...
    mode ...
);
autocorrelationFunction_with_fourier.calculate_autocorrelations_with_fourier(fft_point);

plot((1 : length(autocorrelationFunction.signal)) ./ (audioFileManipulator.information.SampleRate / 1000), autocorrelationFunction.autocorrelations);
hold on;
plot((1 : length(autocorrelationFunction_with_fourier.signal)) ./ (audioFileManipulator.information.SampleRate / 1000), autocorrelationFunction_with_fourier.autocorrelations(1 : length(autocorrelationFunction_with_fourier.signal)));
legend("no fourier", "with fourier");
title("Auto Correlations");
xlabel("time [ms]")
ylabel("auto correlations")
grid on;