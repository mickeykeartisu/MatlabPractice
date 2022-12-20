%% initialize environments
clc;
clear variables;

%% calculate modulation frequency spectrum each conditions
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1: length(spectrogram_list)
        for file_index = 1 : 1
            spectrogram_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(spectrogram_path);

            if spectrogram_list(spectrogram_index) == "TandemStraight"
                modulation_frequency_spectrum = calculate_modulation_frequency_spectrum(spectrogram.spectrum_parameters.spectrogramSTRAIGHT);
            elseif spectrogram_list(spectrogram_index) == "World"
                modulation_frequency_spectrum = calculate_modulation_frequency_spectrum(spectrogram.spectrum_parameters.spectrogram);
            end

            modulation_frequency_spectrum_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/ModulationFrequencySpectrum/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            sample_rate = spectrogram.sample_rate;
            save(modulation_frequency_spectrum_path, "modulation_frequency_spectrum", "sample_rate");
        end
    end
end