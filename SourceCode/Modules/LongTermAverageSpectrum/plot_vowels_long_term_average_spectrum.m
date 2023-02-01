%% initialize environments
clc;
clear variables;

%% 算出時のパラメータの設定
mask_list = ["noMask", "withMask"];
vowels = ["a", "i", "u", "u:", "e", "o"];
consonants = ["k", "g", "s", "z", "t", "c", "d", "n", "h", "b", "p", "m", "r"];
Harvest_option.f0_floor = 175;  % F3
Harvest_option.f0_ceil = 265;   % C4
CheapTrick_option.fft_size = (2 ^ 17);
D4C_option.fft_size = CheapTrick_option.fft_size;

%% 長時間平均スペクトルの変数を初期化
vowels_long_term_average_spectrum = zeros(length(mask_list), ((CheapTrick_option.fft_size / 2) + 1));
consonants_long_term_average_spectrum = zeros(length(mask_list), ((CheapTrick_option.fft_size / 2) + 1));
total_phoneme_long_term_average_spectrum = zeros(length(mask_list), ((CheapTrick_option.fft_size / 2) + 1));
vowels_counter = 0;
consonants_counter = 0;
total_phoneme_counter = 0;
vowels_column_size = 0;
consonants_column_size = 0;
total_phoneme_column_size = 0;

%% 分割する周波数のパラメータを設定
band_candidate = [20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000];
band_candidate_range = calculate_center_frequency_range(band_candidate);

%% 分割した長時間平均スペクトルを初期化
vowels_sub_band_long_term_average_spectrum = zeros(length(mask_list), length(band_candidate));
consonants_sub_band_long_term_average_spectrum = zeros(length(mask_list), length(band_candidate));
total_phoneme_sub_band_long_term_average_spectrum = zeros(length(mask_list), length(band_candidate));

%% 母音に関する長時間平均スペクトルを算出
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 50
        %% load noMask audio file and confirm properties
        audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/" + mask_list(mask_index) + "/set1_" + mask_list(mask_index) + "_word " + int2str(file_index) + ".wav";
        audio_file_manipulator = AudioFileManipulator(audio_file_path);
        audio_file_manipulator.load_properties();
        audio_file_manipulator.normalize();
        disp(audio_file_path);
    
        %% load noMask audio file label
        label_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/" + mask_list(mask_index) + "_label/set1_" + mask_list(mask_index) + "_word " + int2str(file_index) + "_label.txt";
        label = sploadlabel(label_file_path, "sec");

        %% calculate basic frequencies, power spectrogram, aperiodicity parameters and save to mat file
        source_information = Harvest(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, Harvest_option);
        spectrum_parameters = CheapTrick(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, source_information, CheapTrick_option);
        aperiodicity_structure = D4C(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, source_information, D4C_option);
        
        %% calculate long term average spectrum
        gain = length(aperiodicity_structure.temporal_positions) / aperiodicity_structure.temporal_positions(end);

        for phoneme_index = 1 : (length(label) - 1)
            if sum(strcmp(label(phoneme_index).phoneme, vowels)) == 1
                start_frame = int64(label(phoneme_index).time * gain);
                end_frame = int64(label(phoneme_index + 1).time * gain);
                long_term_average_spectrum = sum(spectrum_parameters.spectrogram(:, start_frame : end_frame), 2);
                vowels_long_term_average_spectrum(mask_index, :) = vowels_long_term_average_spectrum(mask_index, :) + long_term_average_spectrum';
                total_phoneme_long_term_average_spectrum(mask_index, :) = total_phoneme_long_term_average_spectrum(mask_index, :) + long_term_average_spectrum';
                vowels_counter = vowels_counter + 1;
                vowels_column_size = vowels_column_size + int64(end_frame - start_frame + 1);
                total_phoneme_counter = total_phoneme_counter + 1;
                total_phoneme_column_size = total_phoneme_column_size + int64(end_frame - start_frame + 1);
            elseif sum(strcmp(label(phoneme_index).phoneme, consonants)) == 1
                start_frame = int64(label(phoneme_index).time * gain);
                end_frame = int64(label(phoneme_index + 1).time * gain);
                long_term_average_spectrum = sum(spectrum_parameters.spectrogram(:, start_frame : end_frame), 2);
                consonants_long_term_average_spectrum(mask_index, :) = consonants_long_term_average_spectrum(mask_index, :) + long_term_average_spectrum';
                total_phoneme_long_term_average_spectrum(mask_index, :) = total_phoneme_long_term_average_spectrum(mask_index, :) + long_term_average_spectrum';
                consonants_counter = consonants_counter + 1;
                consonants_column_size = consonants_column_size + int64(end_frame - start_frame + 1);
                total_phoneme_counter = total_phoneme_counter + 1;
                total_phoneme_column_size = total_phoneme_column_size + int64(end_frame - start_frame + 1);
            end
        end
    end
end
vowels_counter = vowels_counter / length(mask_list);
consonants_counter = consonants_counter / length(mask_list);
total_phoneme_counter = total_phoneme_counter / length(mask_list);

%% 母音に関する長時間平均スペクトルを算出する際のパラメータを設定
frequency_axis = (1 : length(vowels_long_term_average_spectrum)) ./ length(vowels_long_term_average_spectrum) .* (audio_file_manipulator.sample_rate / 2);
frequency_limit_range = [1, (audio_file_manipulator.sample_rate / 4)];
frequency_label = "Frequency [Hz]";
magnitude_label = "Magnitude [dB]";
title_label = "Comparison of long-term average spectrum related to vowels";
font_size = 30;
line_width = 3;
plot_format = ["b-", "r--"];
window_state = "maximized";
png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/vowels.png";
emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/vowels.emf";

%% 母音に関する長時間平均スペクトルを描画
window = figure;
window.WindowState = window_state;
hold on;
grid on;
xlabel(frequency_label);
ylabel(magnitude_label);
title(title_label);
xlim(frequency_limit_range);
set(gca, "FontSize", font_size);
for mask_index = 1 : length(mask_list)
    plot(frequency_axis, 10 * log10(vowels_long_term_average_spectrum(mask_index, :) ./ vowels_counter ./ double(vowels_column_size)), plot_format(mask_index), "LineWidth", line_width);
end
legend(mask_list);
saveas(gcf, png_path);
saveas(gcf, emf_path);
clf(gcf);
delete(gcf);

%% 子音に関する長時間平均スペクトルを算出する際のパラメータを設定
title_label = "Comparison of long-term average spectrum related to consonants";
png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/consonants.png";
emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/consonants.emf";

%% 子音に関する長時間平均スペクトルを描画
window = figure;
window.WindowState = window_state;
hold on;
grid on;
xlabel(frequency_label);
ylabel(magnitude_label);
title(title_label);
xlim(frequency_limit_range);
set(gca, "FontSize", font_size);
for mask_index = 1 : length(mask_list)
    plot(frequency_axis, 10 * log10(consonants_long_term_average_spectrum(mask_index, :) ./ consonants_counter ./ double(consonants_column_size)), plot_format(mask_index), "LineWidth", line_width);
end
legend(mask_list);
saveas(gcf, png_path);
saveas(gcf, emf_path);
clf(gcf);
delete(gcf);

%% 全ての音素に対する長時間平均スペクトルを描画する際のパラメータを設定
title_label = "Comparison of long-term average spectrum related to all phonemes";
png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/all_phonemes.png";
emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/LongTermAverageSpectrum/phoneme/all_phonemes.emf";

%% 全ての音素に対する長時間平均スペクトルを描画
window = figure;
window.WindowState = window_state;
hold on;
grid on;
xlabel(frequency_label);
ylabel(magnitude_label);
title(title_label);
xlim(frequency_limit_range);
set(gca, "FontSize", font_size);
for mask_index = 1 : length(mask_list)
    plot(frequency_axis, 10 * log10(total_phoneme_long_term_average_spectrum(mask_index, :) ./ total_phoneme_counter ./ double(total_phoneme_column_size)), plot_format(mask_index), "LineWidth", line_width);
end
legend(mask_list);
saveas(gcf, png_path);
saveas(gcf, emf_path);
clf(gcf);
delete(gcf);

%% 
band_point_counter = zeros(1, length(band_candidate));

%% 周波数ごとに分割された母音に関する長時間平均スペクトルを算出
for band_candidate_index = 1 : length(band_candidate)
    lower_limit_point = int64(((CheapTrick_option.fft_size / 2) + 1) * band_candidate_range(band_candidate_index, 1) / (audio_file_manipulator.sample_rate / 2)) + 1;
    upper_limit_point = int64(((CheapTrick_option.fft_size / 2) + 1) * band_candidate_range(band_candidate_index, 2) / (audio_file_manipulator.sample_rate / 2)) + 1;
    band_point_counter(band_candidate_index) = band_point_counter(band_candidate_index) + (upper_limit_point - lower_limit_point + 1);
    vowels_sub_band_long_term_average_spectrum(:, band_candidate_index) = vowels_sub_band_long_term_average_spectrum(:, band_candidate_index) + sum(vowels_long_term_average_spectrum(:, lower_limit_point : upper_limit_point), 2);
    consonants_sub_band_long_term_average_spectrum(:, band_candidate_index) = consonants_sub_band_long_term_average_spectrum(:, band_candidate_index) + sum(consonants_long_term_average_spectrum(:, lower_limit_point : upper_limit_point), 2);
    total_phoneme_sub_band_long_term_average_spectrum(:, band_candidate_index) = total_phoneme_sub_band_long_term_average_spectrum(:, band_candidate_index) + sum(total_phoneme_long_term_average_spectrum(:, lower_limit_point : upper_limit_point), 2);
end

%% 母音に関する周波数ごとの長時間平均スペクトルの差を描画する際のパラメータを設定
magnitude_label = "Spectrum difference [dB]";
title_label = "Difference of sub-band LTAS related to vowels";
png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_31/vowels.png";
emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_31/vowels.emf";

%% 母音に関する周波数ごとの長時間平均スペクトルの差を描画
window = figure;
window.WindowState = window_state;
hold on;
grid on;
xlabel(frequency_label);
ylabel(magnitude_label);
title(title_label);
set(gca, "FontSize", font_size);
bar(10 .* log10((vowels_sub_band_long_term_average_spectrum(2, :) ./ vowels_sub_band_long_term_average_spectrum(1, :))'));
xticks(1 : length(vowels_sub_band_long_term_average_spectrum));
xticklabels(band_candidate);
saveas(gcf, png_path);
saveas(gcf, emf_path);
clf(gcf);
delete(gcf);

%% 子音に関する周波数ごとの長時間平均スペクトルの差を描画する際のパラメータを設定
magnitude_label = "Spectrum difference [dB]";
title_label = "Difference of sub-band LTAS related to consonants";
png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_31/consonants.png";
emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_31/consonants.emf";

%% 子音に関する周波数ごとの長時間平均スペクトルの差を描画
window = figure;
window.WindowState = window_state;
hold on;
grid on;
xlabel(frequency_label);
ylabel(magnitude_label);
title(title_label);
set(gca, "FontSize", font_size);
bar(10 .* log10((consonants_sub_band_long_term_average_spectrum(2, :) ./ consonants_sub_band_long_term_average_spectrum(1, :))'));
xticks(1 : length(consonants_sub_band_long_term_average_spectrum));
xticklabels(band_candidate);
saveas(gcf, png_path);
saveas(gcf, emf_path);
clf(gcf);
delete(gcf);

%% 全ての音素に関する周波数ごとの長時間平均スペクトルの差を描画する際のパラメータを設定
magnitude_label = "Spectrum difference [dB]";
title_label = "Difference of sub-band LTAS related to all phonemes";
png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_31/all_phonemes.png";
emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_31/all_phonemes.emf";

%% 全ての音素に関する周波数ごとの長時間平均スペクトルの差を描画
window = figure;
window.WindowState = window_state;
hold on;
grid on;
xlabel(frequency_label);
ylabel(magnitude_label);
title(title_label);
set(gca, "FontSize", font_size);
bar(10 .* log10((total_phoneme_sub_band_long_term_average_spectrum(2, :) ./ total_phoneme_sub_band_long_term_average_spectrum(1, :))'));
xticks(1 : length(total_phoneme_sub_band_long_term_average_spectrum));
xticklabels(band_candidate);
saveas(gcf, png_path);
saveas(gcf, emf_path);
clf(gcf);
delete(gcf);
