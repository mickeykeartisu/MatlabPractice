%% class to calculate auto correlation function
classdef AutocorrelationFunction < handle
    %% how to use : Usage
    %   1. generate AutocorrelationFunction instance
    %       -> arguments : 
    %           ・ signal    :   monoral signal numeric array
    %           ・ window_mode   :   window name
    %   2. if you'd like to calculate autocorrelation, conduct calculate_autocorrelation_with_fourier() method(recomended)
    %   3. if you'd like to calculate autocorrelation, conduct calculate_autocorrelation() method(not recomended)
    %   4. if you'd like to normalize, conduct normalize_autocorrelation() method
    %   5. if you'd like to check properties, conduct display_properties() method

    %% ---------- properties ---------- %%
    properties(Access = public)
        signal  % monoral signal
        autocorrelation % auto correlation
        power_spectrum  % power spectrum
        fft_point   % fft_point [point]
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = AutocorrelationFunction(signal, window_mode)
            switch nargin
                case 1
                    object.signal = signal;
                    object.multiple_window("hamming");
                case 2
                    object.signal = signal;
                    object.multiple_window(window_mode);
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not adjust, please input 1 or 2 arguments."));
            end
        end

        %% ---------- setters ---------- %%
        % signal setter
        function set.signal(object, signal)
            if length(signal) < 1
                thorw(MException("Setter:signal", "signal length is smaller than 1."));
            end
            object.signal = signal;
        end

        % autocorrelation setter
        function set.autocorrelation(object, autocorrelation)
            if length(autocorrelation) < 1
                thorw(MException("Setter:autocorrelation", "autocorrelations length is smaller than 1."));
            end
            object.autocorrelation = autocorrelation;
        end

        % power_spectrum setter
        function set.power_spectrum(object, power_spectrum)
            if length(power_spectrum) < 1
                thorw(MException("Setter:power_spectrum", "power spectrum length is smaller than 1."));
            end
            object.power_spectrum = power_spectrum;
        end

        % fft_point setter
        function set.fft_point(object, fft_point)
            if fft_point < 1
                throw(MException("Setter:fft_point", "fft_point is smaller than 1."));
            end
            object.fft_point = fft_point;
        end

        %% ---------- getters ---------- %%
        % signal getter
        function signal = get.signal(object)
            signal = object.signal;
        end

        % autocorrelation getter
        function autocorrelations = get.autocorrelation(object)
            autocorrelations = object.autocorrelation;
        end

        % power_spectrum getter
        function power_spectrum = get.power_spectrum(object)
            power_spectrum = object.power_spectrum;
        end

        % fft_point getter
        function fft_point = get.fft_point(object)
            fft_point = object.fft_point;
        end
        
        %% ---------- usual method ---------- %%
        % method to multiple each window
        function multiple_window(object, window_mode)
            if window_mode == "hamming"
                object.signal = object.signal .* hamming(length(object.signal));
            end
        end

        % method to get fft_point
        function calculate_fft_point(object)
            object.fft_point = 1;
            while object.fft_point < length(object.signal) * 2
                object.fft_point = object.fft_point * 2;
            end
        end

        % method to calculate auto correlations(Not recomend)
        function calculate_autocorrelation(object)
            object.autocorrelation = zeros(length(object.signal), 1);
            for shift_index = 0 : length(object.signal) - 1
                for time_index = 0 : length(object.signal) - shift_index - 1
                    object.autocorrelation(shift_index + 1) = object.autocorrelation(shift_index + 1) + (object.signal(time_index + 1) * object.signal(time_index + shift_index + 1));
                end
            end
        end

        % method to calculate auto correlation with fourier transform
        function calculate_autocorrelation_with_fourier(object)
            object.calculate_fft_point();
            fft_signal = fft(object.signal, object.fft_point);
            object.power_spectrum = (abs(fft_signal) .^ 2);
            object.autocorrelation = ifft(object.power_spectrum);
            object.autocorrelation = object.autocorrelation(1 : length(object.signal));
        end

        % method to normalize autocorrelation
        function normalize_autocorrelation(object)
            object.autocorrelation = object.autocorrelation / max(abs(object.autocorrelation));
        end

        % method to display properties
        function display_properties(object)
            fprintf("--------------------------------------------\n");
            fprintf("--------- Auto correlation function --------\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("autocorrelation size : (%d, %d)\n", size(object.autocorrelation));
            fprintf("power_spectrum size : (%d, %d)\n", size(object.power_spectrum));
            fprintf("fft_point : %d [point]\n", object.fft_point);
            fprintf("--------------------------------------------\n\n");
        end
    end
end