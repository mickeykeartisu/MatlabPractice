%% Function to transform from low quefrency to linear amplituded spectral envelope
% lowQuefrency : low quefrency vector
% FFTPoint : FFT point
function [linearAmplitudedSpectralEnvelope] = getLinearAmplitudedSpectralEnvelope(lowQuefrency, FFTPoint)
    spectralEnvelope = fft(lowQuefrency, FFTPoint); % get spectral envelope
    amplitutedSpectralEnvelope = sqrt(abs(real(spectralEnvelope) .^ 2 + imag(spectralEnvelope) .^ 2));  % transform to amplituded spectral envelope
    linearAmplitudedSpectralEnvelope = exp(amplitutedSpectralEnvelope); % return from natural logarithm to linear
end