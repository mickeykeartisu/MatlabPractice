function [stfObject] = createSTFObject(samplingFrequency, f0ShiftMs, f0, apShiftMs, aperiodicity, ...
				       shiftMs, spectrogram)
%CREATESTFOBJECT  Create STRAIGHT-format object.
%	STFOBJECT = CREATESTFOBJECT(SAMPLINGFREQUENCY, F0SHIFTMS, F0, APSHIFTMS, APERIODICITY, SHIFTMS, SPECTROGRAM)
%	STFOBJECT = CREATESTFOBJECT(SAMPLINGFREQUENCY, F0TEMPORALPOSITIONS, F0, APTEMPORALPOSITIONS, APERIODICITY, TEMPORALPOSITIONS, SPECTROGRAM)
%	SAMPLINGFREQUENCY: sampling frequency
%	F0SHIFTMS:      frame shift of F0 in msec
%	F0:             F0 data
%	APSHIFTMS:      frame shift of aperiodicity in msec
%	APERIODICITY:   aperiodicity measure in dB
%	SHIFTMS:        frame shift of spectrogram in msec
%	SPECTROGRAM:    spectrogram
%	F0TEMPORALPOSITIONS:    temporal positions of F0 in sec
%	APTEMPORALPOSITIONS:    temporal positions of aperiodicity in sec
%	TEMPORALPOSITIONS:      temporal positions of spectrogram in sec

stfObject = struct([]);
stfObject(1).numberOfChannels = 1;
stfObject(1).samplingFrequency = samplingFrequency;
if ~isempty(f0)
    if length(f0) == length(f0ShiftMs)
	stfObject(1).f0TemporalPositions = f0ShiftMs;
    else
	stfObject(1).f0ShiftMs = f0ShiftMs;
    end
    
    stfObject(1).f0 = f0;
end
if ~isempty(aperiodicity)
    if size(aperiodicity, 2) == length(apShiftMs)
	stfObject(1).aperiodicityTemporalPositions = apShiftMs;
    else
	stfObject(1).aperiodicityShiftMs = apShiftMs;
    end

    if size(aperiodicity, 1) == 2
        stfObject(1).sigmoidParameter = aperiodicity;
    else
        stfObject(1).aperiodicity = aperiodicity;
    end
end
if ~isempty(spectrogram)
    if size(spectrogram, 2) == length(shiftMs) 
	stfObject(1).temporalPositions = shiftMs;
    else
	stfObject(1).shiftMs = shiftMs;
    end
    
    stfObject(1).spectrogram = spectrogram;
end
