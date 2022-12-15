%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 50
        %% load noMask audio file and confirm properties
        spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/World/word " + int2str(file_index) + ".mat";
        spectrogram = load(spectrogram_path);
    
        %% plot noMask audio waveform
        window = figure;
        waveform_plot_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Waveform/word " + int2str(file_index) + ".png";
        time_axis = (1 : length(spectrogram.signal)) / spectrogram.sample_rate;
        font_size = 18;
        plot(time_axis, spectrogram.signal, "DisplayName", mask_list(mask_index));
        window.WindowState = "maximized";
        title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " waveform", "FontSize", font_size);
        xlabel("time [s]", "FontSize", font_size);
        ylabel("linear amplitude", "FontSize", font_size);
        xlim([1.65 2.65]);
        spplotlabel(spectrogram.label, "r:");
        saveas(gcf, waveform_plot_path);
        delete(gcf);
    end
end