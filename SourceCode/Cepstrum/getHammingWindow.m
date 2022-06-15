%% Function to get hamming window
% windowSize : hamming window size
function [hammingWindow] = getHammingWindow(windowSize)
    hammingWindow = 0.54 - 0.46 * cos(2 * (0 : windowSize - 1)' * pi / (windowSize - 1));
end