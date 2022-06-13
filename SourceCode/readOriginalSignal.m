%% Function to open and read signal
% sourceFilePath : source file path would like to open
% dataType : data type
function [originalSignal] = readOriginalSignal(sourceFilePath, dataType)
    openedFile = openFile(sourceFilePath, "r");    % open file
    originalSignal = fread(openedFile, dataType);   % read original signal
    closeFile(openedFile);    % close file
end