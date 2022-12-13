%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
for file_index = 1 : 50
    %% load noMask audio file and confirm properties
    noMask_audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/noMask/set1_noMask_word " + int2str(file_index) + ".wav";
    noMask_audio_file_manipulator = AudioFileManipulator(noMask_audio_file_path);
    noMask_audio_file_manipulator.load_properties();
    noMask_audio_file_manipulator.normalize();
    noMask_audio_file_manipulator.display_properties();

    %% load noMask audio file label
    noMask_label_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/noMask_label/set1_noMask_word " + int2str(file_index) + "_label.txt";
    noMask_label = sploadlabel(noMask_label_file_path, "sec");

    %% calculate basic frequencies, power spectrogram, aperiodicity parameters and save to mat file
    noMask_mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/noMask/PowerSpectrogram/set1_noMask_word " + int2str(file_index) + ".mat";
    Harvest_option.f0_floor = 110;
    Harvest_option.f0_ceil = 440;
    basic_frequencies = Harvest(noMask_audio_file_manipulator.signal, noMask_audio_file_manipulator.sample_rate, Harvest_option);
    CheapTrick_option.fft_size = (2 ^ 16);
    power_spectrogram = CheapTrick(noMask_audio_file_manipulator.signal, noMask_audio_file_manipulator.sample_rate, basic_frequencies, CheapTrick_option);
    D4C_option.fft_size = CheapTrick_option.fft_size;
    aperiodicity_parameters = D4C(noMask_audio_file_manipulator.signal, noMask_audio_file_manipulator.sample_rate, basic_frequencies, D4C_option);
    signal = noMask_audio_file_manipulator.signal;
    sample_rate = noMask_audio_file_manipulator.sample_rate;
    save(noMask_mat_file_path, "signal", "sample_rate", "basic_frequencies", "power_spectrogram", "aperiodicity_parameters", "noMask_label");

    %% load withMask audio file and confirm properties
    withMask_audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/withMask/set1_withMask_word " + int2str(file_index) + ".wav";
    withMask_audio_file_manipulator = AudioFileManipulator(withMask_audio_file_path);
    withMask_audio_file_manipulator.load_properties();
    withMask_audio_file_manipulator.normalize();
    withMask_audio_file_manipulator.display_properties();

    %% load withMask audio file label
    withMask_label_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/withMask_label/set1_withMask_word " + int2str(file_index) + "_label.txt";
    withMask_label = sploadlabel(withMask_label_file_path, "sec");

    %% calculate basic frequencies, power spectrogram, aperiodicity parameters and save to mat file
    withMask_mat_file_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/withMask/PowerSpectrogram/set1_withMask_word " + int2str(file_index) + ".mat";
    Harvest_option.f0_floor = 110;
    Harvest_option.f0_ceil = 440;
    basic_frequencies = Harvest(withMask_audio_file_manipulator.signal, withMask_audio_file_manipulator.sample_rate, Harvest_option);
    CheapTrick_option.fft_size = (2 ^ 16);
    power_spectrogram = CheapTrick(withMask_audio_file_manipulator.signal, withMask_audio_file_manipulator.sample_rate, basic_frequencies, CheapTrick_option);
    D4C_option.fft_size = CheapTrick_option.fft_size;
    aperiodicity_parameters = D4C(withMask_audio_file_manipulator.signal, withMask_audio_file_manipulator.sample_rate, basic_frequencies, D4C_option);
    signal = withMask_audio_file_manipulator.signal;
    sample_rate = withMask_audio_file_manipulator.sample_rate;
    save(withMask_mat_file_path, "signal", "sample_rate", "basic_frequencies", "power_spectrogram", "aperiodicity_parameters", "withMask_label");
end