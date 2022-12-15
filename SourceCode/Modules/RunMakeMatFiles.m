%% initialize environments
clc;
clear variables;

World_spectrogram_make_mat_file_path = "./world/MakeMatFiles.m";
Tandem_Straight_spectrogram_make_mat_file_path = "./TandemSTRAIGHT/MakeMatFiles.m";
dynamic_feature_make_mat_file_path = "./DynamicFeature/MakeMatFiles.m";
long_term_average_spectrum_make_mat_file_path = "./LongTermAverageSpectrum/MakeMatFiles.m";

make_file_paths = [
    World_spectrogram_make_mat_file_path, ...
    Tandem_Straight_spectrogram_make_mat_file_path, ...
    dynamic_feature_make_mat_file_path, ...
    long_term_average_spectrum_make_mat_file_path ...
];

for make_file_path_index = 1 : length(make_file_paths)
    run(make_file_paths(make_file_path_index));
end