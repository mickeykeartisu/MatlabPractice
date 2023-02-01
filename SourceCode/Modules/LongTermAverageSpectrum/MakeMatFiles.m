%% initialize environments
clc;
clear variables;

%% 長時間平均スペクトルを算出する際のパラメータ
mask_list = ["noMask", "withMask"];
spectrogram_list = ["WORLD", "TANDEM STRAIGHT"];

%% WORLDとTANDEM STRAIGHTに関するそれぞれの長時間平均スペクトルを算出してmatファイルに保存する
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 1
            %% load Tandem Straight spectorgram noMask mat file
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);
            
            %% calculate long temr average spectrum
            if spectrogram_list(spectrogram_index) == "TANDEM STRAIGHT"
                column_size = size(spectrogram.spectrum_parameters.spectrogramTANDEM, 2);
                spectrogram.long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogramTANDEM, 2) ./ column_size;
            elseif spectrogram_list(spectrogram_index) == "WORLD"
                column_size = size(spectrogram.spectrum_parameters.spectrogram, 2);
                spectrogram.long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogram, 2) ./ column_size;
            end

            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            save(spectrogram_path, "spectrogram", "spectrogram_path");
            disp(spectrogram_path);
        end
    end
end

%% 音素の出現回数を保持する辞書を作成するしてmatファイルに保存する
phoneme_counter = dictionary("a", 0);
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load Tandem Straight spectorgram mat file
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);
            spectrogram = spectrogram.spectrogram;
            disp(spectrogram_path);
        
            for phoneme_index = 1 : (length(spectrogram.label) - 1)
                if isKey(phoneme_counter, spectrogram.label(phoneme_index).phoneme)
                    phoneme_counter(spectrogram.label(phoneme_index).phoneme) = phoneme_counter(spectrogram.label(phoneme_index).phoneme) + 1;
                else
                    phoneme_counter(spectrogram.label(phoneme_index).phoneme) = 1;
                end
            end
        end
    end
end
keys_list = keys(phoneme_counter);
for phoneme_index = 1 : length(keys_list)
    phoneme_counter(keys_list(phoneme_index)) = int64(phoneme_counter(keys_list(phoneme_index)) ./ (length(mask_list) * length(spectrogram_list)));
end
phoneme_dictionary_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
save(phoneme_dictionary_path, "phoneme_counter", "phoneme_dictionary_path");
disp(phoneme_counter);

%% 音素ごとの長時間平均スペクトルを求める
phoneme_long_term_average_spectrum_list = zeros(length(mask_list), length(spectrogram_list), length(keys_list), length(spectrogram.long_term_average_spectrum));
reshape_size = size(phoneme_long_term_average_spectrum_list(1, 1, 1, :));
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load Tandem Straight spectorgram mat file
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);
            spectrogram = spectrogram.spectrogram;
            disp(spectrogram_path);

            if spectrogram_list(spectrogram_index) == "WORLD"
                for phoneme_index = 1 : (length(spectrogram.label) - 1)
                    gain = length(spectrogram.aperiodicity_structure.temporal_positions) / spectrogram.aperiodicity_structure.temporal_positions(end);
                    start_frame = int64(spectrogram.label(phoneme_index).time * gain);
                    end_frame = int64(spectrogram.label(phoneme_index + 1).time * gain);
                    column_size = size(spectrogram.spectrum_parameters.spectrogram, 2);
                    long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogram(:, start_frame : end_frame), 2) ./ column_size;
                    long_term_average_spectrum = reshape(long_term_average_spectrum, reshape_size);
                    phoneme_long_term_average_spectrum_list(mask_index, spectrogram_index, calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) = phoneme_long_term_average_spectrum_list(mask_index, spectrogram_index, calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) + long_term_average_spectrum;
                end
            elseif spectrogram_list(spectrogram_index) == "TANDEM STRAIGHT"
                for phoneme_index = 1 : (length(spectrogram.label) - 1)
                    gain = length(spectrogram.aperiodicity_structure.temporalPositions) / spectrogram.aperiodicity_structure.temporalPositions(end);
                    start_frame = int64(spectrogram.label(phoneme_index).time * gain);
                    end_frame = int64(spectrogram.label(phoneme_index + 1).time * gain);
                    column_size = size(spectrogram.spectrum_parameters.spectrogramSTRAIGHT, 2);
                    long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogramTANDEM(:, start_frame : end_frame), 2) ./ column_size;
                    long_term_average_spectrum = reshape(long_term_average_spectrum, size(phoneme_long_term_average_spectrum_list(1, 1, 1, :)));
                    phoneme_long_term_average_spectrum_list(mask_index, spectrogram_index, calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) = phoneme_long_term_average_spectrum_list(mask_index, spectrogram_index, calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) + long_term_average_spectrum;
                end
            end
        end
    end
end

%% 音素ごとの長時間平均スペクトルをmatファイルに保存する
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(keys_list)
        sample_rate = spectrogram.sample_rate;
        long_term_average_spectrum_phoneme = phoneme_long_term_average_spectrum_list(mask_index, 1, phoneme_index, :);
        phoneme_long_term_average_spectrum_list = squeeze(phoneme_long_term_average_spectrum_list);
        phoneme = keys_list(phoneme_index);
        phoneme_long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
        save(phoneme_long_term_average_spectrum_path, "long_term_average_spectrum_phoneme", "phoneme", "sample_rate", "phoneme_index");
        disp(phoneme_long_term_average_spectrum_path);
    end
end

%% save long term average spectrum related to each mask condition
%% save long term average spectrum related to each mask condition