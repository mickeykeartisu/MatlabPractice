%% Function to generate impulse response
% linearAmplitudedSpectralEnvelope : linear amplituded spectral envelope vector
% FFTPoint : FFT point
function [impulseResponse] = getImpulseResponse(linearAmplitudedSpectralEnvelope, FFTPoint)
    realPartOfLinearAmplitutedSpectralEnvelope = real(linearAmplitudedSpectralEnvelope);  % extract real part
    inverseFourierTransformedSignal = ifft(realPartOfLinearAmplitutedSpectralEnvelope, FFTPoint);    % IFFT
    realPartOfInverseFourierTransformedSignal = real(inverseFourierTransformedSignal);  % extract real part
    impulseResponse = fftshift(realPartOfInverseFourierTransformedSignal);  % fft shift
end