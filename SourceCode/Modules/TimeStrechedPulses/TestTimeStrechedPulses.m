%% パラメータ
recorded_file_path = "mic.wav";
time_streched_pulses_file_path = "tsp.wav";

%% それぞれの信号のインスタンスを生成
recorded_file = AudioFileManipulator(recorded_file_path);
time_streched_pulses_file = AudioFileManipulator(time_streched_pulses_file_path);

TSPInstance = TimeStrechedPulses(time_streched_pulses_file.signal, recorded_file.signal);
hold on;
legend;
plot(TSPInstance.impulse_response, "DisplayName", "impulse response");