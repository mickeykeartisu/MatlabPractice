%% Function to judge voiced or not sound
% maxValue : max value of cepstrum
% peakPointOfCepstrum : peak point of cepstrum(dimension)
% thresholdValue : value of threshold that judge voiced or not voiced sound
function [peakPointOfCepstrum] = checkVoicedSpeech(maxValue, peakPointOfCepstrum, thresholdValue)
    if maxValue < thresholdValue
        peakPointOfCepstrum = 0;
    end
    