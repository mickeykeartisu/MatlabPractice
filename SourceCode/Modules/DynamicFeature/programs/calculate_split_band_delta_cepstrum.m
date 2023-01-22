function delta_cepstrum = calculate_split_band_delta_cepstrum(delta_cepstrum, band_range, fft_point, sample_rate)
    % -------------------------------------------------------------------
    % args : 
    %   delta_cepstrum : [quefrency, frame]
    %   band_range : [lower_limit_frequency, upper_limit_frequency]
    %   fft_point : [point]
    %   sample_rate : [Hz]
    % -------------------------------------------------------------------
    delta_cepstrum = cat(1, delta_cepstrum, flip(delta_cepstrum));
    delta_cepstrum = real(fft(delta_cepstrum, fft_point));
    lower_limit_point = int64((fft_point / 2) * band_range(1) / (sample_rate / 2));
    upper_limit_point = int64((fft_point / 2) * band_range(2) / (sample_rate / 2));
    delta_cepstrum(1 : (lower_limit_point - 1), :) = 0;
    delta_cepstrum((upper_limit_point + 1) : end, :) = 0;
    delta_cepstrum(int64(fft_point / 2) + 2 : end, :) = flip(delta_cepstrum(2 : int64(fft_point / 2), :), 1);
    % delta_cepstrum = real(ifft(delta_cepstrum, quefrency_length));
    delta_cepstrum = real(ifft(delta_cepstrum));
    % delta_cepstrum = delta_cepstrum(1 : int64(quefrency_length), :);
end