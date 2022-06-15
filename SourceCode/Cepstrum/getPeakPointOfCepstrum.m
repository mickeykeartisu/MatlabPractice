%% Function to get peak point of cepstrum(high dimension point)
% cepstrum : cepstrum signal
% cepstrumPoint : point(dimension) to use liftering
% FFTPoint : FFT point
function [peakPointOfCepstrum] = getPeakPointOfCepstrum(cepstrum, cepstrumPoint, FFTPoint, thresholdValue)
    [maxValue, peakPointOfCepstrum] = max(cepstrum(cepstrumPoint : FFTPoint / 2)); % search max value index
    peakPointOfCepstrum = checkVoicedSpeech(maxValue, peakPointOfCepstrum + cepstrumPoint - 1, thresholdValue);
end