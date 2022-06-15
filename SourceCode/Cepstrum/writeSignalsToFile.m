%% Function to write signals to file
function writeSignalsToFile(filePath, dataType, usualSignal, halfSignal, doubleSignal)
    writeSignalToFile(filePath+"synthesizedSignal.raw", dataType, usualSignal);
    writeSignalToFile(filePath+"synthesizedSignalHalf.raw", dataType, halfSignal);
    writeSignalToFile(filePath+"synthesizedSignalDouble.raw", dataType, doubleSignal);
end