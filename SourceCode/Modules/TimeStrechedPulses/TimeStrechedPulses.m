%% TSP信号を扱うクラス
classdef TimeStrechedPulses < handle
    properties(SetAccess = private)
        time_streched_pulses_signal % TSP信号
        recorded_signal % 録音信号
        time_streched_pulses_signal_inverse % 逆TSP信号
        impulse_response    % インパルス応答
    end

    methods
        %% デフォルトコンストラクタ
        function object = TimeStrechedPulses(time_streched_pulses_signal, recorded_signal)
            object.time_streched_pulses_signal = time_streched_pulses_signal;
            object.recorded_signal = recorded_signal;
            object.time_streched_pulses_signal_inverse = flip(object.time_streched_pulses_signal);
            object.impulse_response = fftfilt(object.time_streched_pulses_signal, object.time_streched_pulses_signal_inverse);
            object.normalize_impulse_response();
        end

        %% セッター
        % TSP信号のセッター
        function set.time_streched_pulses_signal(object, time_streched_pulses_signal)
            if length(time_streched_pulses_signal) < 0
                thorw(MException("Setter:time_streched_pulses_signal", "time_streched_pulses_signal length is smaller than 0"));
            end
            object.time_streched_pulses_signal = time_streched_pulses_signal;
        end

        % 録音信号のセッター
        function set.recorded_signal(object, recorded_signal)
            if length(recorded_signal) < 0
                throw(MException("Setter:recorded_signal", "recorded_signal length is smaller than 0"));
            end
            object.recorded_signal = recorded_signal;
        end

        % 逆TSP信号のセッター
        function set.time_streched_pulses_signal_inverse(object, time_streched_pulses_signal_inverse)
            if length(time_streched_pulses_signal_inverse) < 0
                thorw(MException("Setter:time_streched_pulses_signal_inverse", "time_streched_pulses_signal_inverse length is smaller than 0"));
            end
            object.time_streched_pulses_signal_inverse = time_streched_pulses_signal_inverse;
        end

        % インパルス応答セッター
        function set.impulse_response(object, impulse_response)
            if length(impulse_response) < 0
                thorw(MException("Setter:impulse_response", "impulse_response length is smaller than 0"));
            end
            object.impulse_response = impulse_response;
        end

        %% ゲッター
        % TSP信号のゲッター
        function time_streched_pulses_signal = get.time_streched_pulses_signal(object)
            time_streched_pulses_signal = object.time_streched_pulses_signal;
        end

        % 録音信号のゲッター
        function recorded_signal = get.recorded_signal(object)
            recorded_signal = object.recorded_signal;
        end

        % 逆TSP信号のゲッター
        function time_streched_pulses_signal_inverse = get.time_streched_pulses_signal_inverse(object)
            time_streched_pulses_signal_inverse = object.time_streched_pulses_signal_inverse;
        end

        % インパルス応答のゲッター
        function impulse_response = get.impulse_response(object)
            impulse_response = object.impulse_response;
        end
        
        %% ---------- usual method ---------- %%
        % method to normalize impulse response
        function normalize_impulse_response(object)
            object.impulse_response = object.impulse_response / max(abs(object.impulse_response));
        end
    end
end