%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
for file_index = 1 : 50
    noMask_modulation_frequency_spectrum_mean = 0;
    withMask_modulation_frequency_spectrum_mean = 0;
    for spectrogram_index = 1 : length(spectrogram_list)
        %% load noMask spectrogram mat file
        noMask_modulation_frequency_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/noMask/ModulationFrequencySpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
        noMask_modulation_frequency_spectrum = load(noMask_modulation_frequency_spectrum_path);
        noMask_modulation_frequency_spectrum_mean = noMask_modulation_frequency_spectrum_mean + noMask_modulation_frequency_spectrum.modulation_frequency_spectrum;

        withMask_modulation_frequency_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/withMask/ModulationFrequencySpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
        withMask_modulation_frequency_spectrum = load(withMask_modulation_frequency_spectrum_path);
        withMask_modulation_frequency_spectrum_mean = withMask_modulation_frequency_spectrum_mean + withMask_modulation_frequency_spectrum.modulation_frequency_spectrum;

        for cepstrum_order_index = 1 : size(noMask_modulation_frequency_spectrum.modulation_frequency_spectrum, 1)
            frequency_axis = (0 : (1000 / (size(noMask_modulation_frequency_spectrum.modulation_frequency_spectrum, 2) - 1)) : 1000);
            window = figure;
            window.WindowState = "maximized";
            hold on;
            grid on;
            plot(frequency_axis, 10 * log10(noMask_modulation_frequency_spectrum.modulation_frequency_spectrum(cepstrum_order_index, :)));
            plot(frequency_axis, 10 * log10(withMask_modulation_frequency_spectrum.modulation_frequency_spectrum(cepstrum_order_index, :)));
            legend("noMask", "withMask");
            xlim([0 50]);
            xticks(0 : 5 : 50);
            font_size = 20;
            title("Set1\_word" + int2str(file_index) + " Modulation Frequency Spectrum cepstrum order " + int2str(cepstrum_order_index - 1) + " " + spectrogram_list(spectrogram_index), FontSize=font_size);
            xlabel("Modulation Frequency [Hz]", FontSize=font_size);
            ylabel("Magnitude [dB]", FontSize=font_size);
            modulation_frequency_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/ModulationFrequencySpectrum/" + spectrogram_list(spectrogram_index) + "/order" + int2str(cepstrum_order_index - 1) + "/word " + int2str(file_index) + ".png";
            saveas(gcf, modulation_frequency_spectrum_png_path);
            delete(gcf);
        end
    end
    for cepstrum_order_index = 1 : size(noMask_modulation_frequency_spectrum.modulation_frequency_spectrum, 1)
        frequency_axis = (0 : (1000 / (size(noMask_modulation_frequency_spectrum.modulation_frequency_spectrum, 2) - 1)) : 1000);
        window = figure;
        window.WindowState = "maximized";
        hold on;
        grid on;
        plot(frequency_axis, 10 * log10(noMask_modulation_frequency_spectrum_mean(cepstrum_order_index, :) / 2));
        plot(frequency_axis, 10 * log10(withMask_modulation_frequency_spectrum_mean(cepstrum_order_index, :) / 2));
        legend("noMask", "withMask");
        xlim([0 50]);
        xticks(0 : 5 : 50);
        font_size = 20;
        title("Set1\_word" + int2str(file_index) + " Modulation Frequency Spectrum cepstrum order " + int2str(cepstrum_order_index - 1) + " mean", FontSize=font_size);
        xlabel("Modulation Frequency [Hz]", FontSize=font_size);
        ylabel("Magnitude [dB]", FontSize=font_size);
        modulation_frequency_spectrum_mean_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/ModulationFrequencySpectrum/all/order" + int2str(cepstrum_order_index - 1) + "/word " + int2str(file_index) + ".png";
        saveas(gcf, modulation_frequency_spectrum_mean_png_path);
        delete(gcf);
    end
end