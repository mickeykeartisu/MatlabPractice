%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
for file_index = 1 : 1
    %% load noMask spectrogram mat file
    noMask_mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/noMask/PowerSpectrogram/set1_noMask_word " + int2str(file_index) + ".mat";
    noMask_mat_file = load(noMask_mat_file_path);

    %% plot noMask spectrogram
    window = figure;
    window.WindowState = "maximized";
    font_size = 18;
    colorbar_range = [-80 0];
    time_axis = [0 noMask_mat_file.power_spectrogram.temporal_positions(end)];
    frequency_axis = [0 noMask_mat_file.sample_rate / 4];
    spectrogram_decibel = 10 * log10(noMask_mat_file.power_spectrogram.spectrogram);
    max_level = max(max(spectrogram_decibel));
    imagesc(time_axis, frequency_axis, max(max_level-80,spectrogram_decibel), colorbar_range);
    axis("xy");
    colorbar;
    title("Set1\_noMask\_word " + int2str(file_index) + " Spectrogram", "FontSize", font_size);
    xlabel("time [s]", "FontSize", font_size);
    ylabel("frequency [Hz]", "FontSize", font_size);
    xlim([1.65 2.65]);
    spplotlabel(noMask_mat_file.noMask_label, "r-");
    noMask_spectrogram_png_path = "D:/名城大学/研究室/研究/Outputs/spectrogram/set1_noMask_word " + int2str(file_index) + ".png";
    saveas(gcf, noMask_spectrogram_png_path);
    delete(gcf);
end