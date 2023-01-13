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
spectrogram_list = ["World", "TandemStraight"];

%% set plot parameters
font_size = 24;

%% plot dynamic feature
for phoneme_index = 1 : length(phoneme_keys)
    split_dynamic_feature_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/noMask/DynamicFeature/Split/candidate_1/World/phoneme 1.mat";
    split_dynamic_feature = load(split_dynamic_feature_path);
    split_dynamic_feature = split_dynamic_feature.split_dynamic_feature;
    split_dynamic_feature_list = zeros(length(mask_list), length(split_dynamic_feature.split_dynamic_feature_list));
    for mask_index = 1 : length(mask_list)
        for spectrogram_index = 1 : length(spectrogram_list)
            split_dynamic_feature_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/DynamicFeature/Split/candidate_1/" + spectrogram_list(spectrogram_index) + "/phoneme " + int2str(calculate_dictionary_index(phoneme_counter, phoneme_keys(phoneme_index))) + ".mat";
            split_dynamic_feature = load(split_dynamic_feature_path);
            split_dynamic_feature = split_dynamic_feature.split_dynamic_feature;
            split_dynamic_feature_list(mask_index, :) =  split_dynamic_feature_list(mask_index, :) + split_dynamic_feature.split_dynamic_feature_list;
            disp(split_dynamic_feature_path);
        end
    end

    split_dynamic_feature_list = split_dynamic_feature_list / length(spectrogram_list);
    window = figure;
    window.WindowState = "maximized";
    grid on;
    hold on;
    base_bar = bar(split_dynamic_feature_list');
    base_bar(1).BaseValue = 0;
    xticks(1 : size(split_dynamic_feature_list, 2));
    xticklabels(split_dynamic_feature.band_candidate);
    title("Sub band dynamic feature phoneme /" + phoneme_keys(phoneme_index) + "/", "FontSize", font_size);
    xlabel("Frequency [Hz]", "FontSize", font_size);
    ylabel("Dynamic feature magnitude [dB/ms]", "FontSize", font_size);
    set(gca, "FontSize", font_size);
    legend("noMask", "withMask");
    png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/both/SplitedDynamicFeature/Phoneme/phoneme " + int2str(phoneme_index) + ".png";
    saveas(gcf, png_path);
    clf(gcf);
    delete(gcf);
end