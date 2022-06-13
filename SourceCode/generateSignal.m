%% Function to generate weight convolution
% peakPointOfCepstrum : peak point (basic period)
% FFTPoint : FFT Point
% imulseResponseOfCepstrum : impulse response of cepstrum
function [generatedSignal] = generateSignal(peakPointOfCepstrum, FFTPoint, imulseResponseOfCepstrum, repeatSize)
    generatedSignal = zeros([peakPointOfCepstrum * repeatSize + FFTPoint, 1]);  % synthesized signal
    for index = 0 : repeatSize
        generatedSignal(peakPointOfCepstrum * index + 1 : peakPointOfCepstrum * index + FFTPoint) = generatedSignal(peakPointOfCepstrum * index + 1 : peakPointOfCepstrum * index + FFTPoint) + imulseResponseOfCepstrum(1 : FFTPoint);
    end
end