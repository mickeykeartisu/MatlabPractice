%% class to extract pitch by Linear Predictive Coding
classdef LinearPredictiveCodingPitchExtractor < handle
    %% how to use : Usage
    %   1. generate LinearPredictiveCodingPitchExtractor instance
    %       -> arguments : 
    %           ・ signal    :   audio monoral signal array
    %           ・ sample_rate   : sampling_frequency [Hz]
    %           ・ window_mode  :   window name (default : hamming)
    %           ・ order : analysis order (default : 30)
    %           ・ voicing_threshold : threshold to judge voicing or non voicing (default : 0.0001)
    %   2. if you'd like to check properties, conduct display_properties() method
    %% ---------- properties ---------- %%
    properties(Access = public)
        signal
        window_mode
        sample_rate
        order
        voicing_threshold
        frame_length
        hop_length
        basic_frequencies
        basic_periods
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = LinearPredictiveCodingPitchExtractor(signal, sample_rate, window_mode, order, voicing_threshold, frame_length, hop_length)
            switch nargin
                case 2
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = "hamming";
                    object.order = 30;
                    object.voicing_threshold = 0.0001;
                    object.frame_length = 32;
                    object.hop_length = floor(object.frame_length * 1000 / object.sample_rate / 4);
                case 3
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = 30;
                    object.voicing_threshold = 0.0001;
                    object.frame_length = 32;
                    object.hop_length = floor(object.frame_length * 1000 / object.sample_rate / 4);
                case 4
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = order;
                    object.voicing_threshold = 0.0001;
                    object.frame_length = 32;
                    object.hop_length = floor(object.frame_length * 1000 / object.sample_rate / 4);
                case 5
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = order;
                    object.voicing_threshold = voicing_threshold;
                    object.frame_length = 32;
                    object.hop_length = floor(object.frame_length * 1000 / object.sample_rate / 4);
                case 6
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = order;
                    object.voicing_threshold = voicing_threshold;
                    object.frame_length = frame_length;
                    object.hop_length = floor(object.frame_length * 1000 / object.sample_rate / 4);
               case 7
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = order;
                    object.voicing_threshold = voicing_threshold;
                    object.frame_length = frame_length;
                    object.hop_length = hop_length;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not correct, please input 2, 3, 4, 5, 6 or 7 arguments."));
            end
            object.calculate_basic_periods_and_basic_frequencies();
        end

        %% ---------- setters ---------- %%
        % signal setter
        function set.signal(object, signal)
            if length(signal) < 1
                throw(MException("Setter:signal", "signal length is smaller than 1."))
            end
            object.signal = signal;
        end

        % window_mode setter
        function set.window_mode(object, window_mode)
            if window_mode == "hamming"
                object.window_mode = window_mode;
            end
        end

        % order setter
        function set.order(object, order)
            if order < 1
                throw(MException("Setter:order", "order is smaller than 1."))
            end
            object.order = order;
        end

        % voicing_threshold setter
        function set.voicing_threshold(object, voicing_threshold)
            if voicing_threshold < 0
                throw(MException("Setter:voicing_threshold", "voicing_threshold is smaller than 0."))
            end
            object.voicing_threshold = voicing_threshold;
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

        % basic_periods setter
        function set.basic_periods(object, basic_periods)
            if length(basic_periods) < 1
                throw(MException("Setter:basic_periods", "basic_periods length is smaller than 1."));
            end
            object.basic_periods = basic_periods;
        end

        %% ---------- getters ---------- %%
        % signal getter
        function signal = get.signal(object)
            signal = object.signal;
        end

        % window_mode getter
        function window_mode = get.window_mode(object)
            window_mode = object.window_mode;
        end

        % order getter
        function order = get.order(object)
            order = object.order;
        end

        % voicing_threshold getter
        function voicing_threshold = get.voicing_threshold(object)
            voicing_threshold = object.voicing_threshold;
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

        % basic_periods getter
        function basic_periods = get.basic_periods(object)
            basic_periods = object.basic_periods;
        end

        %% ---------- usual method ---------- %%
        % method to calculate basic_periods and basic_frequencies
        function calculate_basic_periods_and_basic_frequencies(object)
            object.basic_frequencies = zeros(floor(length(object.signal) / (object.hop_length)), 1);
            object.basic_periods = zeros(floor(length(object.signal) / (object.hop_length)), 1);
            paddinged_signal = zeros(length(object.basic_frequencies) * object.hop_length + (object.frame_length - object.hop_length), 1);
            paddinged_signal(1 : length(object.signal), 1) = object.signal;
            for frame_index = 1 : length(object.basic_frequencies)
                lpc = LinearPredictiveCoding( ...
                    paddinged_signal((frame_index - 1) * object.hop_length + 1 : (frame_index - 1) * object.hop_length + object.frame_length), ...
                    object.sample_rate, ...
                    object.window_mode, ...
                    object.order, ...
                    object.voicing_threshold ...
                );
                object.basic_frequencies(frame_index) = lpc.basic_frequency;
                object.basic_periods(frame_index) = lpc.basic_period;
            end
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("-- Linear Predictive Coding Pitch Extractor --\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("window_mode : %s\n", object.window_mode);
            fprintf("sample_rate : %d [Hz]\n", object.sample_rate);
            fprintf("order : %d\n", object.order);
            fprintf("voicing_threshold : %f\n", object.voicing_threshold);
            fprintf("frame_length : %d [sample]\n", object.frame_length);
            fprintf("hop_length : %d [sample]\n", object.hop_length);
            fprintf("basic_frequencies size : (%d, %d)\n", size(object.basic_frequencies));
            fprintf("basic_periods size : (%d, %d)\n", size(object.basic_frequencies));
            fprintf("----------------------------------------------\n\n");
        end
    end
end