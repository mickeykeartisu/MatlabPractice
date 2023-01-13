%% initialize environments
clc;
clear variables;

%% load audio file
audio_file_path = "D:/名城大学/研究室/研究/Sources/AudioData/4モーラ単語リスト/Set 1/noMask/set1_noMask_word 1.wav";
audio_file_manipulator = AudioFileManipulator(audio_file_path);
audio_file_manipulator.load_properties();
audio_file_manipulator.normalize();
audio_file_manipulator.display_properties();

%% calculate fft_point
fft_point = 1;
while fft_point < audio_file_manipulator.information.TotalSamples
    fft_point = fft_point * 2;
end