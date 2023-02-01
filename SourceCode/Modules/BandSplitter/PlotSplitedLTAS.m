%% initialize environments
clc;
clear variables;

phoneme_counter_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
phoneme_counter = load(phoneme_counter_path);
phoneme_counter = phoneme_counter.phoneme_counter;
phoneme_keys = keys(phoneme_counter);
mask_list = ["noMask", "withMask"];
splited_long_term = zeros(size(mask_list, 2), 31);
utterance_types = ["vowels", "consonants"];
vowels = ["a", "i", "u", "e", "o"];
sub_band_utterance_long_term_average_spectrum = zeros(length(utterance_types), length(mask_list), 31);
font_size = 30;

%% plot 31 band
for phoneme_index = 1 : length(phoneme_keys)
    for mask_index = 1 : size(mask_list, 2)
        splited_long_term_mat_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/SubBandLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".mat";
        splited_long_term_mat_file = load(splited_long_term_mat_path);
        splited_long_term(mask_index, :) = splited_long_term_mat_file.splited_long_term;

        if sum(strcmp(phoneme_keys(phoneme_index), vowels)) == 1
            sub_band_utterance_long_term_average_spectrum(1, mask_index, :) = sub_band_utterance_long_term_average_spectrum(1, mask_index, :) + reshape(splited_long_term(mask_index, :), size(sub_band_utterance_long_term_average_spectrum(1, mask_index, :)));
        else
            sub_band_utterance_long_term_average_spectrum(2, mask_index, :) = sub_band_utterance_long_term_average_spectrum(2, mask_index, :) + reshape(splited_long_term(mask_index, :), size(sub_band_utterance_long_term_average_spectrum(1, mask_index, :)));
        end
    end

    window = figure;
    window.WindowState = "maximized";
    splited_long_term_dB = 10 * log10(splited_long_term);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_1);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Magnitude of long-term average spectrum [dB]", "FontSize", font_size);
    title("Sub-band of long-term average spectrum of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10((splited_long_term(2, :) ./ splited_long_term(1, :)));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_1);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Difference of sub-band magnitude LTAS of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end

for utterance_types_index = 1 : length(utterance_types)
    window = figure;
    window.WindowState = "maximized";
    if utterance_types(utterance_types_index) == "vowels"
        t = squeeze(sub_band_utterance_long_term_average_spectrum(1, :, :)) ./ length(vowels);
    else
        t = squeeze(sub_band_utterance_long_term_average_spectrum(2, :, :)) ./ (length(phoneme_keys) - length(vowels));
    end
    splited_long_term_dB = 10 * log10(t);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_1);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Spectrum difference [dB]", "FontSize", font_size);
    title("Difference of Sub-band LTAS related to " + utterance_types(utterance_types_index), "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/" + utterance_types(utterance_types_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/" + utterance_types(utterance_types_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10(t(2, :) ./ t(1, :));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_1);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Spectrum difference [dB]", "FontSize", font_size);
    title("Difference of Sub-band LTAS related to " + utterance_types(utterance_types_index), "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/" + utterance_types(utterance_types_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/" + utterance_types(utterance_types_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end

keyboard;

%% plot 15 band
splited_long_term = zeros(size(mask_list, 2), 15);
for phoneme_index = 1 : length(phoneme_keys)
    for mask_index = 1 : size(mask_list, 2)
        splited_long_term_mat_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/SubBandLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".mat";
        splited_long_term_mat_file = load(splited_long_term_mat_path);
        splited_long_term(mask_index, :) = splited_long_term_mat_file.splited_long_term;
    end

    window = figure;
    window.WindowState = "maximized";
    splited_long_term_dB = 10 * log10(splited_long_term);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_2);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Sub-band magnitude of long-term average spectrum of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10((splited_long_term(2, :) ./ splited_long_term(1, :)));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_2);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Difference of sub-band magnitude LTAS of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end

%% plot 10 band
splited_long_term = zeros(size(mask_list, 2), 10);
for phoneme_index = 1 : length(phoneme_keys)
    for mask_index = 1 : size(mask_list, 2)
        splited_long_term_mat_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/SubBandLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".mat";
        splited_long_term_mat_file = load(splited_long_term_mat_path);
        splited_long_term(mask_index, :) = splited_long_term_mat_file.splited_long_term;
    end

    window = figure;
    window.WindowState = "maximized";
    splited_long_term_dB = 10 * log10(splited_long_term);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_3);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Magnitude of long-term average spectrum [dB]", "FontSize", font_size);
    title("Sub-band magnitude of long-term average spectrum of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10((splited_long_term(2, :) ./ splited_long_term(1, :)));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_3);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Difference of sub-band magnitude LTAS of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end

%% plot 9 band
splited_long_term = zeros(size(mask_list, 2), 9);
for phoneme_index = 1 : length(phoneme_keys)
    for mask_index = 1 : size(mask_list, 2)
        splited_long_term_mat_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/SubBandLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".mat";
        splited_long_term_mat_file = load(splited_long_term_mat_path);
        splited_long_term(mask_index, :) = splited_long_term_mat_file.splited_long_term;
    end

    window = figure;
    window.WindowState = "maximized";
    splited_long_term_dB = 10 * log10(splited_long_term);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_4);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Magnitude of long-term average spectrum [dB]", "FontSize", font_size);
    title("Sub-band magnitude of long-term average spectrum of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10((splited_long_term(2, :) ./ splited_long_term(1, :)));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_4);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Difference of sub-band magnitude LTAS of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end

%% plot 5 band candidate_5
splited_long_term = zeros(size(mask_list, 2), 5);
for phoneme_index = 1 : length(phoneme_keys)
    for mask_index = 1 : size(mask_list, 2)
        splited_long_term_mat_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/SubBandLongTermAverageSpectrum/band_" + length(splited_long_term) + "/candidate_5/phoneme " + int2str(phoneme_index) + ".mat";
        splited_long_term_mat_file = load(splited_long_term_mat_path);
        splited_long_term(mask_index, :) = splited_long_term_mat_file.splited_long_term;
    end

    window = figure;
    window.WindowState = "maximized";
    splited_long_term_dB = 10 * log10(splited_long_term);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_5);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Magnitude of long-term average spectrum [dB]", "FontSize", font_size);
    title("Sub-band magnitude of long-term average spectrum of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_5/candidate_5/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_5/candidate_5/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10((splited_long_term(2, :) ./ splited_long_term(1, :)));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_5);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Difference of sub-band magnitude LTAS of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/candidate_5/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/candidate_5/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end

%% plot 5 band candidate_6
splited_long_term = zeros(size(mask_list, 2), 5);
for phoneme_index = 1 : length(phoneme_keys)
    for mask_index = 1 : size(mask_list, 2)
        splited_long_term_mat_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/SubBandLongTermAverageSpectrum/band_" + length(splited_long_term) + "/candidate_6/phoneme " + int2str(phoneme_index) + ".mat";
        splited_long_term_mat_file = load(splited_long_term_mat_path);
        splited_long_term(mask_index, :) = splited_long_term_mat_file.splited_long_term;
    end

    window = figure;
    window.WindowState = "maximized";
    splited_long_term_dB = 10 * log10(splited_long_term);
    base_bar = bar(splited_long_term_dB');
    base_bar(1).BaseValue = -100;
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_6);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Magnitude of long-term average spectrum [dB]", "FontSize", font_size);
    title("Sub-band magnitude of long-term average spectrum of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    legend(mask_list);
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_5/candidate_6/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedLongTermAverageSpectrum/band_5/candidate_6/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);

    window = figure;
    window.WindowState = "maximized";
    diff_splited_long_term_dB = 10 * log10((splited_long_term(2, :) ./ splited_long_term(1, :)));
    bar(diff_splited_long_term_dB');
    xticks(1 : size(splited_long_term, 2));
    xticklabels(splited_long_term_mat_file.band_candidate_6);

    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Difference of long-term average spectrum [dB]", "FontSize", font_size);
    title("Difference of sub-band magnitude LTAS of phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    hold on;
    grid on;
    set(gca, "FontSize", font_size);
    output_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/candidate_6/phoneme " + int2str(phoneme_index) + ".png";
    output_emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/DifferenceOfSplittedLTAS/band_" + length(splited_long_term) + "/candidate_6/phoneme " + int2str(phoneme_index) + ".emf";
    saveas(gcf, output_png_path);
    saveas(gcf, output_emf_path);
    disp(output_png_path);
    delete(gcf);
end