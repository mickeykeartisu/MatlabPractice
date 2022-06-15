%% Function to get cepstrum impulse response
% cepstrumPoint : point(dimension) to use liftering
% FFTPoint : FFT point
% sourceFilePath : source file path
% samplingRate : sampling frequency
% dataType : data type about original signal
% startPoint : first point to extract data from original data
% time : time would like to extract range
function [peakPointOfCepstrum, imulseResponseOfCepstrum] = getImpulseResponseOfCepstrum(cepstrumPoint, FFTPoint, sourceFilePath, dataType, samplingRate, startPoint, time, thresholdValue)
    %% Function to clear enviornments
    clearEnviornments();

    % Extract signal from original signal
    extractedSignal = getExtractedSignal( ...
        startPoint, ... % start point
        time, ...   % time
        samplingRate, ...   % sampling frequency
        sourceFilePath, ...   % file path
        dataType ...    % data type
    );

    % Generate extracted signal multipled hamming window
    windowedSignal = getExtractedSignalMultipledHammingWindow( ...
        extractedSignal ... % extracted signal
    );

    % Transform from windowed signal to amplitude spectral
    linearAmplitudedSpectral = getLinearAmplitudedSpectral( ...
        windowedSignal, ...  % windowed signal
        FFTPoint...    % FFT point
    );
    
    % Transform from amplitude spectral to cepstrum
    cepstrum = getCepstrum( ...
        linearAmplitudedSpectral ...   % amplituded spectral
    );
    
    % Get cepstrum peak point
    peakPointOfCepstrum = getPeakPointOfCepstrum( ...
        cepstrum, ...  % cepstrum
        cepstrumPoint, ...    % cepstrum point (dimension)
        FFTPoint, ...   % FFT point
        thresholdValue ... % value to judge voiced sound or not
    );

    % Get basic period and basic frequency
    [basicPeriod, basicFrequency] = getBasicPeriodAndBasicFrequency( ...
        peakPointOfCepstrum, ...    % peak point of cepstrum
        samplingRate ...   % sampling frequency
    );
    
    % Get low quefrency(liftering)
    lowQuefrency = getLowQuefrency( ...
        cepstrum, ...  % cepstrum
        cepstrumPoint, ...    % cepstrum point (dimension)
        FFTPoint ...   % FFT point
    );
    
    % Transform from low quefrency to linear amplituded spectral envelope
    linearAmplitudedSpectralEnvelope = getLinearAmplitudedSpectralEnvelope( ...
        lowQuefrency, ...  % low quefrency
        FFTPoint ...   % FFT point
    );

    % Transform from linear amplituded spectral envelope to impulse response of cepstrum
    imulseResponseOfCepstrum = getImpulseResponse( ...
        linearAmplitudedSpectralEnvelope, ...  % linear amplituded spectral envelope
        FFTPoint ...   % FFT Point
    );
end

