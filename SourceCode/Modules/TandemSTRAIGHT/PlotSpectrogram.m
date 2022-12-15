%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 50
        %% load noMask spectrogram mat file
        spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/TandemStraight/word " + int2str(file_index) + ".mat";
        spectrogram = load(spectrogram_path);
    
        %% plot noMask spectrogram
        window = figure;
        window.WindowState = "maximized";
        font_size = 18;
        colorbar_range = [-80 0];
        time_axis = spectrogram.spectrum_parameters.temporalPositions;
        frequency_axis = [0 spectrogram.sample_rate / 4];
        spectrogram_decibel = 10 * log10(spectrogram.spectrum_parameters.spectrogramSTRAIGHT);
        max_level = max(max(spectrogram_decibel));
        imagesc(time_axis, frequency_axis, max(max_level-80, spectrogram_decibel), colorbar_range);
        axis("xy");
        colorbar;
        title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " Tandem Straight Spectrogram", "FontSize", font_size);
        xlabel("time [s]", "FontSize", font_size);
        ylabel("frequency [Hz]", "FontSize", font_size);
        xlim([1.65 2.65]);
        spplotlabel(spectrogram.label, "r-");
        noMask_spectrogram_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/TandemStraight/word " + int2str(file_index) + ".png";
        saveas(gcf, noMask_spectrogram_png_path);
        delete(gcf);
    end
end