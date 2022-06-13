%% Fucnction to get basic period and basic frequency
% peakPointOfCepstrum : peak point (basic period)
function [basicPeriod, basicFrequency] = getBasicPeriodAndBasicFrequency(peakPointOfCepstrum, samplingRate)
    basicPeriod = peakPointOfCepstrum / samplingRate; % basic period
    basicFrequency = 1 / basicPeriod;  % basic frequency
end