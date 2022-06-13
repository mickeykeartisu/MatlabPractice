%% Function to get low quefrency(liftering)
% cepstrum : cepstrum signal
% cepstrumPoint : point(dimension) to use liftering
% FFTPoint : FFT point
function [lowQuefrency] = getLowQuefrency(cepstrum, cepstrumPoint, FFTPoint)
    lowQuefrency = cepstrum;    % low quefrency
    lowQuefrency(cepstrumPoint + 1:FFTPoint - cepstrumPoint) = 0;
end