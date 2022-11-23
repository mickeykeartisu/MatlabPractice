%% initialize environments
clc;
clear variables;

%% set AudioFileManipulator class parameters
input_file_path = "vaiueo2d.wav";

%% generate AudioFileManipulator instance and confirm properties
audio_file_manipulator = AudioFileManipulator(input_file_path);
audio_file_manipulator.load_properties();
audio_file_manipulator.display_properties();

start_point = 3748;  % あのスタート位置
continue_time = 32; % [ms]
continue_point = int32(continue_time * audio_file_manipulator.information.SampleRate / 1000);

%% generate AutocorrelationFunciton instance and confirm properties
autocorrelation_function = AutocorrelationFunction(audio_file_manipulator.signal(start_point : start_point + continue_point - 1));
autocorrelation_function.calculate_autocorrelation_with_fourier();
autocorrelation_function.display_properties();

%% generate LPCVocoder instance
lpc_vocoder = LinearPredictiveCodingVocoder(audio_file_manipulator.signal(start_point : start_point + continue_point - 1), audio_file_manipulator.information.SampleRate);
lpc_vocoder.display_properties();

%% generate PartialAutocorrelationCoefficientVocoder instance and confirm properties
partial_autocorrelation_coefficient_vocoder = PartialAutocorrelationCoefficientVocoder(autocorrelation_function.autocorrelation);
partial_autocorrelation_coefficient_vocoder.display_properties();

%% set plot parameters
hold on;
grid on;
title("impulse response");
xlabel("sample");
ylabel("linear impulse response");
legend;

plot(partial_autocorrelation_coefficient_vocoder.impulse_response, "DisplayName", "PARCOR\_VOCODER");
plot(lpc_vocoder.impulse_response, "DisplayName", "LPC\_VOCODER");
saveas(gcf, "D:/名城大学/研究室/演習/data/PartialAutocorrelationCoefficient/impulse_response_of_LPC_Vocoder_and_PARCOR_Vocoder.png");
