%% Function to get amplituded spectral
% FFTPoint : size to conduct Fast Fourier Transform
% windowedSignal : signal multipled window
function [linearAmplitudedSpectral] = getLinearAmplitudedSpectral(windowedSignal, FFTPoint)
    fastFourierTransformedSignal = fft(windowedSignal, FFTPoint);   % FFT
    linearAmplitudedSpectral = sqrt(abs(real(fastFourierTransformedSignal) .^ 2 + imag(fastFourierTransformedSignal) .^ 2));  % get amplituded spectral
end