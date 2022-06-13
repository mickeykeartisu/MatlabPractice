%% Function to write signal to file
function writeSignalToFile(filePath, dataType, synthesizedSpeechSignal)
    openedFile = openFile(filePath, "w");    % open file
    fwrite(openedFile, synthesizedSpeechSignal, dataType);   % write signal
    closeFile(openedFile);    % close file
end