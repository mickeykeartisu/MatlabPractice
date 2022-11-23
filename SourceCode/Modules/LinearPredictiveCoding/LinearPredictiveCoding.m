%% class to conduct LinearPredictiveCoding analysis
classdef LinearPredictiveCoding < handle
    %% how to use : Usage
    %   1. generate LinearPredictiveCoding instance
    %       -> arguments : 
    %           ・ signal    :   audio monoral signal array
    %           ・ sample_rate   : sampling frequency [Hz]
    %           ・ window_mode  :   window name (default : hamming)
    %           ・ order : analysis order (default : 30)
    %           ・ voicing_threshold : threshold to judge voicing or non voicing (default : 0.0001)
    %   2. if you'd like to check properties, conduct display_properties() method
    %   3. if you'd like to get spectrum_density(dB), conduct get_spectrum_density_dB() method
    %   4. if you'd like to get residual_error_spectrum(dB), conduct get_residual_error_spectrum_dB() method

    %% ---------- properties ---------- %%
    properties(Access = public)
        signal
        window_mode
        fft_point
        sample_rate
        linear_predictor_coefficient
        order
        Ai
        squared_sigma
        spectrum_density
        residual_error
        modified_autocorrelation
        basic_frequency
        basic_period
        voicing_threshold
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = LinearPredictiveCoding(signal, sample_rate, window_mode, order, voicing_threshold)
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

            autocorrelation_function = AutocorrelationFunction(object.signal, object.window_mode);
            autocorrelation_function.calculate_autocorrelation_with_fourier();
            object.fft_point = autocorrelation_function.fft_point;

            partial_autocorrelation_coefficient = PartialAutocorrelationCoefficient(autocorrelation_function.autocorrelation, object.order);
            % object.linear_predictor_coefficient = levinson(autocorrelation_function.autocorrelation, object.order);
            object.linear_predictor_coefficient = partial_autocorrelation_coefficient.linear_predictive_coefficient;

            object.calculate_Ai();
            object.calculate_squared_sigma(autocorrelation_function.autocorrelation);
            object.calculate_spectrum_density();
            
            object.multiple_window(object.window_mode);
            object.calculate_residual_error();
            object.calculate_modified_autocorrelation();
            object.normalize_modified_autocorrelation();
            object.calculate_basic_period_and_basic_frequency();
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

        % linear_predictor_cofficient setter
        function set.linear_predictor_coefficient(object, linear_predictor_coefficient)
            if length(linear_predictor_coefficient) < 1
                throw(MException("Setter:linear_predictor_coefficient", "linear_predictor_coefficient length is smaller than 1."))
            end
            object.linear_predictor_coefficient = linear_predictor_coefficient;
        end

        % order setter
        function set.order(object, order)
            if order < 1
                throw(MException("Setter:order", "order is smaller than 1."))
            end
            object.order = order;
        end

        % Ai setter
        function set.Ai(object, Ai)
            if length(Ai) < 1
                throw(MException("Setter:ai", "Ai length is smaller than 1."))
            end
            object.Ai = Ai;
        end

        % squared_signa setter
        function set.squared_sigma(object, squared_sigma)
            object.squared_sigma = squared_sigma;
        end

        % fft_point setter
        function set.fft_point(object, fft_point)
            if fft_point < 1
                throw(MException("Setter:fft_point", "fft_point is smaller than 1."));
            end
            object.fft_point = fft_point;
        end

        % spectrum_density setter
        function set.spectrum_density(object, spectrum_density)
            if length(spectrum_density) < 1
                throw(MException("Setter:spectrum_density", "spectrum_density length is smaller than 1."))
            end
            object.spectrum_density = spectrum_density;
        end

        % residual_error setter
        function set.residual_error(object, residual_error)
            if length(residual_error) < 1
                throw(MException("Setter:residual_error", "residual_error length is smaller than 1."))
            end
            object.residual_error = residual_error;
        end

        % modified_autocorrelation setter
        function set.modified_autocorrelation(object, modified_autocorrelation)
            if length(modified_autocorrelation) < 1
                throw(MException("Setter:modified_autocorrelation", "modified_autocorrelation length is smaller than 1."))
            end
            object.modified_autocorrelation = modified_autocorrelation;
        end

        % basic_frequencies setter
        function set.basic_frequency(object, basic_frequency)
            if length(basic_frequency) < 1
                throw(MException("Setter:basic_frequency", "basic_frequency is smaller than 1."))
            end
            object.basic_frequency = basic_frequency;
        end

        % basic_periods setter
        function set.basic_period(object, basic_period)
            if length(basic_period) < 1
                throw(MException("Setter:basic_period", "basic_period is smaller than 1."))
            end
            object.basic_period = basic_period;
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

        %% ---------- getters ---------- %%
        % signal getter
        function signal = get.signal(object)
            signal = object.signal;
        end

        % window_mode getter
        function window_mode = get.window_mode(object)
            window_mode = object.window_mode;
        end

        % linear_predictor_coefficient getter
        function linear_predictor_coefficient = get.linear_predictor_coefficient(object)
            linear_predictor_coefficient = object.linear_predictor_coefficient;
        end

        % order getter
        function order = get.order(object)
            order = object.order;
        end

        % Ai getter
        function Ai = get.Ai(object)
            Ai = object.Ai;
        end

        % squared_sigma getter
        function squared_sigma = get.squared_sigma(object)
            squared_sigma = object.squared_sigma;
        end

        % fft_point getter
        function fft_point = get.fft_point(object)
            fft_point = object.fft_point;
        end

        % spectrum_density getter
        function spectrum_density = get.spectrum_density(object)
            spectrum_density = object.spectrum_density;
        end

        % residual_error getter
        function residual_error = get.residual_error(object)
            residual_error = object.residual_error;
        end

        % modified_autocorrelation getter
        function modified_autocorrelation = get.modified_autocorrelation(object)
            modified_autocorrelation = object.modified_autocorrelation;
        end

        % basic_frequency getter
        function basic_frequency = get.basic_frequency(object)
            basic_frequency = object.basic_frequency;
        end

        % basic_period getter
        function basic_period = get.basic_period(object)
            basic_period = object.basic_period;
        end

        % voicing_threshold getter
        function voicing_threshold = get.voicing_threshold(object)
            voicing_threshold = object.voicing_threshold;
        end

        % sample_rate getter
        function sample_rate = get.sample_rate(object)
            sample_rate = object.sample_rate;
        end

        %% ---------- usual method ---------- %%
        % method to calculate Ai
        function calculate_Ai(object)
            for dimension_index = 0 : object.order
                sumation = 0;
                for shift_index = 0 : (object.order - dimension_index)
                    sumation = sumation + object.linear_predictor_coefficient(shift_index + 1) * object.linear_predictor_coefficient(shift_index + dimension_index + 1);
                end
                object.Ai(dimension_index + 1) = sumation;
            end
        end

        % method to calculate squared_sigma
        function calculate_squared_sigma(object, autocorrelation)
            object.squared_sigma = 0;
            for dimension_index = 0 : object.order
                object.squared_sigma = object.squared_sigma + (object.linear_predictor_coefficient(dimension_index + 1) * autocorrelation(dimension_index + 1));
            end
        end

        % method to calculate spectrum_density
        function calculate_spectrum_density(object)
            lambdas = (pi / (object.fft_point / 2)) .* (0 : (object.fft_point / 2));
            object.spectrum_density = zeros(length(lambdas), 1);
            for lamdas_index = 1 : length(lambdas)
                sumation = 0;
                for dimension_index = 1 : object.order
                    sumation = sumation + (object.Ai(dimension_index + 1) * cos(dimension_index * lambdas(lamdas_index)));
                end
                object.spectrum_density(lamdas_index) = (object.squared_sigma / (2 * pi)) * (1 / (object.Ai(1) + 2 * sumation));
            end
        end

        % method to get spectrum_density_dB
        function spectrum_density_dB = get_spectrum_density_dB(object)
            spectrum_density_dB = 10 * log10(object.spectrum_density);
        end

        % method to get residual_error_spectrum_dB
        function residual_error_spectrum_dB = get_residual_error_spectrum_dB(object)
            residual_error_spectrum_dB = abs(fft(object.residual_error, object.fft_point));
            residual_error_spectrum_dB = residual_error_spectrum_dB(1 : object.fft_point / 2 + 1);
            residual_error_spectrum_dB = 20 * log10(residual_error_spectrum_dB);
        end

        % method to multiple signal and window
        function multiple_window(object, window_mode)
            if window_mode == "hamming"
                object.signal = hamming(length(object.signal)) .* object.signal;
            end
        end

        % method to calculate residual_error
        function calculate_residual_error(object)
            object.residual_error = zeros(length(object.signal), 1);
            for time_index = 0 : length(object.residual_error) - 1
                signal_hat = 0;
                for order_index = 1 : object.order
                    if time_index - order_index >= 0
                        signal_hat = signal_hat + (object.linear_predictor_coefficient(order_index + 1) * object.signal(time_index - order_index + 1));
                    end
                end
                object.residual_error(time_index + 1) = object.signal(time_index + 1) + signal_hat;
            end
        end

        % method to get fft_point
        function calculate_fft_point(object)
            object.fft_point = 1;
            while object.fft_point < length(object.residual_error) * 2
                object.fft_point = object.fft_point * 2;
            end
        end

        % method to calculate residual_error_autocorrelation
        function calculate_modified_autocorrelation(object)
            object.modified_autocorrelation = zeros(size(object.residual_error));
            object.calculate_fft_point();
            fft_signal = fft(object.residual_error, object.fft_point);
            power_spectrum = (abs(fft_signal) .^ 2);
            object.modified_autocorrelation = real(ifft(power_spectrum));
            object.modified_autocorrelation = object.modified_autocorrelation(1 : floor(object.fft_point / 2) + 1);
        end

        % method to calculate basic_period and basic_frequency
        function calculate_basic_period_and_basic_frequency(object)
            [max_value, peak_point] = max(object.modified_autocorrelation(2:end));
            if max_value >= object.voicing_threshold
                object.basic_period = (peak_point + 1) / object.sample_rate;
                object.basic_frequency = 1 / object.basic_period;
            else
                object.basic_frequency = 0;
                object.basic_period = 0;
            end
        end

        % method to normalize modified_aucotorrelation
        function normalize_modified_autocorrelation(object)
            object.modified_autocorrelation = object.modified_autocorrelation / max(abs(object.modified_autocorrelation));
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("---------- Linear Predictive Coding ----------\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("window_mode : %s\n", object.window_mode);
            fprintf("fft_point : %d [point]\n", object.fft_point);
            fprintf("sample_rate : %d [Hz]\n", object.sample_rate);
            fprintf("linear_predictor_coefficient size : (%d, %d)\n", size(object.linear_predictor_coefficient));
            fprintf("order : %d\n", object.order);
            fprintf("voicing_threshold : %f\n", object.voicing_threshold);
            fprintf("Ai size: (%d, %d)\n", size(object.Ai));
            fprintf("squared_sigma : %f\n", object.squared_sigma);
            fprintf("spectrum_density size : (%d, %d)\n", size(object.spectrum_density));
            fprintf("residual_error size : (%d, %d)\n", size(object.residual_error));
            fprintf("modified_autocorrelation size : (%d, %d)\n", size(object.modified_autocorrelation));
            fprintf("basic_frequency : %f [Hz]\n", object.basic_frequency);
            fprintf("basic_period : %f [s]\n", object.basic_period);
            fprintf("----------------------------------------------\n\n");
        end
    end

end