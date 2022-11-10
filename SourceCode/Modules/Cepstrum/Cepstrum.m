%% class to conduct cepstrum analysis
classdef Cepstrum < handle
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
        amplitude_spectrum
        cepstrum
        liftering_order % [ms]
        voicing_threshold
        basic_period
        basic_frequency
        amplitude_spectrum_envelope
        impulse_response
        repeat_number
        basic_period_gain
        synthesized_signal
    end

    %% ---------- methods ---------- %%
    methods
        %% ---------- default constructor ---------- %%
        function object = Cepstrum(signal, sample_rate, window_mode, liftering_order, voicing_threshold, fft_point, repeat_number, basic_period_gain)
            switch nargin
                case 2
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = "hamming";
                    object.fft_point = 1;
                    object.liftering_order = 2;
                    object.voicing_threshold = 0.01;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 3
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.fft_point = 1;
                    object.liftering_order = 2;
                    object.voicing_threshold = 0.01;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 4
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.fft_point = 1;
                    object.voicing_threshold = 0.01;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 5
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = 1;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 6
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = fft_point;
                    object.repeat_number = 10;
                    object.basic_period_gain = 1;
                case 7
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.fft_point = fft_point;
                    object.repeat_number = repeat_number;
                    object.basic_period_gain = 1;
                case 8
                    object.signal = signal;
                    object.sample_rate = sample_rate;
                    object.window_mode = window_mode;
                    object.fft_point = fft_point;
                    object.liftering_order = liftering_order;
                    object.voicing_threshold = voicing_threshold;
                    object.repeat_number = repeat_number;
                    object.basic_period_gain = basic_period_gain;
                otherwise
                    throw(MException("Constructor:arguments", "arguments is not correct, please input 2, 3, 4, 5, 6, 7 or 8 arguments."));
            end

            object.multiple_window(object.window_mode);
            object.calculate_amplitude_spectrum();
            object.calculate_cepstrum();
            object.calculate_basic_period_and_basic_frequency();
            object.liftering();
            object.calculate_amplitude_spectrum_envelope();
            object.calculate_impulse_response();
            object.synthesize_signal();
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

        % sample_rate setter
        function set.sample_rate(object, sample_rate)
            if sample_rate < 1
                throw(MException("Setter:sample_rate", "sample_rate is smaller than 1."));
            end
            object.sample_rate = sample_rate;
        end

        % fft_point setter
        function set.fft_point(object, fft_point)
            if fft_point < 1
                throw(MException("Setter:fft_point", "fft_point is smaller than 1."));
            end
            object.fft_point = fft_point;
        end

        % liftering_order setter
        function set.liftering_order(object, liftering_order)
            if liftering_order < 0
                throw(MException("Setter:liftering_order", "liftering_order is smaller than 0."));
            end
            object.liftering_order = int64(liftering_order * object.sample_rate / 1000);
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

        % amplitude_spectrum setter
        function set.amplitude_spectrum(object, amplitude_spectrum)
            if length(amplitude_spectrum) < 1
                throw(MException("Setter:amplitude_spectrum", "amplitude_spectrum length is smaller than 1."));
            end
            object.amplitude_spectrum = amplitude_spectrum;
        end

        % cepstrum setter
        function set.cepstrum(object, cepstrum)
            if length(cepstrum) < 1
                throw(MException("Setter:cepstrum", "cepstrum length is smaller than 1."));
            end
            object.cepstrum = cepstrum;
        end

        % amplitude_spectrum_envelope setter
        function set.amplitude_spectrum_envelope(object, amplitude_spectrum_envelope)
            if length(amplitude_spectrum_envelope) < 1
                throw(MException("Setter:amplitude_spectrum_envelope", "amplitude_spectrum_envelope length is smaller than 1."));
            end
            object.amplitude_spectrum_envelope = amplitude_spectrum_envelope;
        end

        % basic_period setter
        function set.basic_period(object, basic_period)
            if basic_period < 0
                throw(MException("Setter:basic_period", "basic_period is smaller than 0."));
            end
            object.basic_period = basic_period;
        end

        % basic_frequency setter
        function set.basic_frequency(object, basic_frequency)
            if basic_frequency < 0
                throw(MException("Setter:basic_frequency", "basic_frequency is smaller than 0."));
            end
            object.basic_frequency = basic_frequency;
        end

        % impulse_response setter
        function set.impulse_response(object, impulse_response)
            if length(impulse_response) < 1
                throw(MException("Setter:impulse_response", "impulse_response length is smaller than 1."));
            end
            object.impulse_response = impulse_response;
        end

        % synthesized_signal setter
        function set.synthesized_signal(object, synthesized_signal)
            if length(synthesized_signal) < 1
                throw(MException("Setter:synthesized_signal", "synthesized_signal length is smaller than 1."));
            end
            object.synthesized_signal = synthesized_signal;
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

        % sample_rate getter
        function sample_rate = get.sample_rate(object)
            sample_rate = object.sample_rate;
        end

        % fft_point getter
        function fft_point = get.fft_point(object)
            fft_point = object.fft_point;
        end

        % amplitude_spectrum getter
        function amplitude_spectrum = get.amplitude_spectrum(object)
            amplitude_spectrum = object.amplitude_spectrum;
        end

        % cepstrum getter
        function cepstrum = get.cepstrum(object)
            cepstrum = object.cepstrum;
        end

        % liftering_order getter
        function liftering_order = get.liftering_order(object)
            liftering_order = object.liftering_order;
        end

        % voicing_threshold getter
        function voicing_threshold = get.voicing_threshold(object)
            voicing_threshold = object.voicing_threshold;
        end

        % basic_period getter
        function basic_period = get.basic_period(object)
            basic_period = object.basic_period;
        end

        % basic_frequency getter
        function basic_frequency = get.basic_frequency(object)
            basic_frequency = object.basic_frequency;
        end

        % amplitude_spectrum_envelope getter
        function amplitude_spectrum_envelope = get.amplitude_spectrum_envelope(object)
            amplitude_spectrum_envelope = object.amplitude_spectrum_envelope;
        end

        % impulse_response getter
        function impulse_response = get.impulse_response(object)
            impulse_response = object.impulse_response;
        end

        % repeat_number getter
        function repeat_number = get.repeat_number(object)
            repeat_number = object.repeat_number;
        end

        % synthesized_signal getter
        function synthesized_signal = get.synthesized_signal(object)
            synthesized_signal = object.synthesized_signal;
        end

        % basic_period_gain getter
        function basic_period_gain = get.basic_period_gain(object)
            basic_period_gain = object.basic_period_gain;
        end

        %% ---------- usual method ---------- %%
        % method to multiple signal and window
        function multiple_window(object, window_mode)
            if window_mode == "hamming"
                object.signal = hamming(length(object.signal)) .* object.signal;
            end
        end

        % method to get fft_point
        function calculate_fft_point(object)
            object.fft_point = 1;
            while object.fft_point < length(object.signal) * 2
                object.fft_point = object.fft_point * 2;
            end
        end

        % method to liftering
        function liftering(object)
            object.cepstrum(object.liftering_order + 1 : object.fft_point - object.liftering_order) = 0;
        end

        % method to calculate amplitude spectrum
        function calculate_amplitude_spectrum(object)
            object.calculate_fft_point();
            fastFourierTransformedSignal = fft(object.signal, object.fft_point);
            object.amplitude_spectrum = abs(fastFourierTransformedSignal);
        end

        % method to calculate cepstrum
        function calculate_cepstrum(object)
            naturalLogarithmAmplitutedSpectral = log(object.amplitude_spectrum);
            inverseFastFourierTransformedSignal = ifft(naturalLogarithmAmplitutedSpectral);
            object.cepstrum = real(inverseFastFourierTransformedSignal);
        end

        % method to calculate basic period and basic frequency
        function calculate_basic_period_and_basic_frequency(object)
            [peak_value, peak_point] = max(object.cepstrum(object.liftering_order : object.fft_point / 2));
            peak_point = peak_point + object.liftering_order - 1;
            if peak_value >= object.voicing_threshold
                object.basic_period = double(peak_point) / object.sample_rate;
                object.basic_frequency = 1 / object.basic_period;
            else
                object.basic_period = 0;
                object.basic_frequency = 0;
            end
        end

        % method to calculate amplitude spectrum envelope
        function calculate_amplitude_spectrum_envelope(object)
            spectralEnvelope = fft(object.cepstrum, object.fft_point);
            amplitutedSpectralEnvelope = real(spectralEnvelope);
            object.amplitude_spectrum_envelope = exp(amplitutedSpectralEnvelope);
        end

        % method to calculate impulse response
        function calculate_impulse_response(object)
            realPartOfLinearAmplitutedSpectralEnvelope = real(object.amplitude_spectrum_envelope);
            inverseFourierTransformedSignal = ifft(realPartOfLinearAmplitutedSpectralEnvelope, object.fft_point);
            realPartOfInverseFourierTransformedSignal = real(inverseFourierTransformedSignal);
            object.impulse_response = fftshift(realPartOfInverseFourierTransformedSignal);
        end

        % method to get amplitude_spectrum(dB)
        function amplitude_spectrum_dB = get_amplitude_spectrum_dB(object)
            amplitude_spectrum_dB = object.amplitude_spectrum(1 : floor(object.fft_point / 2) + 1);
            amplitude_spectrum_dB = 20 * log10(amplitude_spectrum_dB);
        end

        % method to get amplitude_spectrum_envelope(dB)
        function amplitude_spectrum_envelope_dB = get_amplitude_spectrum_envelope_dB(object)
            amplitude_spectrum_envelope_dB = object.amplitude_spectrum_envelope(1 : floor(object.fft_point / 2) + 1);
            amplitude_spectrum_envelope_dB = 20 * log10(amplitude_spectrum_envelope_dB);
        end

        % method to synthesize signal
        function synthesize_signal(object)
            peak_point = floor(object.basic_period * object.sample_rate);
            object.synthesized_signal = zeros([floor(peak_point * object.basic_period_gain * object.repeat_number + object.fft_point), 1]);

            for index = 1 : object.repeat_number
                object.synthesized_signal(floor(peak_point * object.basic_period_gain * (index - 1) + 1) : floor(peak_point * object.basic_period_gain * (index - 1) + object.fft_point)) ...
                = object.synthesized_signal(floor(peak_point * object.basic_period_gain * (index - 1) + 1) : floor(peak_point * object.basic_period_gain * (index - 1) + object.fft_point)) ...
                + object.impulse_response(1 : object.fft_point);
            end

            object.synthesized_signal = object.synthesized_signal(floor(object.fft_point / 2.6) : end);
            object.synthesized_signal = object.synthesized_signal(1 : end - floor(object.fft_point / 2.1));
        end

        % method to display properties
        function display_properties(object)
            fprintf("----------------------------------------------\n");
            fprintf("------------------ Cepstrum ------------------\n");
            fprintf("signal size : (%d, %d)\n", size(object.signal));
            fprintf("sample_rate : %d [Hz]\n", object.sample_rate);
            fprintf("window_mode : %s\n", object.window_mode);
            fprintf("fft_point : %d\n", object.fft_point);
            fprintf("amplitude_spectrum size : (%d, %d)\n", size(object.amplitude_spectrum));
            fprintf("liftering_order : %d\n", object.liftering_order);
            fprintf("voicing_threshold : %f\n", object.voicing_threshold);
            fprintf("cepstrum size : (%d, %d)\n", size(object.cepstrum));
            fprintf("basic_period : %f [s]\n", object.basic_period);
            fprintf("basic_frequency : %f [Hz]\n", object.basic_frequency);
            fprintf("linear amplituded spectral envelope shape : (%d, %d)\n", size(object.amplitude_spectrum_envelope));
            fprintf("impulse response of cepstrum shape : (%d, %d)\n", size(object.impulse_response));
            fprintf("repeat_number : %d\n", object.repeat_number);
            fprintf("basic_period_gain : %f\n", object.basic_period_gain);
            fprintf("synthesized signal size : (%d, %d)\n", size(object.synthesized_signal));
            fprintf("----------------------------------------------\n\n");
        end
    end
end