%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
font_size = 30;
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 50
        %% load noMask spectrogram mat file
        spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/TANDEM STRAIGHT/word " + int2str(file_index) + ".mat";
        spectrogram = load(spectrogram_path);
        disp(spectrogram_path);
    
        %% plot noMask spectrogram
        window = figure;
        window.WindowState = "maximized";
        % colorbar_range = [-70 20];
        time_axis = spectrogram.spectrum_parameters.temporalPositions;
        frequency_axis = [0 spectrogram.sample_rate / 2];
        spectrogram_decibel = 10 * log10(spectrogram.spectrum_parameters.spectrogramTANDEM);
        max_level = max(max(spectrogram_decibel));
        imagesc(time_axis, frequency_axis, max(max_level-80, spectrogram_decibel));
        axis("xy");
        colorbar;
        colormap jet;
        title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " TANDEM STRAIGHT Spectrogram", "FontSize", font_size);
        xlabel("Time [s]", "FontSize", font_size);
        ylabel("Frequency [Hz]", "FontSize", font_size);
        xlim([1.65 2.65]);
        ylim([0 spectrogram.sample_rate / 4]);
        spplotlabel(spectrogram.label, "r-", font_size);
        set(gca, "FontSize", font_size);
        noMask_spectrogram_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/TANDEM STRAIGHT/word " + int2str(file_index) + ".png";
        noMask_spectrogram_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/TANDEM STRAIGHT/word " + int2str(file_index) + ".emf";
        saveas(gcf, noMask_spectrogram_png_path);
        saveas(gcf, noMask_spectrogram_emf_path);
        delete(gcf);
    end
end