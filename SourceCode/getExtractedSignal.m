%% Function to extract signal from original signal
% samplingRate : sampling frequency [Hz]
% startPoint : first point to extract from original data
% time : time would like to extract range [s]
% sourceFilePath : source file path would like to open
% dataType : data type
function [extractedSignal] = getExtractedSignal(startPoint, time, samplingRate, sourceFilePath, dataType)
    windowSize = floor(time * samplingRate);    % window Size
    originalSignal = readOriginalSignal(sourceFilePath, dataType);    % read original signal
    extractedSignal = originalSignal(startPoint : startPoint + windowSize - 1); % extract signal
end
