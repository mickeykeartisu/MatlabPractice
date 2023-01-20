%% initialize environments
clc;
clear variables;

%% make TANDEM STRAIGHT spectrogram mat file related to each mask condition with 4 mora word list
mask_list = ["noMask", "withMask"];
for mask_index = 1 : length(mask_list)
    for file_index = 1 : 50
        %% load noMask audio file and confirm properties
        audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/" + mask_list(mask_index) + "/set1_" + mask_list(mask_index) + "_word " + int2str(file_index) + ".wav";
        audio_file_manipulator = AudioFileManipulator(audio_file_path);
        audio_file_manipulator.load_properties();
        audio_file_manipulator.normalize();
        audio_file_manipulator.display_properties();
    
        %% load noMask audio file label
        label_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/" + mask_list(mask_index) + "_label/set1_" + mask_list(mask_index) + "_word " + int2str(file_index) + "_label.txt";
        label = sploadlabel(label_file_path, "sec");
    
        %% calculate spectrogram and save to mat file
        mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/Spectrogram/TANDEM STRAIGHT/word " + int2str(file_index) + ".mat";
        optional_parameters.f0floor = 175;  % F3
        optional_parameters.f0ceil = 265;   % C4
        optional_parameters.FFTsize = (2 ^ 13);
        source_information = exF0candidatesTSTRAIGHTGB(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, optional_parameters);
        fixed_source_information = autoF0Tracking(source_information, audio_file_manipulator.signal);
        fixed_source_information.vuv = refineVoicingDecision(audio_file_manipulator.signal, fixed_source_information);
        aperiodicity_structure = aperiodicityRatioSigmoid(audio_file_manipulator.signal, fixed_source_information, 1, 2, 0);
        spectrum_parameters = exSpectrumTSTRAIGHTGB(audio_file_manipulator.signal, audio_file_manipulator.sample_rate, aperiodicity_structure, optional_parameters);
        STRAIGHT_object.waveform = audio_file_manipulator.signal;
        STRAIGHT_object.samplingFrequency = audio_file_manipulator.sample_rate;
        STRAIGHT_object.refinedF0Structure.temporalPositions = source_information.temporalPositions;
        STRAIGHT_object.SpectrumStructure.spectrogramSTRAIGHT = spectrum_parameters.spectrogramSTRAIGHT;
        STRAIGHT_object.refinedF0Structure.vuv = fixed_source_information.vuv;
        spectrum_parameters.spectrogramSTRAIGHT = unvoicedProcessing(STRAIGHT_object);
        signal = audio_file_manipulator.signal;
        sample_rate = audio_file_manipulator.sample_rate;
    
        save(mat_file_path, "signal", "sample_rate", "source_information", "fixed_source_information", "aperiodicity_structure", "spectrum_parameters", "label", "audio_file_manipulator", "optional_parameters", "label_file_path", "audio_file_path");
    end
end