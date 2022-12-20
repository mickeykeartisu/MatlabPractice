function modulation_frequency_spectrum = calculate_modulation_frequency_spectrum(spectrogram, cepstrum_order, frame_length, hop_length, fft_length)
    % if cepstrum_order is not inputted, set cepstrum_order to 10
    if ~exist("cepstrum_order", "var")
        cepstrum_order = 10;
    end

    % if frame_length is not inputted, set frame_length to 128
    if ~exist("frame_length", "var")
        frame_length = 128;
    end

    % if hop_length is not inputted, set hop_length to 1
    if ~exist("hop_length", "var")
        hop_length = 1;
    end

    % if fft_length is not inputted, set fft_length to 8192
    if ~exist("fft_length", "var")
        fft_length = 2 ^ 13;
    end

    modulation_frequency_spectrum = zeros(cepstrum_order, fft_length);
    cepstrum = getSt2Cep(spectrogram);
    
    for cepstrum_order_index = 1 : cepstrum_order
        power_spectrum = zeros(size(cepstrum, 2) - (frame_length / hop_length) ,fft_length);
        frame_pos = 1;
        for i = 0 : size(power_spectrum, 1) - 1
            frame_end = frame_pos + frame_length - 1;
            frame = cepstrum(cepstrum_order_index, frame_pos : frame_end);
            frame = frame - mean(frame);
            frame = frame .* hamming(frame_length)';
            amplitude_spectrum = abs(fft(frame, fft_length));
            power_spectrum(i + 1, :) = amplitude_spectrum .^ 2;
            frame_pos = frame_pos + hop_length;
        end
        modulation_frequency_spectrum(cepstrum_order_index, :) = mean(power_spectrum, 1);
    end
end