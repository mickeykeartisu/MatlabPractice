%% clear cache
clc;
clear variables;

%% open audio file
inputFilePath = "vaiueo2d.wav";
audioFileManipulator = AudioFileManipulator( ...
    inputFilePath ...
);

%% set parameters
start_point = 3748;  % あのスタート位置
continue_time = 30; % [ms]
continue_point = int32(continue_time * audioFileManipulator.information.SampleRate / 1000);
window_mode = "hamming";
dimension = [5, 10, 20];
fft_point = 2 ^ 11;
threshold = 0.001;
frame_length = 32;
hop_length = 8;

for dimension_index = 1 : length(dimension)
    %% generate LPC instance
    lpc_vocoder = LPCVocoder( ...
        audioFileManipulator.signal, ...
        window_mode, ...
        fft_point, ...
        dimension(dimension_index), ...
        threshold, ...
        audioFileManipulator.information.SampleRate, ...
        frame_length, ...
        hop_length ...
    );
    lpc_vocoder.calculate_basic_period_and_frequency(audioFileManipulator.information.SampleRate);
    
    %% plot spectrum envelope
    plot((1 : length(lpc_vocoder.basic_frequencies)) ./ (audioFileManipulator.information.SampleRate / 1000) , lpc_vocoder.basic_frequencies, "DisplayName", "LPC" + int2str(dimension(dimension_index)));
    legend;
    hold on;
end

title("LPC Comparison")
xlabel("time [s]");
ylabel("basic frequency(f0) [Hz]")