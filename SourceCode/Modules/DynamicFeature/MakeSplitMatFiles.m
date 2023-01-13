%% initialize environments
clc;
clear variables;

%% load phoneme dictionary
phoneme_counter_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
phoneme_counter = load(phoneme_counter_path);
phoneme_counter = phoneme_counter.phoneme_counter;
phoneme_keys = keys(phoneme_counter);

%% determine split band list
band_candidate = [20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000];
band_candidate_range = calculate_center_frequency_range(band_candidate);

%% determine each audio condition
mask_list = ["noMask", "withMask"];
spectrogram_list = ["World", "TandemStraight"];

%% make split mat file
for mask_index = 1 : length(mask_list)
    split_dynamic_feature_list = zeros(length(phoneme_keys), size(band_candidate, 2));
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            spectrogram_mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_mat_file_path);
            disp(spectrogram_mat_file_path);
            for band_candidate_index = 1 : length(band_candidate)
                %% extract split range spectrogram
                if spectrogram_list(spectrogram_index) == "World"
                    split_spectrogram = spectrogram.spectrum_parameters.spectrogram;
                else
                    split_spectrogram = spectrogram.spectrum_parameters.spectrogramTANDEM;
                end
        
                %% calculate dynamic feature
                delta_cepstrum_prameters.msdceptime = 50;
                liftering_order = delta_cepstrum_prameters.msdceptime - 5;
                fft_point = 2 ^ 11;
                cepstrum = getSt2Cep(split_spectrogram, liftering_order);
                delta_cepstrum = getDeltaCep4(cepstrum, delta_cepstrum_prameters);
                delta_cepstrum = abs(fft(delta_cepstrum, fft_point));
                lower_limit_point = int64(length(delta_cepstrum) * band_candidate_range(band_candidate_index, 1) / (spectrogram.sample_rate / 2));
                upper_limit_point = int64(length(delta_cepstrum) * band_candidate_range(band_candidate_index, 2) / (spectrogram.sample_rate / 2));
                delta_cepstrum = delta_cepstrum(lower_limit_point : upper_limit_point, :);
                delta_cepstrum = ifft(delta_cepstrum);
                delta_cepstrum = trunc2(delta_cepstrum, round(delta_cepstrum_prameters.msdceptime / 2), 2, 'both', 1, nan);
                dynamic_feature = getDcepNorm_ver2(delta_cepstrum, 1);
        
                %% add dynamic feature mean related to each phoneme
                for phoneme_index = 1 : length(spectrogram.label) - 1
                    duration = length(spectrogram.signal) / spectrogram.sample_rate;
                    lower_limit_point = int64(length(dynamic_feature) * spectrogram.label(phoneme_index).time / duration);
                    upper_limit_point = int64(length(dynamic_feature) * spectrogram.label(phoneme_index + 1).time / duration);
        
                    key_index = calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme);
                    split_dynamic_feature_list(key_index, band_candidate_index) = split_dynamic_feature_list(key_index, band_candidate_index) + mean(dynamic_feature(lower_limit_point : upper_limit_point));
                end
            end
        end
        
        %% save dynamic_feature related to each phoneme
        for key_index = 1 : length(phoneme_keys)
            split_dynamic_feature.split_dynamic_feature_list = split_dynamic_feature_list(key_index, :) ./ (phoneme_counter(phoneme_keys(key_index)) / 2);
            split_dynamic_feature.band_candidate = band_candidate;
            split_dynamic_feature.band_candidate_range = band_candidate_range;
            split_dynamic_feature.counter = int64((phoneme_counter(phoneme_keys(key_index)) / 4));
        
            split_dynamic_feature_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/DynamicFeature/Split/candidate_1/" + spectrogram_list(spectrogram_index) + "/phoneme " + int2str(calculate_dictionary_index(phoneme_counter, phoneme_keys(key_index))) + ".mat";
            save(split_dynamic_feature_path, "split_dynamic_feature");
            disp(split_dynamic_feature_path);
        end
    end
end