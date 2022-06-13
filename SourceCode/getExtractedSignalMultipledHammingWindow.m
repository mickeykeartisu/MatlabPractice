%% Function to get extracted signal multipled hamming window
% extractedSignal : extracted signal from original signal
function [extractedSignalMultipledHammingWindow] = getExtractedSignalMultipledHammingWindow(extractedSignal)
    extractedSignalMultipledHammingWindow = extractedSignal .* getHammingWindow(length(extractedSignal));
end