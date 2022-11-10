%% class to conduct cepstrum vocoder
classdef CepstrumVocoder < handle
    %% how to use : Usage
    %   1. generate AutocorrelationFunction instance
    %       -> arguments : 
    %           ・ signal    :   monoral signal numeric array
    %           ・ sample_rate   :   sampling frequency [Hz]
    %           ・ window_mode   :   window name (default : hamming)
    %           ・ liftering_order   :   order to conduct liftering (default : 2 [ms])
    %           ・ voicing_threshold :   threshold to judge voicing or non voicing (default : 0.01)
    %           ・ fft_point :   point to conduct fft (default : 1, but fft_point is calculated automatically)
    %           ・ repeat_number : number of convolution (default : 10)
    %           ・ basic_period_gain : gain related to voice pitch (default : 1.0)
    %   2. if you'd like to confirm properties, conduct display_properties() method
    %   3. if you'd like to get amplitude_spectrum_dB, conduct get_amplitude_spectrum_dB() method
    %   4. if you'd like to get amplitude_spectrum_envelope_dB, conduct get_amplitude_spectrum_envelope_dB() method

    %% ---------- properties ---------- %%
    properties(Access = public)
        signal
        sample_rate
        window_mode
        fft_point
        liftering_order % [ms]
        frame_length
        hop_length
        basic_frequencies
        synthesized_signal
        voicing_threshold
        repeat_number
        basic_period_gain
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = CepstrumVocoder(signal, sample_rate, frame_length, hop_length, window_mode, liftering_order, voicing_threshold, fft_point, repeat_number, basic_period_gain)
            switch nargin
                case 2
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = 32;
                    object.hop_length = floor((object.frame_length * 1000 / object.sample_rate) / 4);
                    object.window_mode = "hamming";
                    object.liftering_order = 2;
                    object.voicing_threshold = 0.01;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 3
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = floor((object.frame_length * 1000 / object.sample_rate) / 4);
                    object.window_mode = "hamming";
                    object.liftering_order = 2;
                    object.voicing_threshold = 0.01;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 4
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = "hamming";
                    object.liftering_order = 2;
                    object.voicing_threshold = 0.01;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 5
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = 2;
                    object.voicing_threshold = 0.01;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 6
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = 0.01;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 7
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 8
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = fft_point;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 9
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = fft_point;
                    object.repeat_number = repeat_number;
                    object.basic_period_gain = 1;
                case 10
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = fft_point;
                    object.repeat_number = repeat_number;
                    object.basic_period_gain = 1;
                case 11
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = fft_point;
                    object.repeat_number = repeat_number;
                    object.basic_period_gain = basic_period_gain;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not correct, please input 2, 3, 4, 5, 6, 7, 8, 9, 10 or 11 arguments."));
            end

            object.calculate_basic_frequencies_and_synthesize_signal();
        end

        %% ---------- setters ---------- %%
        % signal setter
        function set.signal(object, signal)
            if length(signal) < 1
                throw(MException("Setter:signal", "signal length is smaller than 1."))
            end
            object.signal = signal;
        end

        % sample_rate setter
        function set.sample_rate(object, sample_rate)
            if sample_rate < 1
                throw(MException("Setter:sample_rate", "sample_rate is smaller than 1."));
            end
            object.sample_rate = sample_rate;
        end

        % frame_length setter
        function set.frame_length(object, frame_length)
            if frame_length < 1
                throw(MException("Setter:frame_length", "frame_length is smaller than 1."));
            end
            object.frame_length = int64(frame_length * object.sample_rate / 1000);
        end

        % hop_length setter
        function set.hop_length(object, hop_length)
            if hop_length < 1
                throw(MException("Setter:hop_length", "hop_length is smaller than 1."));
            end
            object.hop_length = int64(hop_length * object.sample_rate / 1000);
        end

        % basic_frequencies setter
        function set.basic_frequencies(object, basic_frequencies)
            if length(basic_frequencies) < 1
                throw(MException("Setter:basic_frequencies", "basic_frequencies length is smaller than 1."));
            end
            object.basic_frequencies = basic_frequencies;
        end

        % synthesized_signal setter
        function set.synthesized_signal(object, synthesized_signal)
            if length(synthesized_signal) < 1
                throw(MException("Setter:synthesized_signal", "synthesized_signal length is smaller than 1."));
            end
            object.synthesized_signal = synthesized_signal;
        end

        % fft_point setter
        function set.fft_point(object, fft_point)
            if fft_point < 1
                throw(MException("Setter:fft_point", "fft_point is smaller than 1."));
            end
            object.fft_point = fft_point;
        end

        % window_mode setter
        function set.window_mode(object, window_mode)
            if window_mode == "hamming"
                object.window_mode = window_mode;
            end
        end

        % liftering_order setter
        function set.liftering_order(object, liftering_order)
            if liftering_order < 0
                throw(MException("Setter:liftering_order", "liftering_order is smaller than 0."));
            end
            object.liftering_order = liftering_order;
        end

        % voicing_threshold setter
        function set.voicing_threshold(object, voicing_threshold)
            if voicing_threshold < 0
                throw(MException("Setter:voicing_threshold", "voicing_threshold is smaller than 0."));
            end
            object.voicing_threshold = voicing_threshold;
        end

        % repeat_number setter
        function set.repeat_number(object, repeat_number)
            if repeat_number < 0
                throw(MException("Setter:repeat_number", "repeat_number is smaller than 0."));
            end
            object.repeat_number = repeat_number;
        end

        % basic_period_gain setter
        function set.basic_period_gain(object, basic_period_gain)
            if basic_period_gain < 0
                throw(MException("Setter:basic_period_gain", "basic_period_gain is smaller than 0."));
            end
            object.basic_period_gain = basic_period_gain;
        end

        %% ---------- getters ---------- %%
        % signal getter
        function signal = get.signal(object)
            signal = object.signal;
        end

        % sample_rate getter
        function sample_rate = get.sample_rate(object)
            sample_rate = object.sample_rate;
        end

        % frame_length getter
        function frame_length = get.frame_length(object)
            frame_length = object.frame_length;
        end

        % hop_length getter
        function hop_length = get.hop_length(object)
            hop_length = object.hop_length;
        end

        % basic_frequencies getter
        function basic_frequencies = get.basic_frequencies(object)
            basic_frequencies = object.basic_frequencies;
        end

        % synthesized_signal getter
        function synthesized_signal = get.synthesized_signal(object)
            synthesized_signal = object.synthesized_signal;
        end

        % fft_point getter
        function fft_point = get.fft_point(object)
            fft_point = object.fft_point;
        end

        % window_mode getter
        function window_mode = get.window_mode(object)
            window_mode = object.window_mode;
        end

        % liftering_order getter
        function liftering_order = get.liftering_order(object)
            liftering_order = object.liftering_order;
        end

        % voicing_threshold getter
        function voicing_threshold = get.voicing_threshold(object)
            voicing_threshold = object.voicing_threshold;
        end

        % repeat_number getter
        function repeat_number = get.repeat_number(object)
            repeat_number = object.repeat_number;
        end

        % basic_period_gain getter
        function basic_period_gain = get.basic_period_gain(object)
            basic_period_gain = object.basic_period_gain;
        end

        %% ---------- usual method ---------- %%
        % method to get fft_point
        function calculate_fft_point(object)
            object.fft_point = 1;
            while object.fft_point < object.frame_length * 2
                object.fft_point = object.fft_point * 2;
            end
        end

        % method to calculate
        function calculate_basic_frequencies_and_synthesize_signal(object)
            object.calculate_fft_point();
            object.basic_frequencies = zeros(floor(length(object.signal) / (object.hop_length)), 1);
            paddinged_signal = zeros(length(object.basic_frequencies) * object.hop_length + (object.frame_length - object.hop_length), 1);
            paddinged_signal(1 : length(object.signal)) = object.signal;
            object.synthesized_signal = zeros((length(object.basic_frequencies) - 1) * object.hop_length + object.fft_point, 1);
            for frame_index = 1 : length(object.basic_frequencies)
                cepstrum = Cepstrum( ...
                    paddinged_signal((frame_index - 1) * object.hop_length + 1 : (frame_index - 1) * object.hop_length + object.frame_length), ...
                    object.sample_rate, ...
                    object.window_mode, ...
                    object.liftering_order, ...
                    object.voicing_threshold, ...
                    object.fft_point, ...
                    object.repeat_number, ...
                    object.basic_period_gain ...
                );

                object.basic_frequencies(frame_index) = cepstrum.basic_frequency;
                
                if cepstrum.basic_frequency == 0
                    uv_period = int64(5 * object.sample_rate / 1000);
                    uv_resp = randn(1, uv_period);
                    uv_resp = uv_resp ./ sqrt(uv_period);
                    object.synthesized_signal(object.hop_length * (frame_index - 1) + 1 : object.hop_length * (frame_index - 1) + length(cepstrum.impulse_response)) ...
                    = object.synthesized_signal(object.hop_length * (frame_index - 1) + 1 : object.hop_length * (frame_index - 1) + length(cepstrum.impulse_response)) ...
                    + conv(cepstrum.impulse_response, uv_resp, 'same');
                else
                    object.synthesized_signal(object.hop_length * (frame_index - 1) + 1 : object.hop_length * (frame_index - 1) + length(cepstrum.impulse_response)) ...
                    = object.synthesized_signal(object.hop_length * (frame_index - 1) + 1 : object.hop_length * (frame_index - 1) + length(cepstrum.impulse_response)) ...
                    + cepstrum.impulse_response;
                end
            end
        end

        % method to display properties
        function display_properties(object)
            fprintf("------------------------------------------------\n");
            fprintf("---------------- CepstrumVocoder ---------------\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("sample_rate : %d [Hz]\n", object.sample_rate);
            fprintf("window_mode : %s\n", object.window_mode);
            fprintf("liftering_order : %f [ms]\n", object.liftering_order);
            fprintf("frame_length : %d [point]\n", object.frame_length);
            fprintf("hop_length : %d [point]\n", object.hop_length);
            fprintf("basic_frequencies size : (%d, %d)\n", size(object.basic_frequencies));
            fprintf("fft_point : %d\n", object.fft_point);
            fprintf("voicing_threshold : %f\n", object.voicing_threshold);
            fprintf("repeat_number : %d\n", object.repeat_number);
            fprintf("basic_period_gain : %f\n", object.basic_period_gain);
            fprintf("synthesized_signal size : (%d, %d)\n", size(object.synthesized_signal));
            fprintf("------------------------------------------------\n\n");
        end
    end
end