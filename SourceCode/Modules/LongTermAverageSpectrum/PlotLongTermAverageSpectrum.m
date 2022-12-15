%% initialize environments
clc;
clear variables;

%% plot all long term average spectrum
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
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
            plot(x, ltas_decibel, "DisplayName", mask_list(mask_index));
            font_size = 18;
            title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " LTAS " + spectrogram_list(spectrogram_index), "FontSize", font_size);
            xlim([0 floor(spectrogram.sample_rate / 4)]);
            ylim([-60 10]);
            xlabel("frequency [Hz]", "FontSize", font_size);
            ylabel("long term average spectrum Magnitude [dB]", "FontSize", font_size);
            long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".png";
            saveas(gcf, long_term_average_spectrum_png_path);
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
        font_size = 18;
        title("Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " LTAS Comparison", "FontSize", font_size);
        xlabel("frequency [Hz]", "FontSize", font_size);
        ylabel("long term average spectrum Magnitude [dB]", "FontSize", font_size);
        for spectrogram_index = 1 : length(spectrogram_list)
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
        
            %% plot long term average spectrum
            fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
            x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
            ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
            plot(x, ltas_decibel, "DisplayName", spectrogram_list(spectrogram_index));
        end
        xlim([0 floor(spectrogram.sample_rate / 4)]);
        ylim([-60 10]);
        long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/ComparisonTandemStraightToWorld/word " + int2str(file_index) + ".png";
        saveas(gcf, long_term_average_spectrum_png_path);
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
        font_size = 18;
        title("Set1\_word " + int2str(file_index) + " LTAS Comparison noMask withMask " + spectrogram_list(spectrogram_index), "FontSize", font_size);
        xlabel("frequency [Hz]", "FontSize", font_size);
        ylabel("long term average spectrum Magnitude [dB]", "FontSize", font_size);
        for mask_index = 1 : length(mask_list)
            %% load dynamic feature World mat file
            long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(long_term_average_spectrum_path);
            spectrogram = spectrogram.spectrogram;
        
            %% plot long term average spectrum
            fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
            x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
            ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
            plot(x, ltas_decibel, "DisplayName", mask_list(mask_index));
        end
        xlim([0 floor(spectrogram.sample_rate / 4)]);
        ylim([-60 10]);
        long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".png";
        saveas(gcf, long_term_average_spectrum_png_path);
        delete(gcf);
    end
end

%% plot comparison noMask withMask all average
window = figure;
window.WindowState = "maximized";
grid on;
hold on;
legend;
font_size = 18;
title("Set1\_word all LTAS Comparison", "FontSize", font_size);
xlabel("frequency [Hz]", "FontSize", font_size);
ylabel("long term average spectrum Magnitude [dB]", "FontSize", font_size);
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
    ltas_decibel = 10 * log10(long_term_average_spectrum_mean / (2 * file_index));
    plot(x, ltas_decibel, "DisplayName", mask_list(mask_index));
end
xlim([0 floor(spectrogram.sample_rate / 4)]);
ylim([-60 10]);
long_term_average_spectrum_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/all/word all_mean.png";
saveas(gcf, long_term_average_spectrum_png_path);
delete(gcf);

