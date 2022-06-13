%% Function to get real part of inversed fast fourier transform
% linearAmplitudedSpectral : input amplituded spectral
function [cepstrum] = getCepstrum(linearAmplitudedSpectral)
    naturalLogarithmAmplitutedSpectral = log(linearAmplitudedSpectral);   % natural log
    inverseFastFourierTransformedSignal = ifft(naturalLogarithmAmplitutedSpectral); % IFFT
    cepstrum = real(inverseFastFourierTransformedSignal);   % get real part
end