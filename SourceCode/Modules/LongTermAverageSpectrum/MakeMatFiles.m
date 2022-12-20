%% initialize environments
clc;
clear variables;

%% make long term average spectrum mat file
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 1
            %% load Tandem Straight spectorgram noMask mat file
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);
             
            if spectrogram_list(spectrogram_index) == "TandemStraight"
                column_size = size(spectrogram.spectrum_parameters.spectrogramSTRAIGHT, 2);
                spectrogram.long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogramSTRAIGHT, 2) ./ column_size;
            else
                column_size = size(spectrogram.spectrum_parameters.spectrogram, 2);
                spectrogram.long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogram, 2) ./ column_size;
            end
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            save(spectrogram_path, "spectrogram");
        end
    end
end

%% make long term average spectrum dictionary and count related to phoneme
phoneme_counter = dictionary("a", 0);
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load Tandem Straight spectorgram mat file
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);
            spectrogram = spectrogram.spectrogram;
        
            for phoneme_index = 1 : (length(spectrogram.label) - 1)
                if isKey(phoneme_counter, spectrogram.label(phoneme_index).phoneme)
                    phoneme_counter(spectrogram.label(phoneme_index).phoneme) = phoneme_counter(spectrogram.label(phoneme_index).phoneme) +1;
                else
                    phoneme_counter(spectrogram.label(phoneme_index).phoneme) = 1;
                end
            end
        end
    end
end
phoneme_dictionary_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
save(phoneme_dictionary_path, "phoneme_counter");
disp(phoneme_counter);

%% calculate phoneme long term average spectrum
phoneme_list_spectrum_noMask = zeros(length(keys(phoneme_counter)), length(spectrogram.long_term_average_spectrum));
phoneme_list_spectrum_withMask = zeros(length(keys(phoneme_counter)), length(spectrogram.long_term_average_spectrum));
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load Tandem Straight spectorgram mat file
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);
            spectrogram = spectrogram.spectrogram;
        
            if mask_list(mask_index) == "noMask"
                if spectrogram_list(spectrogram_index) == "TandemStraight"
                    for phoneme_index = 1 : (length(spectrogram.label) - 1)
                        gain = length(spectrogram.aperiodicity_structure.temporalPositions) / spectrogram.aperiodicity_structure.temporalPositions(end);
                        start_frame = int32(spectrogram.label(phoneme_index).time * gain);
                        end_frame = int32(spectrogram.label(phoneme_index + 1).time * gain);
                        column_size = size(spectrogram.spectrum_parameters.spectrogramSTRAIGHT, 2);
                        long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogramSTRAIGHT(:, start_frame : end_frame), 2) / column_size;
                        phoneme_list_spectrum_noMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) = phoneme_list_spectrum_noMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) + long_term_average_spectrum';
                    end
                elseif spectrogram_list(spectrogram_index) == "World"
                    for phoneme_index = 1 : (length(spectrogram.label) - 1)
                        gain = length(spectrogram.aperiodicity_structure.temporal_positions) / spectrogram.aperiodicity_structure.temporal_positions(end);
                        start_frame = int32(spectrogram.label(phoneme_index).time * gain);
                        end_frame = int32(spectrogram.label(phoneme_index + 1).time * gain);
                        column_size = size(spectrogram.spectrum_parameters.spectrogram, 2);      
                        long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogram(:, start_frame : end_frame), 2) ./ column_size;
                        phoneme_list_spectrum_noMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) = phoneme_list_spectrum_noMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) + long_term_average_spectrum';
                    end
                end
            elseif mask_list(mask_index) == "withMask"
                if spectrogram_list(spectrogram_index) == "TandemStraight"
                    for phoneme_index = 1 : (length(spectrogram.label) - 1)
                        gain = length(spectrogram.aperiodicity_structure.temporalPositions) / spectrogram.aperiodicity_structure.temporalPositions(end);
                        start_frame = int32(spectrogram.label(phoneme_index).time * gain);
                        end_frame = int32(spectrogram.label(phoneme_index + 1).time * gain);
                        column_size = size(spectrogram.spectrum_parameters.spectrogramSTRAIGHT, 2);      
                        long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogramSTRAIGHT(:, start_frame : end_frame), 2) ./ column_size;
                        phoneme_list_spectrum_withMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) = phoneme_list_spectrum_withMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) + long_term_average_spectrum';
                    end
                elseif spectrogram_list(spectrogram_index) == "World"
                    for phoneme_index = 1 : (length(spectrogram.label) - 1)
                        gain = length(spectrogram.aperiodicity_structure.temporal_positions) / spectrogram.aperiodicity_structure.temporal_positions(end);
                        start_frame = int32(spectrogram.label(phoneme_index).time * gain);
                        end_frame = int32(spectrogram.label(phoneme_index + 1).time * gain);
                        column_size = size(spectrogram.spectrum_parameters.spectrogram, 2);      
                        long_term_average_spectrum = sum(spectrogram.spectrum_parameters.spectrogram(:, start_frame : end_frame), 2) ./ column_size;
                        phoneme_list_spectrum_withMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) = phoneme_list_spectrum_withMask(calculate_dictionary_index(phoneme_counter, spectrogram.label(phoneme_index).phoneme), :) + long_term_average_spectrum';
                    end
                end
            end
        end
    end
end

keys_list = keys(phoneme_counter);
for mask_index = 1 : length(mask_list)
    for phoneme_index = 1 : length(keys_list)
        sample_rate = spectrogram.sample_rate;
        if mask_list(mask_index) == "noMask"
            phoneme_long_term_average_spectrum = phoneme_list_spectrum_noMask(calculate_dictionary_index(phoneme_counter, keys_list(phoneme_index)), :) / (phoneme_counter(keys_list(phoneme_index)) / 2);
            phoneme = keys_list(phoneme_index);
            phoneme_long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
            save(phoneme_long_term_average_spectrum_path, "phoneme_long_term_average_spectrum", "phoneme", "sample_rate");
        elseif mask_list(mask_index) == "withMask"
            phoneme_long_term_average_spectrum = phoneme_list_spectrum_withMask(calculate_dictionary_index(phoneme_counter, keys_list(phoneme_index)), :) / (phoneme_counter(keys_list(phoneme_index)) / 2);
            phoneme = keys_list(phoneme_index);
            phoneme_long_term_average_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/LongTermAverageSpectrum/phoneme/phoneme_index " + int2str(phoneme_index) + ".mat";
            save(phoneme_long_term_average_spectrum_path, "phoneme_long_term_average_spectrum", "phoneme", "sample_rate");
        end
    end
end