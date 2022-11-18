%% class to conduct LPC Vocoder
classdef LinearPredictiveCodingVocoder < handle
    %% how to use : Usage
    %   1. generate LinearPredictiveCoding instance
    %       -> arguments : 
    %           ・ signal    :   audio monoral signal array 
    %           ・ sample_rate   : sampling_frequency [Hz]
    %           ・ window_mode  :   window name (default : hamming)
    %           ・ dimension : analysis dimension (default : 30)
    %           ・ voicing_threshold : threshold to judge voicing or non voicing (default : 0.0001)
    %   2. if you'd like to check properties, conduct display_properties() method

    %% ---------- properties ---------- %%
    properties(Access = public)
        signal
        window_mode
        sample_rate
        order
        voicing_threshold
        internal_status
        synthesized_signal
        impulse_response
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = LinearPredictiveCodingVocoder(signal, sample_rate, window_mode, order, voicing_threshold)
            switch nargin
                case 2
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = "hamming";
                    object.order = 30;
                    object.voicing_threshold = 0.0001;
                case 3
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = 30;
                    object.voicing_threshold = 0.0001;
                case 4
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = order;
                    object.voicing_threshold = 0.0001;
                case 5
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.order = order;
                    object.voicing_threshold = voicing_threshold;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not correct, please input 2, 3, 4 or 5 arguments."));
            end

            object.synthesize_signal();
            object.calculate_impulse_response();
        end

        %% ---------- setters ---------- %%
        % signal setter
        function set.signal(object, signal)
            if length(signal) < 1
                throw(MException("Setter:signal", "signal size is smaller than 1."))
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

        % internal_status setter
        function set.internal_status(object, internal_status)
            if length(internal_status) < 1
                throw(MException("Setter:internal_status", "internal_status size is smaller than 1."));
            end
            object.internal_status = internal_status;
        end

        % synthesized_signal setter
        function set.synthesized_signal(object, synthesized_signal)
            if length(synthesized_signal) < 1
                throw(MException("Setter:synthesized_signal", "synthesized_signal size is smaller than 1."));
            end
            object.synthesized_signal = synthesized_signal;
        end

        % sample_rate setter
        function set.sample_rate(object, sample_rate)
            if sample_rate < 1
                throw(MException("Setter:sample_rate", "sample_rate is smaller than 1."));
            end
            object.sample_rate = sample_rate;
        end

        % impulse_response setter
        function set.impulse_response(object, impulse_response)
            if length(impulse_response) < 1
                throw(MException("Setter:impulse_response", "impulse_response is smaller than 1."));
            end
            object.impulse_response = impulse_response;
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

        % internal_status getter
        function internal_status = get.internal_status(object)
            internal_status = object.internal_status;
        end

        % synthesized_signal getter
        function synthesized_signal = get.synthesized_signal(object)
            synthesized_signal = object.synthesized_signal;
        end

        % sample_rate getter
        function sample_rate = get.sample_rate(object)
            sample_rate = object.sample_rate;
        end

        % impulse_response getter
        function impulse_response = get.impulse_response(object)
            impulse_response = object.impulse_response;
        end

        %% ---------- usual method ---------- %%
        % method to normalize impulse response
        function normalize_impulse_response(object)
            object.impulse_response = object.impulse_response / max(abs(object.impulse_response));
        end

        % method to convolute residual_error and linear_predictive_coefficient
        function signal_element = convolute(object, residual_error_element, linear_predictive_coefficient)
            x_t_hat = - sum(object.internal_status .* linear_predictive_coefficient(1, 2:end)');
            signal_element = x_t_hat + residual_error_element;
            object.internal_status(2 : end) = object.internal_status(1 : end - 1);
            object.internal_status(1) = signal_element;
        end

        % method to synthesize signal
        function synthesize_signal(object)
            object.internal_status = zeros(object.order, 1);
            object.synthesized_signal = zeros(size(object.signal));
            lpc = LinearPredictiveCoding( ...
                object.signal, ...
                object.sample_rate, ...
                object.window_mode, ...
                object.order, ...
                object.voicing_threshold ...
            );

            for signal_index = 1 : length(object.signal)
                object.synthesized_signal(signal_index, 1) = object.convolute(lpc.residual_error(signal_index, 1), lpc.linear_predictor_coefficient);
            end
        end

        % method to calculate impulse_response
        function calculate_impulse_response(object)
            object.impulse_response = zeros(size(object.signal));
            object.internal_status = zeros(object.order, 1);
            lpc = LinearPredictiveCoding( ...
                object.signal, ...
                object.sample_rate, ...
                object.window_mode, ...
                object.order, ...
                object.voicing_threshold ...
            );
            
            object.impulse_response(1) = object.convolute(1, lpc.linear_predictor_coefficient);
            for signal_index = 2 : length(object.signal)
                object.impulse_response(signal_index) = object.convolute(0, lpc.linear_predictor_coefficient);
            end
            object.normalize_impulse_response();
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("----------------- LPC Vocoder ----------------\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("window_mode : %s\n", object.window_mode);
            fprintf("order : %d\n", object.order);
            fprintf("threshold : %f\n", object.voicing_threshold);
            fprintf("internal_status size : (%d, %d)\n", size(object.internal_status));
            fprintf("synthesized_signal size : (%d, %d)\n", size(object.synthesized_signal));
            fprintf("impulse_response size : (%d, %d)\n", size(object.impulse_response));
            fprintf("----------------------------------------------\n\n");
        end
    end
end