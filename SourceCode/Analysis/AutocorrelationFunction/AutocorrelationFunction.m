classdef AutocorrelationFunction < handle
    properties(SetAccess = private)
        signal
        autocorrelations
        power_spectrum
    end

    methods
        %% ------------- Default Constructor ------------- %%
        function object = AutocorrelationFunction(signal, mode)
            object.signal = signal;
            object.multiple_window(mode);
        end
        %% ------------------- Setters ------------------- %%
        function set.signal(object, signal)
            if length(signal) <= 0
                thorw(MException("Setter:signal", "signal length is smaller than 0"))
            end
            object.signal = signal;
        end

        function set.autocorrelations(object, autocorrelations)
            if length(autocorrelations) <= 0
                thorw(MException("Setter:autocorrelations", "autocorrelations length is smaller than 0"));
            end
            object.autocorrelations = autocorrelations;
        end

        function set.power_spectrum(object, power_spectrum)
            if length(power_spectrum) < 0
                thorw(MException("Setter:power_spectrum", "power spectrum length is smaller than 0"));
            end
            object.power_spectrum = power_spectrum;
        end
        %% ------------------- Getters ------------------- %%
        function signal = get.signal(object)
            signal = object.signal;
        end

        function autocorrelations = get.autocorrelations(object)
            autocorrelations = object.autocorrelations;
        end

        function power_spectrum = get.power_spectrum(object)
            power_spectrum = object.power_spectrum;
        end
        %% ---------------- Usual methods ---------------- %%
        % method to get hamming window
        function hamming_window = get_hamming_window(object)
            hamming_window = 0.54 - 0.46 * cos(2 * (0 : length(object.signal) - 1)' * pi / (length(object.signal) - 1));
        end
        
        % method to multiple each window
        function multiple_window(object, mode)
            if mode == "hamming"
                object.signal = object.signal .* object.get_hamming_window();
            else
                throw(MException("Setter:mode", "mode exception error : use hamming or hanning or blackman"));
            end
        end

        % method to calculate auto correlations(Not recomend)
        function calculate_autocorrelations(object)
            fprintf("------------- Auto Correlation Calculation Start --------------\n");
            object.autocorrelations = zeros(length(object.signal), 1);
            for shift_index = 0 : length(object.signal) - 1
                sumation = 0;   % make sumation vaiable
                for time_index = 0 : length(object.signal) - shift_index - 1
                    sumation = sumation + object.signal(time_index + 1) * object.signal(rem(time_index + shift_index, length(object.signal) - 1) + 1);
                end
                object.autocorrelations(shift_index + 1) = sumation / length(object.signal);
                % output progress if shift_index has no remainder of 100
                if rem(shift_index, 100) == 0
                    fprintf("[%d / %d] Finish Shift Point of Auto Correlation.\n", shift_index, length(object.signal));
                end
            end
            fprintf("---------------------------------------------------------------\n\n");
        end

        % method to calculate auto correlations with fourier transform
        function calculate_autocorrelations_with_fourier(object, fft_point)
            fft_signal = fft(object.signal, fft_point);
            object.power_spectrum = (abs(fft_signal) .^ 2) / length(object.signal);
            autocorrelation = ifft(object.power_spectrum);
            object.autocorrelations = autocorrelation(1 : length(object.signal));
        end

        % method to calculate power spectrum
        function calculate_power_spectrum(object)
            for index = 1 : length(object.autocorrelations) / 2
                object.autocorrelations(length(object.autocorrelations) - index + 1) = object.autocorrelations(index);
            end
            object.power_spectrum = abs(fft(object.autocorrelations));
        end

        % method to display properties
        function display_properties(object)
            fprintf("---------- Auto correlation function ----------\n");
            fprintf("signal shape : (%d, %d)\n", size(object.signal));
            fprintf("auto correlations shape : (%d, %d)\n", size(object.autocorrelations));
            fprintf("power spectrum shape : (%d, %d)\n", size(object.power_spectrum));
            fprintf("-----------------------------------------------\n\n");
        end

        % method to plot auto correlations
        function plot_autocorrelations(object)
            plot(object.autocorrelations);
        end
    end
end