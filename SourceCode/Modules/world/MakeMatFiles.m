%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 1
        %% load noMask audio file and confirm properties
        audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/" + mask_list(mask_index) + "/set1_" + mask_list(mask_index) + "_word " + int2str(file_index) + ".wav";
        audio_file_manipulator = AudioFileManipulator(audio_file_path);
        audio_file_manipulator.load_properties();
        audio_file_manipulator.normalize();
        audio_file_manipulator.display_properties();
    
        %% load noMask audio file label
        label_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/" + mask_list(mask_index) + "_label/set1_" + mask_list(mask_index) + "_word " + int2str(file_index) + "_label.txt";
        label = sploadlabel(label_file_path, "sec");
    
        %% calculate basic frequencies, power spectrogram, aperiodicity parameters and save to mat file
        mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/World/word " + int2str(file_index) + ".mat";
        Harvest_option.f0_floor = 175;  % F3
        Harvest_option.f0_ceil = 265;   % C4
        source_information = Harvest(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, Harvest_option);
        CheapTrick_option.fft_size = (2 ^ 12);
        spectrum_parameters = CheapTrick(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, source_information, CheapTrick_option);
        D4C_option.fft_size = CheapTrick_option.fft_size;
        aperiodicity_structure = D4C(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, source_information, D4C_option);
        signal = audio_file_manipulator.signal;
        sample_rate = audio_file_manipulator.sample_rate;
        save(mat_file_path, "signal", "sample_rate", "source_information", "aperiodicity_structure", "spectrum_parameters", "label");
    end
end