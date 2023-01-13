%% initialize environments
clc;
clear variables;


%% set band split freqeuncy candidates
band_candidate_1 = [20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000];
band_candidate_2 = [25, 40, 63, 100, 160, 250, 400, 630, 1000, 1600, 2500, 4000, 6300, 10000, 16000];
band_candidate_3 = [31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];
band_candidate_4 = [20, 800, 2500, 4000, 5000, 6300, 8000, 10000, 12500];
band_candidate_5 = [20, 100, 500, 2500, 12500];
band_candidate_6 = [20, 630, 4000, 8000, 12500];


%% calculate band candidate range
band_candidate_range_1 = calculate_center_frequency_range(band_candidate_1);
band_candidate_range_2 = calculate_center_frequency_range(band_candidate_2);
band_candidate_range_3 = calculate_center_frequency_range(band_candidate_3);
band_candidate_range_4 = calculate_center_frequency_range(band_candidate_4);
band_candidate_range_5 = calculate_center_frequency_range(band_candidate_5);
band_candidate_range_6 = calculate_center_frequency_range(band_candidate_6);

%% calculate difference of band splitted frequency related to each phoneme
phoneme_counter_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
phoneme_counter = load(phoneme_counter_path);
phoneme_counter = phoneme_counter.phoneme_counter;
phoneme_keys = keys(phoneme_counter);
mask_list = ["noMask", "withMask"];
mean_frequency_list = zeros(size(band_candidate_1, 2), 1);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(phoneme_keys)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;

        for band_candidate_index = 1 : size(band_candidate_1, 2)
            lower_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_1(band_candidate_index, 1) / 24000);
            upper_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_1(band_candidate_index, 2) / 24000);
            mean_frequency_list(band_candidate_index) = mean(phoneme_long_term_average_spectrum(lower_limit_point : upper_limit_point));
        end

        splited_long_term = mean_frequency_list;
        splited_long_term_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/SpliteLongTermAverageSpectrum/band_" + length(band_candidate_1) + "/phoneme " + int2str(phoneme_index) + ".mat";
        save(splited_long_term_path, "splited_long_term", "band_candidate_1", "band_candidate_range_1");
        disp(splited_long_term_path);
    end
end

%% calculate difference of band splitted frequency related to each phoneme
mean_frequency_list = zeros(size(band_candidate_2, 2), 1);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(phoneme_keys)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;

        for band_candidate_index = 1 : size(band_candidate_2, 2)
            lower_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_2(band_candidate_index, 1) / 24000);
            upper_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_2(band_candidate_index, 2) / 24000);
            mean_frequency_list(band_candidate_index) = mean(phoneme_long_term_average_spectrum(lower_limit_point : upper_limit_point));
        end

        splited_long_term = mean_frequency_list;
        splited_long_term_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/SpliteLongTermAverageSpectrum/band_" + length(band_candidate_2) + "/phoneme " + int2str(phoneme_index) + ".mat";
        save(splited_long_term_path, "splited_long_term", "band_candidate_2", "band_candidate_range_2");
        disp(splited_long_term_path);
    end
end


%% calculate difference of band splitted frequency related to each phoneme
mean_frequency_list = zeros(size(band_candidate_3, 2), 1);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(phoneme_keys)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;

        for band_candidate_index = 1 : size(band_candidate_3, 2)
            lower_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_3(band_candidate_index, 1) / 24000);
            upper_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_3(band_candidate_index, 2) / 24000);
            mean_frequency_list(band_candidate_index) = mean(phoneme_long_term_average_spectrum(lower_limit_point : upper_limit_point));
        end

        splited_long_term = mean_frequency_list;
        splited_long_term_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/SpliteLongTermAverageSpectrum/band_" + length(band_candidate_3) + "/phoneme " + int2str(phoneme_index) + ".mat";
        save(splited_long_term_path, "splited_long_term", "band_candidate_3", "band_candidate_range_3");
        disp(splited_long_term_path);
    end
end

%% calculate difference of band splitted frequency related to each phoneme
mean_frequency_list = zeros(size(band_candidate_4, 2), 1);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(phoneme_keys)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;

        for band_candidate_index = 1 : size(band_candidate_4, 2)
            lower_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_4(band_candidate_index, 1) / 24000);
            upper_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_4(band_candidate_index, 2) / 24000);
            mean_frequency_list(band_candidate_index) = mean(phoneme_long_term_average_spectrum(lower_limit_point : upper_limit_point));
        end

        splited_long_term = mean_frequency_list;
        splited_long_term_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/SpliteLongTermAverageSpectrum/band_" + length(band_candidate_4) + "/phoneme " + int2str(phoneme_index) + ".mat";
        save(splited_long_term_path, "splited_long_term", "band_candidate_4", "band_candidate_range_4");
        disp(splited_long_term_path);
    end
end

%% calculate difference of band splitted frequency related to each phoneme
mean_frequency_list = zeros(size(band_candidate_5, 2), 1);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(phoneme_keys)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;

        for band_candidate_index = 1 : size(band_candidate_5, 2)
            lower_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_5(band_candidate_index, 1) / 24000);
            upper_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_5(band_candidate_index, 2) / 24000);
            mean_frequency_list(band_candidate_index) = mean(phoneme_long_term_average_spectrum(lower_limit_point : upper_limit_point));
        end

        splited_long_term = mean_frequency_list;
        splited_long_term_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/SpliteLongTermAverageSpectrum/band_" + length(band_candidate_5) + "/candidate_5/phoneme " + int2str(phoneme_index) + ".mat";
        save(splited_long_term_path, "splited_long_term", "band_candidate_5", "band_candidate_range_5");
        disp(splited_long_term_path);
    end
end

%% calculate difference of band splitted frequency related to each phoneme
mean_frequency_list = zeros(size(band_candidate_6, 2), 1);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(phoneme_keys)
        long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        long_term_average_spectrum = load(long_term_average_spectrum_path);
        phoneme_long_term_average_spectrum = long_term_average_spectrum.phoneme_long_term_average_spectrum;

        for band_candidate_index = 1 : size(band_candidate_6, 2)
            lower_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_6(band_candidate_index, 1) / 24000);
            upper_limit_point = int64(size(phoneme_long_term_average_spectrum, 2) * band_candidate_range_6(band_candidate_index, 2) / 24000);
            mean_frequency_list(band_candidate_index) = mean(phoneme_long_term_average_spectrum(lower_limit_point : upper_limit_point));
        end

        splited_long_term = mean_frequency_list;
        splited_long_term_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/SpliteLongTermAverageSpectrum/band_" + length(band_candidate_6) + "/candidate_6/phoneme " + int2str(phoneme_index) + ".mat";
        save(splited_long_term_path, "splited_long_term", "band_candidate_6", "band_candidate_range_6");
        disp(splited_long_term_path);
    end
end