%% initialize environments
clc;
clear variables;

waveform_plot_file_path = "./AudioFileManipulator/PlotAudioFileManipulator.m";
World_spectrogram_plot_file_path = "./world/PlotSpectrogram.m";
Tandem_Straight_spectrogram_plot_file_path = "./TandemSTRAIGHT/PlotSpectrogram.m";
dynamic_feature_plot_file_path = "./DynamicFeature/PlotDynamicFeature.m";
long_term_average_spectrum_plot_file_path = "./LongTermAverageSpectrum/PlotLongTermAverageSpectrum";

plot_file_paths = [
    waveform_plot_file_path, ...
    World_spectrogram_plot_file_path, ...
    Tandem_Straight_spectrogram_plot_file_path, ...
    dynamic_feature_plot_file_path ...
];

for plot_file_path_index = 1 : length(plot_file_paths)
    run(plot_file_paths(plot_file_path_index));
end