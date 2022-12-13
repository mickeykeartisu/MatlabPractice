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

    %% plot noMask audio waveform
    window = figure;
    noMask_waveform_plot_path = "D:/名城大学/研究室/研究/Outputs/waveform/set1_noMask_word " + int2str(file_index) + ".png";
    time_axis = (1 : length(noMask_audio_file_manipulator.signal)) / noMask_audio_file_manipulator.sample_rate;
    font_size = 18;
    plot(time_axis, noMask_audio_file_manipulator.signal, "DisplayName", "noMask");
    window.WindowState = "maximized";
    title("Set1\_noMask\_word " + int2str(file_index), "FontSize", font_size);
    xlabel("time [s]", "FontSize", font_size);
    ylabel("linear amplitude", "FontSize", font_size);
    xlim([1.65 2.65]);
    spplotlabel(noMask_label, "r:");
    saveas(gcf, noMask_waveform_plot_path);
    delete(gcf);

    %% load withMask audio file and confirm properties
    withMask_audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/withMask/set1_withMask_word " + int2str(file_index) + ".wav";
    withMask_audio_file_manipulator = AudioFileManipulator(withMask_audio_file_path);
    withMask_audio_file_manipulator.load_properties();
    withMask_audio_file_manipulator.normalize();
    withMask_audio_file_manipulator.display_properties();

    %% load withMask audio file label
    withMask_label_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/withMask_label/set1_withMask_word " + int2str(file_index) + "_label.txt";
    withMask_label = sploadlabel(withMask_label_file_path, "sec");

    %% plot withMask audio waveform
    window = figure;
    withMask_waveform_plot_path = "D:/名城大学/研究室/研究/Outputs/waveform/set1_withMask_word " + int2str(file_index) + ".png";
    time_axis = (1 : length(withMask_audio_file_manipulator.signal)) / withMask_audio_file_manipulator.sample_rate;
    font_size = 18;
    plot(time_axis, withMask_audio_file_manipulator.signal, "DisplayName", "withMask");
    window.WindowState = "maximized";
    title("Set1\_withMask\_word " + int2str(file_index), "FontSize", font_size);
    xlabel("time [s]", "FontSize", font_size);
    ylabel("linear amplitude", "FontSize", font_size);
    xlim([1.65 2.65]);
    spplotlabel(withMask_label, "r:");
    saveas(gcf, withMask_waveform_plot_path);
    delete(gcf);
end