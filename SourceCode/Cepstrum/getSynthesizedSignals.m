%% Function to generate signals
function [usualSignal, halfSignal, doubleSignal] = getSynthesizedSignals(peakPointOfCepstrum, FFTPoint, imulseResponseOfCepstrum, repeatSize)
    % generate speech synthesis
    usualSignal = generateSignal( ...
        peakPointOfCepstrum, ...    % peak point of cepstrum
        FFTPoint, ...   % FFT point
        imulseResponseOfCepstrum, ...   % impulse response
        repeatSize ... % repeat size
    );

    % generate speech synthesis
    halfSignal = generateSignal( ...
        peakPointOfCepstrum / 2, ...    % peak point of cepstrum
        FFTPoint, ...   % FFT point
        imulseResponseOfCepstrum, ...   % impulse response
        repeatSize ... % repeat size
    );

    % generate speech synthesis
    doubleSignal = generateSignal( ...
        peakPointOfCepstrum * 2, ...    % peak point of cepstrum
        FFTPoint, ...   % FFT point
        imulseResponseOfCepstrum, ...   % impulse response
        repeatSize ... % repeat size
    );
end