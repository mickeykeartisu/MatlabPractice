%% initialize environments
clc;
clear variables;

run_make_mat_files_path = "./RunMakeMatFiles.m";
run_plots_path = "./RunPlots.m";

paths = [
    run_make_mat_files_path, ...
    run_plots_path ...
];

for path_index = 1 : length(paths)
    run(paths(path_index));
end