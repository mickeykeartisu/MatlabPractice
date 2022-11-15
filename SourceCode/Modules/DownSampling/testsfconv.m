%% set AudioFileManipulator class parameters
input_file_path = "vaiueo2d.wav";
output_file_path = "C:/Users/sekijima/Desktop/演習/DataSet/LinearPredictiveCoding/vaiueo2d_8k.wav";

%% generate AudioFileManipulator instance and confirm properties
audio_file_manipulator = AudioFileManipulator(input_file_path, output_file_path);
audio_file_manipulator.load_properties();
audio_file_manipulator.display_properties();

[audio_file_manipulator.signal, audio_file_manipulator.sample_rate, filt] = sfconv(audio_file_manipulator.signal, audio_file_manipulator.information.SampleRate, 8000);
audio_file_manipulator.sample_rate = 8000;
soundsc(audio_file_manipulator.signal, audio_file_manipulator.sample_rate);
audio_file_manipulator.normalize();
audio_file_manipulator.change_scale();
audio_file_manipulator.display_properties();
audio_file_manipulator.save_properties();
