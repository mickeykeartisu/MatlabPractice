%% initialize environments
clc;
clear variables;

%% load phoneme dictionary
phoneme_counter_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
phoneme_counter = load(phoneme_counter_path);
phoneme_counter = phoneme_counter.phoneme_counter;
phoneme_keys = keys(phoneme_counter);

%% determine each audio condition
mask_list = ["noMask", "withMask"];
spectrogram_list = ["WORLD", "TANDEM STRAIGHT"];
voicing_list = ["vowels", "consonants"];
vowel_list = ["a", "i", "u", "e", "o"];
split_dynamic_feature_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/noMask/DynamicFeature/SubBandDynamicFeature/candidate_1/WORLD/phoneme 1.mat";
split_dynamic_feature = load(split_dynamic_feature_path);
split_dynamic_feature = split_dynamic_feature.split_dynamic_feature;
split_dynamic_feature_voicing = zeros(length(mask_list), length(spectrogram_list), length(voicing_list), length(split_dynamic_feature.split_dynamic_feature_list));

%% set plot parameters
font_size = 30;
split_dynamic_feature_list = zeros(length(mask_list), length(spectrogram_list), length(phoneme_keys), length(split_dynamic_feature.split_dynamic_feature_list));

%% plot dynamic feature
for phoneme_index = 1 : length(phoneme_keys)
    for spectrogram_index = 1 : length(spectrogram_list)
        for mask_index = 1 : length(mask_list)
            split_dynamic_feature_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/DynamicFeature/SubBandDynamicFeature/candidate_1/" + spectrogram_list(spectrogram_index) + "/phoneme " + int2str(calculate_dictionary_index(phoneme_counter, phoneme_keys(phoneme_index))) + ".mat";
            split_dynamic_feature = load(split_dynamic_feature_path);
            split_dynamic_feature = split_dynamic_feature.split_dynamic_feature;
            split_dynamic_feature_list(mask_index, spectrogram_index, phoneme_index, :) =  split_dynamic_feature.split_dynamic_feature_list;
            disp(split_dynamic_feature_path);

            if sum(strcmp(phoneme_keys(phoneme_index), vowel_list)) == 1
                split_dynamic_feature_voicing(mask_index, spectrogram_index, 1, :) = split_dynamic_feature_voicing(mask_index, spectrogram_index, 1, :) + split_dynamic_feature_list(mask_index, spectrogram_index, phoneme_index, :);
            else
                split_dynamic_feature_voicing(mask_index, spectrogram_index, 2, :) = split_dynamic_feature_voicing(mask_index, spectrogram_index, 2, :) + split_dynamic_feature_list(mask_index, spectrogram_index, phoneme_index, :);

            end
        end
        window = figure;
        window.WindowState = "maximized";
        grid on;
        hold on;
        temporary_split_dynamic_feature_list = split_dynamic_feature_list(:, spectrogram_index, phoneme_index, :);
        base_bar = bar((20 / log(10)) .* squeeze(temporary_split_dynamic_feature_list)');
        base_bar(1).BaseValue = 0;
        xticks(1 : size(split_dynamic_feature_list, 4));
        xticklabels(split_dynamic_feature.band_candidate);
        title("Sub-band dynamic feature of phoneme /" + phoneme_keys(phoneme_index) + "/ " + spectrogram_list(spectrogram_index), "FontSize", font_size);
        xlabel("Frequency [Hz]", "FontSize", font_size);
        ylabel("D_\Delta(t) [dB/ms]", "FontSize", font_size);
        set(gca, "FontSize", font_size);
        legend(mask_list, "Location", "northwest");
        png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedDynamicFeature/Phoneme/" + spectrogram_list(spectrogram_index) + "/phoneme " + int2str(phoneme_index) + ".png";
        emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedDynamicFeature/Phoneme/" + spectrogram_list(spectrogram_index) + "/phoneme " + int2str(phoneme_index) + ".emf";
        saveas(gcf, png_path);
        saveas(gcf, emf_path);
        clf(gcf);
        delete(gcf);
    end
end

%% plot vowel and consonant sub band dyanamic feature
for spectrogram_index = 1 : length(spectrogram_list)
    for voicing_index = 1 : length(voicing_list)
        window = figure;
        window.WindowState = "maximized";
        grid on;
        hold on;
        if voicing_list(voicing_index) == "vowels"
            temporary_split_dynamic_feature_list = squeeze(split_dynamic_feature_voicing(:, spectrogram_index, voicing_index, :)) ./ length(vowel_list);
        elseif voicing_list(voicing_index) == "consonants"
            temporary_split_dynamic_feature_list = squeeze(split_dynamic_feature_voicing(:, spectrogram_index, voicing_index, :)) ./ (length(phoneme_keys) - length(vowel_list));
        end
        base_bar = bar((20 / log(10)) .* temporary_split_dynamic_feature_list');
        base_bar(1).BaseValue = 0;
        xticks(1 : size(temporary_split_dynamic_feature_list, 2));
        xticklabels(split_dynamic_feature.band_candidate);
        title("Sub-band dynamic feature of " + voicing_list(voicing_index), "FontSize", font_size);
        xlabel("Frequency [Hz]", "FontSize", font_size);
        ylabel("D_\Delta(t) [dB/ms]", "FontSize", font_size);
        ylim([0 0.5]);
        set(gca, "FontSize", font_size);
        legend(mask_list, "Location", "northwest");
        png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedDynamicFeature/Phoneme/" + spectrogram_list(spectrogram_index) + "/" + voicing_list(voicing_index) + ".png";
        emf_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedDynamicFeature/Phoneme/" + spectrogram_list(spectrogram_index) + "/" + voicing_list(voicing_index) + ".emf";
        saveas(gcf, png_path);
        saveas(gcf, emf_path);
        clf(gcf);
        delete(gcf);
    end
end