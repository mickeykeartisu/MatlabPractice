%% initialize environments
clc;
clear variables;

%% plot all long term average spectrum
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
plot_format_list = ["b-", "r--"];
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
        
            %% plot long term average spectrum
            fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
            x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
            window = figure;
            window.WindowState = "maximized";
            grid on;
            hold on;
            legend;
            ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
            plot(x, ltas_decibel, "DisplayName", mask_list(mask_index), "LineWidth", 3);
            font_size = 24;
            title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " LTAS " + spectrogram_list(spectrogram_index), "FontSize", font_size);
            xlim([0 floor(spectrogram.sample_rate / 4)]);
            ylim([-60 10]);
            xlabel("Frequency [Hz]", "FontSize", font_size);
            ylabel("Long term average spectrum Magnitude [dB]", "FontSize", font_size);
            set(gca, "FontSize", font_size);
            long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".png";
            long_term_average_spectrum_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".emf";
            saveas(gcf, long_term_average_spectrum_png_path);
            saveas(gcf, long_term_average_spectrum_emf_path);
            delete(gcf);
        end
    end
end

%% plot comparison Tandem Straight to World
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 50
        window = figure;
        window.WindowState = "maximized";
        grid on;
        hold on;
        legend;
        title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " LTAS Comparison", "FontSize", font_size);
        xlabel("Frequency [Hz]", "FontSize", font_size);
        ylabel("Long term average spectrum Magnitude [dB]", "FontSize", font_size);
        for spectrogram_index = 1 : length(spectrogram_list)
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
        
            %% plot long term average spectrum
            fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
            x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
            ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
            plot(x, ltas_decibel, plot_format_list(mask_index), "DisplayName", spectrogram_list(spectrogram_index), "LineWidth", 3);
        end
        xlim([0 floor(spectrogram.sample_rate / 4)]);
        ylim([-60 10]);
        set(gca, "FontSize", font_size);
        long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/ComparisonTandemStraightToWorld/word " + int2str(file_index) + ".png";
        long_term_average_spectrum_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/ComparisonTandemStraightToWorld/word " + int2str(file_index) + ".emf";
        saveas(gcf, long_term_average_spectrum_png_path);
        saveas(gcf, long_term_average_spectrum_emf_path);
        delete(gcf);
    end
end

%% plot comparison noMask withMask
for spectrogram_index = 1 : length(spectrogram_list)
    for file_index = 1 : 50
        window = figure;
        window.WindowState = "maximized";
        grid on;
        hold on;
        legend;
        title("Set1\_word " + int2str(file_index) + " LTAS Comparison noMask withMask " + spectrogram_list(spectrogram_index), "FontSize", font_size);
        xlabel("Frequency [Hz]", "FontSize", font_size);
        ylabel("Long term average spectrum Magnitude [dB]", "FontSize", font_size);
        for mask_index = 1 : length(mask_list)
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
        
            %% plot long term average spectrum
            fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
            x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
            ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
            plot(x, ltas_decibel, plot_format_list(mask_index), "DisplayName", mask_list(mask_index), "LineWidth", 3);
        end
        xlim([0 floor(spectrogram.sample_rate / 4)]);
        ylim([-60 10]);
        set(gca, "FontSize", font_size);
        long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".png";
        long_term_average_spectrum_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".emf";
        saveas(gcf, long_term_average_spectrum_png_path);
        saveas(gcf, long_term_average_spectrum_emf_path);
        delete(gcf);
    end
end

%% plot comparison noMask withMask all average
for spectrogram_index = 1 : length(spectrogram_list)
    window = figure;
    window.WindowState = "maximized";
    grid on;
    hold on;
    legend;
    title("Set1\_word all LTAS Comparison " + spectrogram_list(spectrogram_index), "FontSize", font_size);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Long term average spectrum Magnitude [dB]", "FontSize", font_size);
    for mask_index = 1 : length(mask_list)
        long_term_average_spectrum_mean = 0;
        for file_index = 1 : 50
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
            long_term_average_spectrum_mean = long_term_average_spectrum_mean + spectrogram.long_term_average_spectrum;
        end
        %% plot long term average spectrum
        fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
        x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
        ltas_decibel = 10 * log10(long_term_average_spectrum_mean / file_index);
        plot(x, ltas_decibel, plot_format_list(mask_index), "DisplayName", mask_list(mask_index), "LineWidth", 3);
    end
    xlim([0 floor(spectrogram.sample_rate / 4)]);
    ylim([-60 10]);
    set(gca, "FontSize", font_size);
    long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word all.png";
    long_term_average_spectrum_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word all.emf";
    saveas(gcf, long_term_average_spectrum_png_path);
    saveas(gcf, long_term_average_spectrum_emf_path);
    delete(gcf);
end

%% plot comparison noMask withMask all average
window = figure;
window.WindowState = "maximized";
grid on;
hold on;
legend;
title("Set1\_word all LTAS Comparison", "FontSize", font_size);
xlabel("Frequency [Hz]", "FontSize", font_size);
ylabel("Long term average spectrum Magnitude [dB]", "FontSize", font_size);
for mask_index = 1 : length(mask_list)
    long_term_average_spectrum_mean = 0;
    for file_index = 1 : 50
        for spectrogram_index = 1 : length(spectrogram_list)
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
            long_term_average_spectrum_mean = long_term_average_spectrum_mean + spectrogram.long_term_average_spectrum;
        end
    end
    %% plot long term average spectrum
    fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
    x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
    ltas_decibel = 10 * log10(long_term_average_spectrum_mean / file_index);
    plot(x, ltas_decibel, plot_format_list(mask_index), "DisplayName", mask_list(mask_index), "LineWidth", 3);
end
xlim([0 floor(spectrogram.sample_rate / 4)]);
ylim([-60 10]);
set(gca, "FontSize", font_size);
long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/all/word_all_mean.png";
long_term_average_spectrum_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/all/word_all_mean.emf";
saveas(gcf, long_term_average_spectrum_png_path);
saveas(gcf, long_term_average_spectrum_emf_path);
delete(gcf);

%% plot phoneme long term average spectrum
phoneme_counter_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
phoneme_counter = load(phoneme_counter_path);
phoneme_counter = phoneme_counter.phoneme_counter;
phoneme_keys = keys(phoneme_counter);
for phoneme_index = 1 : length(phoneme_keys)
    window = figure;
    window.WindowState = "maximized";
    grid on;
    hold on;
    legend;
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Long term average spectrum Magnitude [dB]", "FontSize", font_size);
    for mask_index = 1 : length(mask_list)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;
        
        %% plot long term average spectrum
        fftl = (length(phoneme_long_term_average_spectrum)-1)*2;
        x = ((0:fftl/2)*long_term_average_spectrum.sample_rate/fftl)';
        ltas_decibel = 10 * log10(phoneme_long_term_average_spectrum);
        plot(x, ltas_decibel, plot_format_list(mask_index), "DisplayName", mask_list(mask_index), "LineWidth", 3);
    end
    title("Set1\_phoneme " + long_term_average_spectrum.phoneme + " LTAS Comparison", "FontSize", font_size);
    xlim([0 floor(spectrogram.sample_rate / 4)]);
    ylim([-80 2]);
    set(gca, "FontSize", font_size);
    phoneme_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".png";
    phoneme_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".emf";
    saveas(gcf, phoneme_png_path);
    saveas(gcf, phoneme_emf_path);
    delete(gcf);
end