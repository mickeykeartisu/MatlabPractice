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
continue_time = 32; % [ms]
continue_point = int32(continue_time * audioFileManipulator.information.SampleRate / 1000);
window_mode = "hamming";
dimension = [5, 10, 20];
fft_point = 2 ^ 10;
threshold = 0.0001;
max_value = 2 ^ (audioFileManipulator.information.BitsPerSample - 1) - 1;
hold on;
legend;

for dimension_index = 1 : length(dimension)
    %% generate LPC instance
    lpc = LPC( ...
        audioFileManipulator.signal(start_point : start_point + continue_point), ...
        window_mode, ...
        fft_point, ...
        dimension(dimension_index), ...
        threshold ...
    );
    lpc.start_LPC_analysis();
    lpc.display_properties();
    
    plot((1 : length(lpc.calculate_spectrum_density_dB())) ./ length(lpc.calculate_spectrum_density_dB()) .* floor(audioFileManipulator.information.SampleRate / 2), lpc.calculate_spectrum_density_dB(), "DisplayName", "LPC " + int2str(dimension(dimension_index)) + " 次");
end

xlabel("frequency [Hz]");
ylabel("power spectrum [dB]");
