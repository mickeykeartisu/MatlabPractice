%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load spectrogram mat file and calculate dynamic feature
            mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            spectrogram = load(mat_file_path);
            delta_cepstrum_prameters.msdceptime = 50;
            liftering_order = delta_cepstrum_prameters.msdceptime - 5;
            if spectrogram_list(spectrogram_index) == "TandemStraight"
                cepstrum = getSt2Cep(spectrogram.spectrum_parameters.spectrogramTANDEM, liftering_order);
            else
                cepstrum = getSt2Cep(spectrogram.spectrum_parameters.spectrogram, liftering_order);
            end
            delta_cepstrum = getDeltaCep4(cepstrum, delta_cepstrum_prameters);
            delta_cepstrum = trunc2(delta_cepstrum, round(delta_cepstrum_prameters.msdceptime / 2), 2, 'both', 1, nan);
            dynamic_feature = getDcepNorm_ver2(delta_cepstrum, 1);
        
            dynamic_feature_mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/DynamicFeature/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            save(dynamic_feature_mat_file_path, "spectrogram", "delta_cepstrum_prameters", "liftering_order", "cepstrum", "delta_cepstrum", "dynamic_feature");
        end
    end
end