%% Function to judge voiced or not sound
function [peakPointOfCepstrum] = checkVoicedSpeech(maxValue, peakPointOfCepstrum, thresholdValue)
    if maxValue < thresholdValue
        peakPointOfCepstrum = 0;
    end
    