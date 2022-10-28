%% class to conduct LPC analysis
classdef LPC < handle
    properties(SetAccess = protected)
        signal  % 音声信号
        window_mode % 窓の種類
        fft_point   % FFTポイント数
        alpha   % 線形予測係数
        dimension   % 分析次元
        Ai  % 係数
        squared_sigma   % σの2乗の値
        spectrum_density    % スペクトル密度
        epsilon % 残差信号
        epsilon_autocorrelation % 残差信号の自己相関
        basic_frequency % 基本周波数
        basic_period    % 基本周期
        threshold   % 有声と無声を判定する閾値
    end

    methods
        function object = LPC(signal, window_mode, fft_point, dimension, threshold)
            object.signal = signal;
            object.window_mode = window_mode;
            object.fft_point = fft_point;
            object.dimension = dimension;
            object.threshold = threshold;

            autocorrelations = AutocorrelationFunction(object.signal, object.window_mode);
            autocorrelations.calculate_autocorrelations_with_fourier(object.fft_point);
            object.alpha = levinson(autocorrelations.autocorrelations, object.dimension);

            object.calculate_Ai();
            object.calculate_squared_sigma(autocorrelations.autocorrelations);
            object.calculate_spectrum_density();
            
            object.multiple_window(object.window_mode);
            object.calculate_epsilon();
            object.calculate_epsilon_autocorrelation();
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

        function set.alpha(object, alpha)
            if length(alpha) < 1
                throw(MException("Setter:alpha", "alpha size is smaller than 1."))
            end
            object.alpha = alpha;
        end

        function set.dimension(object, dimension)
            if dimension < 1
                throw(MException("Setter:dimension", "dimension is smaller than 1."))
            end
            object.dimension = dimension;
        end

        function set.Ai(object, Ai)
            if length(Ai) < 1
                throw(MException("Setter:ai", "Ai size is smaller than 1."))
            end
            object.Ai = Ai;
        end

        function set.squared_sigma(object, squared_sigma)
            object.squared_sigma = squared_sigma;
        end

        function set.spectrum_density(object, spectrum_density)
            if length(spectrum_density) < 1
                throw(MException("Setter:spectrum_density", "spectrum_density size is smaller than 1."))
            end
            object.spectrum_density = spectrum_density;
        end

        function set.epsilon(object, epsilon)
            if epsilon < 0
                throw(MException("Setter:epsilon", "epsilon is smaller than 0."))
            end
            object.epsilon = epsilon;
        end

        function set.epsilon_autocorrelation(object, epsilon_autocorrelation)
            if length(epsilon_autocorrelation) < 0
                throw(MException("Setter:epsilon_autocorrelation", "epsilon autocorrelation size is smaller than 0."))
            end
            object.epsilon_autocorrelation = epsilon_autocorrelation;
        end

        function set.basic_frequency(object, basic_frequency)
            if basic_frequency < 0
                throw(MException("Setter:basic_frequency", "basic_frequency is smaller than 0."))
            end
            object.basic_frequency = basic_frequency;
        end

        function set.basic_period(object, basic_period)
            if basic_period < 0
                throw(MException("Setter:basic_period", "basic_period is smaller than 0."))
            end
            object.basic_period = basic_period;
        end

        function set.threshold(object, threshold)
            if threshold < 0
                throw(MException("Setter:threshold", "threshold is smaller than 0."))
            end
            object.threshold = threshold;
        end

        function signal = get.signal(object)
            signal = object.signal;
        end

        function window_mode = get.window_mode(object)
            window_mode = object.window_mode;
        end

        function fft_point = get.fft_point(object)
            fft_point = object.fft_point;
        end

        function alpha = get.alpha(object)
            alpha = object.alpha;
        end

        function dimension = get.dimension(object)
            dimension = object.dimension;
        end

        function Ai = get.Ai(object)
            Ai = object.Ai;
        end

        function squared_sigma = get.squared_sigma(object)
            squared_sigma = object.squared_sigma;
        end

        function spectrum_density = get.spectrum_density(object)
            spectrum_density = object.spectrum_density;
        end

        function epsilon = get.epsilon(object)
            epsilon = object.epsilon;
        end

        function epsilon_autocorrelation = get.epsilon_autocorrelation(object)
            epsilon_autocorrelation = object.epsilon_autocorrelation;
        end

        function basic_frequency = get.basic_frequency(object)
            basic_frequency = object.basic_frequency;
        end

        function basic_period = get.basic_period(object)
            basic_period = object.basic_period;
        end

        function threshold = get.threshold(object)
            threshold = object.threshold;
        end

        function calculate_Ai(object)
            for dimension_index = 0 : object.dimension
                sumation = 0;
                for shift_index = 0 : (object.dimension - dimension_index)
                    sumation = sumation + object.alpha(shift_index + 1) * object.alpha(shift_index + dimension_index + 1);
                end
                object.Ai(dimension_index + 1) = sumation;
            end
        end

        function calculate_squared_sigma(object, autocorrelations)
            object.squared_sigma = 0;
            for dimension_index = 0 : object.dimension
                object.squared_sigma = object.squared_sigma + (object.alpha(dimension_index + 1) * autocorrelations(dimension_index + 1));
            end
        end

        function calculate_spectrum_density(object)
            lambdas = (pi / (object.fft_point / 2)) .* (0 : (object.fft_point / 2));
            object.spectrum_density = zeros(length(lambdas), 1);
            for lamdas_index = 1 : length(lambdas)
                sumation = 0;
                for dimension_index = 1 : object.dimension
                    sumation = sumation + (object.Ai(dimension_index + 1) * cos(dimension_index * lambdas(lamdas_index)));
                end

                object.spectrum_density(lamdas_index) = (object.squared_sigma / (2 * pi)) * (1 / (object.Ai(1) + 2 * sumation));
            end
        end

        function spectrum_density_dB = calculate_spectrum_density_dB(object)
            spectrum_density_dB = 10 * log10(object.spectrum_density);
        end

        function multiple_window(object, window_mode)
            if window_mode == "hamming"
                object.signal = hamming(length(object.signal)) .* object.signal;
            end
        end

        function calculate_epsilon(object)
            object.epsilon = zeros(length(object.signal), 1);
            for t = 1 : length(object.epsilon)
                signal_hat = 0;
                for i = 1 : object.dimension
                    if t - i > 0
                        signal_hat = signal_hat + (object.alpha(i) * object.signal(t - i));
                    end
                end
                object.epsilon(t) = signal_hat + object.signal(t);
            end
        end

        function calculate_epsilon_autocorrelation(object)
            object.epsilon_autocorrelation = zeros(size(object.epsilon));
            fft_signal = fft(object.epsilon, object.fft_point);
            power_spectrum = (abs(fft_signal) .^ 2) / length(object.signal);
            autocorrelation = ifft(power_spectrum);
            object.epsilon_autocorrelation = autocorrelation(1 : length(object.epsilon));
        end

        function calculate_basic_period_and_frequency(object, sampling_frequency)
            [max_value, peak_point] = max(object.epsilon_autocorrelation(30 : length(object.epsilon_autocorrelation)));
            if max_value >= object.threshold
                object.basic_period = (peak_point + 30) / sampling_frequency;
                object.basic_frequency = 1 / object.basic_period;
            else
                object.basic_frequency = 0;
                object.basic_period = 0;
            end
        end

        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("--------------------- LPC --------------------\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("window_mode : %s\n", object.window_mode);
            fprintf("fft_point : %d\n", object.fft_point);
            fprintf("alpha size : (%d, %d)\n", size(object.alpha));
            fprintf("dimension : %d\n", object.dimension);
            fprintf("threshold : %f\n", object.threshold);
            fprintf("Ai size: (%d, %d)\n", size(object.Ai));
            fprintf("squared_sigma : %f\n", object.squared_sigma);
            fprintf("spectrum_density size : (%d, %d)\n", size(object.spectrum_density));
            fprintf("epsilon size : (%d, %d)\n", size(object.epsilon));
            fprintf("epsilon_autocorrelation size : (%d, %d)\n", size(object.epsilon_autocorrelation));
            fprintf("basic_frequency : %f [Hz]\n", object.basic_frequency);
            fprintf("basic_period : %f [s]\n", object.basic_period);
            fprintf("----------------------------------------------\n\n");
        end
    end
end
