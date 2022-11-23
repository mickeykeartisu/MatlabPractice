%% clear cache
clc;
clear variables;

%% set AudioFileManipulator class parameters
input_file_path = "vaiueo2d.wav";
output_file_path = "D:/名城大学/研究室/演習/data/LinearPredictiveCoding/synthesized_signal_by_LPCVocoder.wav";

%% generate AudioFileManipulator instance and confirm properties
audio_file_manipulator = AudioFileManipulator(input_file_path, output_file_path);
audio_file_manipulator.load_properties();
audio_file_manipulator.display_properties();

hold on;
grid on;
title("Difference of Order relating to basic frequency with Linear Predictive Coding");
xlabel("Time [s]");
ylabel("Basic Frequency [Hz]");
legend;

%% generate LPCVocoder instance
order_list = [5, 10, 20];
for order_index = 1 : length(order_list)
    linear_predictive_coding_pitch_extractor = LinearPredictiveCodingPitchExtractor(audio_file_manipulator.signal, audio_file_manipulator.information.SampleRate, "hamming", order_list(order_index), 0.25);
    linear_predictive_coding_pitch_extractor.display_properties();
    plot((1 : length(linear_predictive_coding_pitch_extractor.basic_frequencies)) / length(linear_predictive_coding_pitch_extractor.basic_frequencies) * length(audio_file_manipulator.signal) / audio_file_manipulator.information.SampleRate, linear_predictive_coding_pitch_extractor.basic_frequencies, "DisplayName", "order : " + int2str(order_list(order_index)));
end

saveas(gcf, "D:/名城大学/研究室/演習/data/LinearPredictiveCoding/Difference_of_Order_relating_to_basic_frequency.png");
