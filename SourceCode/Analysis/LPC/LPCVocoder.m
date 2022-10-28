classdef LPCVocoder < handle
    properties(SetAccess = private)
        signal  % 音声信号
        window_mode % 窓の種類
        fft_point   % FFTポイント数
        dimension   % 分析次元
        threshold   % 有声と無声を判定する閾値
        sampling_frequency  % サンプリング周波数
        frame_length    % フレームの長さ
        hop_length  % シフト長
        basic_frequencies   % 基本周波数ベクトル
        internal_state  % 内部状態
        synthesized_signal  % 合成音声
    end

    methods
        function object = LPCVocoder(signal, window_mode, fft_point, dimension, threshold, sampling_frequency, frame_length, hop_length)
            object.lpc = LPC(signal, window_mode, fft_point, dimension, threshold);
            object.display_properties();
            object.sampling_frequency = sampling_frequency;
            object.frame_length = frame_length; % 入力がmsで自動的にポイントに変換される
            object.hop_length = hop_length; % 入力がmsで自動的にポイントに変換される
            object.internal_state = zeros(1, object.lpc.dimension);

            object.transformUnits();
            object.setBuffers();
            object.calculate_basic_frequencies();
        end

        function set.signal(object, signal)
            if length(signal) < 0
                throw(MException("Setter:signal", "signal size is smaller than 0."))
            end
            object.signal = signal;
        end

        function set.window_mode(object, window_mode)
            if window_mode == "hamming"
                object.window_mode = window_mode;
            end
        end

        function set.fft_point(object, fft_point)
            if fft_point <= 0
                throw(MException("Setter:fft_point", "fft_point is smaller than 0."));
            end
            while fft_point < length(object.signal)
                fft_point = fft_point * 2;
            end
            object.fft_point = fft_point;
        end

        function set.sampling_frequency(object, sampling_frequency)
            if sampling_frequency <= 0
                throw(MException("Setter:sampling_frequency", "sampling_frequency is smaller than 0."))
            end
            object.sampling_frequency = sampling_frequency;
        end

        function set.frame_length(object, frame_length)
            if frame_length <= 0
                throw(MException("Setter:frame_length", "frame_length is smaller than 0."))
            end
            object.frame_length = frame_length;
        end

        function set.hop_length(object, hop_length)
            if hop_length <= 0
                throw(MException("Setter:hop_length", "hop_length is smaller than 0."))
            end
            object.hop_length = hop_length;
        end

        function set.basic_frequencies(object, basic_frequencies)
            if length(basic_frequencies) < 0
                throw(MException("Setter:basic_frequencies", "basic_frequencies length is smaller than 0."))
            end
            object.basic_frequencies = basic_frequencies;
        end

        function set.synthesized_signal(object, synthesized_signal)
            if length(synthesized_signal) < 0
                throw(MException("Setter:synthesized_signal", "synthesized_signal length is smaller than 0."))
            end
            object.synthesized_signal = synthesized_signal;
        end

        function set.internal_state(object, internal_state)
            if length(internal_state) < 0
                throw(MException("Setter:internal_state", "internal_state length is smaller than 0."))
            end
            object.internal_state = internal_state;
        end

        function frame_length = get.frame_length(object)
            frame_length = object.frame_length;
        end

        function hop_length = get.hop_length(object)
            hop_length = object.hop_length;
        end

        function sampling_frequency = get.sampling_frequency(object)
            sampling_frequency = object.sampling_frequency;
        end

        function basic_frequencies = get.basic_frequencies(object)
            basic_frequencies = object.basic_frequencies;
        end

        function synthesized_signal = get.synthesized_signal(object)
            synthesized_signal = object.synthesized_signal;
        end

        function internal_state = get.internal_state(object)
            internal_state = object.internal_state;
        end

        function transformUnits(object)
            object.frame_length = floor(object.frame_length * object.sampling_frequency / 1000);
            object.hop_length = floor(object.hop_length * object.sampling_frequency / 1000);
        end

        function setBuffers(object)
            object.basic_frequencies = zeros([floor((length(object.lpc.signal) - object.frame_length) / object.hop_length), 1]);
            object.synthesized_signal = zeros([length(object.lpc.signal) + object.lpc.fft_point, 1]);
        end

        % それぞれの基本周波数を計算する
        function calculate_basic_frequencies(object)
            for frame_index = 1 : length(object.basic_frequencies)
                lpc = LPC( ...
                    object.signal(object.hop_length * (frame_index - 1) + 1 : object.hop_length * (frame_index - 1) + 1 + object.frame_length), ...
                    object.window_mode, ...
                    object.fft_point, ...
                    object.dimension, ...
                    object.threshold ...
                );

                lpc.start_LPC_analysis();
                lpc.calculate_basic_period_and_frequency(object.sampling_frequency);
                object.basic_frequencies(frame_index) = lpc.basic_frequency;
            end
        end

        function display_properties(object)
            object.lpc.display_properties();
            fprintf("----------------------------------------------\n");
            fprintf("----------------- LPC Vocoder ----------------\n");
            fprintf("sampling_frequency : %d\n", object.sampling_frequency);
            fprintf("frame_length : %d[point]\n", object.frame_length);
            fprintf("hop_length : %d[point]\n", object.hop_length);
            fprintf("basic_frequencies size : (%d, %d)\n", size(object.basic_frequencies));
            fprintf("internal_state size : (%d, %d)\n", size(object.internal_state));
            fprintf("synthesized_signal size : (%d, %d)\n", size(object.synthesized_signal));
            fprintf("----------------------------------------------\n\n");
        end
    end
end