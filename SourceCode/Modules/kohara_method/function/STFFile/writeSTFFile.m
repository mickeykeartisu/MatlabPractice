function totalCount = writeSTFFile(filename, stfObject, machineFormat, bitsPerSample, weight)
%WRITESTFFILE  Write STRAIGHT format file.
%	TOTALCOUNT = WRITESTFFILE(FILENAME, OBJECT, MACHINEFORMAT, BITSPERSAMPLE, WEIGHT);
%	TOTALCOUNT = WRITESTFFILE(FILENAME, OBJECT, MACHINEFORMAT);
%	TOTALCOUNT = WRITESTFFILE(FILENAME, OBJECT);
%	TOTALCOUNT:     total bytes written 
%	FILENAME:       file name
%	OBJECT:		input STRAIGHT-format object or TANDEM-STRAIGHT object
%	MACHINEFORMAT:  machine format of the file; 'n': native, 'l': little endian, 'b': big endian
%	BITSPERSAMPLE:  bits/sample of data in the file; the value 33 means 32 bit float.
%	WEIGHT:         optional weight for data in the file; 
%	                the data value in reading the file is divided by this weight 

if isfield(stfObject, 'refinedF0Structure') || isfield(stfObject, 'AperiodicityStructure') ...
        || isfield(stfObject, 'SpectrumStructure')
    tandemObjectFlag = true;
else
    tandemObjectFlag = false;
end
if nargin < 5
    weight = 1.0;
end
if nargin < 4
    bitsPerSample = 64;
end
if nargin < 3
    machineFormat = 'n';
end

totalCount = 0;

fid = fopen(filename, 'w', machineFormat);
if fid == -1
    return;
end

fileId = 'STRT';
endianId = 65279; % 0xfeff
headerSize = 8;
formatId = 0;

f0 = [];
uvf0 = [];
periodicityLevel = [];
sigmoidParameter = [];
aperiodicity = [];
spectrogram = [];
f0CandidatesParams = [];
numberOfCandidates = 0;

if tandemObjectFlag
    if isfield(stfObject, 'samplingFrequency')
        samplingFrequency = stfObject.samplingFrequency;
    else
        samplingFrequency = 8000;
    end
    numberOfChannels = 1;
    
    if isfield(stfObject, 'refinedF0Structure')
        samplingFrequency = stfObject.refinedF0Structure.samplingFrequency;
        f0ShiftMs = stfObject.refinedF0Structure.temporalPositions;
        if isfield(stfObject.refinedF0Structure, 'vuv')
            f0 = stfObject.refinedF0Structure.f0 .* double(stfObject.refinedF0Structure.vuv);
            uvf0 = stfObject.refinedF0Structure.f0;
        else
            f0 = stfObject.refinedF0Structure.f0;
        end
        periodicityLevel = stfObject.refinedF0Structure.periodicityLevel;
        
        if isfield(stfObject.refinedF0Structure, 'f0CandidatesMap')
            numberOfCandidates = size(stfObject.refinedF0Structure.f0CandidatesMap, 1);
            % f0'c'andidatesPowerMap is specification of the MATLAB version.
            if isfield(stfObject.refinedF0Structure, 'f0candidatesPowerMap')
                f0CandidatesParams = zeros(numberOfCandidates * 3, ...
                                           size(stfObject.refinedF0Structure.f0CandidatesMap, 2));
                f0CandidatesParams(numberOfCandidates*2+1:numberOfCandidates*3, :) = stfObject.refinedF0Structure.f0candidatesPowerMap;
            else
                f0CandidatesParams = zeros(numberOfCandidates * 2, ...
                                           size(stfObject.refinedF0Structure.f0CandidatesMap, 2));
            end
            f0CandidatesParams(1:numberOfCandidates, :) = stfObject.refinedF0Structure.f0CandidatesMap;
            f0CandidatesParams(numberOfCandidates+1:numberOfCandidates*2, :) = stfObject.refinedF0Structure.f0CandidatesScoreMap;
        end
    end
    if isfield(stfObject, 'AperiodicityStructure')
        samplingFrequency = stfObject.refinedF0Structure.samplingFrequency;
        apShiftMs = stfObject.AperiodicityStructure.temporalPositions;
        if isfield(stfObject.AperiodicityStructure, 'sigmoidParameter')
            sigmoidParameter = stfObject.AperiodicityStructure.sigmoidParameter;
        else
            aperiodicity = calculateRandomComponent(stfObject.AperiodicityStructure, fftl);
            aperiodicity = 20.0 * log10(aperiodicity);
        end
    end
    if isfield(stfObject, 'SpectrumStructure')
        samplingFrequency = stfObject.refinedF0Structure.samplingFrequency;
        shiftMs = stfObject.SpectrumStructure.temporalPositions;
        spectrogram = sqrt(stfObject.SpectrumStructure.spectrogramSTRAIGHT);
    end
else
    if isfield(stfObject, 'f0TemporalPositions')
        f0ShiftMs = stfObject.f0TemporalPositions;
    elseif isfield(stfObject, 'f0ShiftMs')
        f0ShiftMs = stfObject.f0ShiftMs;
    elseif isfield(stfObject, 'f0shiftm')
        f0ShiftMs = stfObject.f0shiftm;
    end
    if isfield(stfObject, 'temporalPositions')
        shiftMs = stfObject.temporalPositions;
    elseif isfield(stfObject, 'shiftMs')
        shiftMs = stfObject.shiftMs;
    elseif isfield(stfObject, 'shiftm')
        shiftMs = stfObject.shiftm;
    end
    if isfield(stfObject, 'aperiodicityTemporalPositions')
        apShiftMs = stfObject.aperiodicityTemporalPositions;
    elseif isfield(stfObject, 'aperiodicityShiftMs')
        apShiftMs = stfObject.aperiodicityShiftMs;
    elseif isfield(stfObject, 'apshiftm')
        apshiftMs = stfObject.apshiftm;
    end

    if isfield(stfObject, 'numberOfChannels')
        numberOfChannels = stfObject.numberOfChannels;
    else
        numberOfChannels = 1;
    end
    if isfield(stfObject, 'samplingFrequency')
        samplingFrequency = stfObject.samplingFrequency;
    elseif isfield(stfObject, 'fs')
        samplingFrequency = stfObject.fs;
    else
        samplingFrequency = 8000.0;
    end
    
    if isfield(stfObject, 'f0')
        f0 = stfObject.f0;
    end
    if isfield(stfObject, 'uvf0')
        uvf0 = stfObject.uvf0;
    end
    if isfield(stfObject, 'periodicityLevel')
        periodicityLevel = stfObject.periodicityLevel;
    end
    if isfield(stfObject, 'sigmoidParameter')
        sigmoidParameter = stfObject.sigmoidParameter;
    elseif isfield(stfObject, 'aperiodicity')
        aperiodicity = stfObject.aperiodicity;
    end
    if isfield(stfObject, 'spectrogram')
        spectrogram = stfObject.spectrogram;
    end
end

count = fwrite(fid, fileId, 'schar'); totalCount = totalCount + count;
count = fwrite(fid, endianId, 'uint16'); totalCount = totalCount + 2 * count;
count = fwrite(fid, headerSize, 'uint32'); totalCount = totalCount + 4 * count;
count = fwrite(fid, formatId, 'uint16'); totalCount = totalCount + 2 * count;
count = fwrite(fid, numberOfChannels, 'uint16'); totalCount = totalCount + 2 * count;
count = fwrite(fid, samplingFrequency, 'uint32'); totalCount = totalCount + 4 * count;

count = writeChunkList(fid, stfObject, tandemObjectFlag); totalCount = totalCount + count;

if ~isempty(f0)
    count = writeSTFDataChunk(fid, 'F0  ', f0ShiftMs, 0, bitsPerSample, weight, f0);
    totalCount = totalCount + count;
end

if ~isempty(uvf0)
    count = writeSTFDataChunk(fid, 'UVF0', f0ShiftMs, 0, bitsPerSample, weight, uvf0);
    totalCount = totalCount + count;
end

if ~isempty(f0CandidatesParams)
    count = writeSTFDataChunk(fid, 'F0CN', f0ShiftMs, numberOfCandidates, bitsPerSample, weight, f0CandidatesParams);
    totalCount = totalCount + count;
end

if ~isempty(periodicityLevel)
    count = writeSTFDataChunk(fid, 'PRLV', f0ShiftMs, 0, bitsPerSample, weight, periodicityLevel);
    totalCount = totalCount + count;
end

if ~isempty(sigmoidParameter)
    count = writeSTFDataChunk(fid, 'APSG', apShiftMs, 0, bitsPerSample, weight, sigmoidParameter);
    totalCount = totalCount + count;
elseif ~isempty(aperiodicity)
    count = writeSTFDataChunk(fid, 'AP  ', apShiftMs, 0, bitsPerSample, weight, aperiodicity);
    totalCount = totalCount + count;
end

if ~isempty(spectrogram)
    count = writeSTFDataChunk(fid, 'SPEC', shiftMs, 0, bitsPerSample, weight, spectrogram);
    totalCount = totalCount + count;
end

fclose(fid);

function totalCount = writeSTFDataChunk(fid, chunkId, shift, fftl, bitsPerSample, weight, data)

temporalPositions = [];
if size(data, 2) == length(shift) ...
        || (~isscalar(shift) && length(data) == length(shift))
    temporalPositions = shift;
    deltaTemporalPositions = diff(temporalPositions);
    
    if abs(min(deltaTemporalPositions) - max(deltaTemporalPositions)) < 1e-10
        % constant shift
        shift = deltaTemporalPositions(1) * 1000;
        temporalPositions = [];
    else
        % keyboard
        shift = 0;
    end
end

totalCount = 0;

if min(size(data)) == 1
    nframe = length(data);
    if fftl <= 0
        fftl = 1;
    end
else
    nframe = size(data, 2);
    
    if fftl <= 0
        if size(data, 1) > 2
            % fftl = (size(data, 1) - 1) * 2;
            fftl = floor(size(data, 1) / 2) * 2;
        else
            fftl = size(data, 1);
        end
    end
end

sampleSize = max(floor(bitsPerSample / 8), 1);
dataSize = sampleSize * size(data, 1) * size(data, 2);
chunkSize = dataSize + 30;

count = fwrite(fid, chunkId, 'schar'); totalCount = totalCount + count;
count = fwrite(fid, chunkSize, 'uint32'); totalCount = totalCount + 4 * count;
%count = fwrite(fid, shiftl, 'uint32'); totalCount = totalCount + 4 * count;
count = fwrite(fid, shift, 'float64'); totalCount = totalCount + 8 * count;
count = fwrite(fid, nframe, 'uint32'); totalCount = totalCount + 4 * count;
count = fwrite(fid, fftl, 'uint32'); totalCount = totalCount + 4 * count;
count = fwrite(fid, bitsPerSample, 'uint16'); totalCount = totalCount + 2 * count;
count = fwrite(fid, weight, 'float64'); totalCount = totalCount + 8 * count;
count = fwrite(fid, dataSize, 'uint32'); totalCount = totalCount + 4 * count;

data = data .* weight;

if bitsPerSample >= 64
    count = fwrite(fid, data, 'float64'); totalCount = totalCount + 8 * count;
elseif bitsPerSample >= 33
    count = fwrite(fid, data, 'float32'); totalCount = totalCount + 4 * count;
elseif bitsPerSample >= 32
    count = fwrite(fid, data, 'int32'); totalCount = totalCount + 4 * count;
elseif bitsPerSample >= 16
    count = fwrite(fid, data, 'int16'); totalCount = totalCount + 2 * count;
else
    count = fwrite(fid, data, 'int8'); totalCount = totalCount + count;
end

if ~isempty(temporalPositions)
    count = fwrite(fid, temporalPositions, 'float64'); totalCount = totalCount + 8 * count;
end

function totalCount = writeChunkList(fid, stfObject, tandemObjectFlag)

if nargin < 3
    tandemObjectFlag = false;
end

totalCount = 0;

chunkList = char([]);

if tandemObjectFlag
    if isfield(stfObject, 'refinedF0Structure')
        chunkList = [chunkList 'F0  '];
        if isfield(stfObject.refinedF0Structure, 'vuv')
            chunkList = [chunkList 'UVF0'];
        end
        chunkList = [chunkList 'PRLV'];
    end
    if isfield(stfObject, 'AperiodicityStructure')
        if isfield(stfObject.AperiodicityStructure, 'sigmoidParameter')
            chunkList = [chunkList 'APSG'];
        else
            chunkList = [chunkList 'AP  '];
        end
    end
    if isfield(stfObject, 'SpectrumStructure')
        chunkList = [chunkList 'SPEC'];
    end    
else
    if isfield(stfObject, 'nextFile')
        chunkList = [chunkList 'NXFL'];
    end
    if isfield(stfObject, 'f0')
        chunkList = [chunkList 'F0  '];
    end
    if isfield(stfObject, 'uvf0')
        chunkList = [chunkList 'UVF0'];
    end
    if isfield(stfObject, 'periodicityLevel')
        chunkList = [chunkList 'PRLV'];
    end
    if isfield(stfObject, 'sigmoidParameter')
        chunkList = [chunkList 'APSG'];
    elseif isfield(stfObject, 'aperiodicity')
        chunkList = [chunkList 'AP  '];
    end
    if isfield(stfObject, 'spectrogram')
        chunkList = [chunkList 'SPEC'];
    end
end

count = fwrite(fid, 'CHKL', 'schar'); totalCount = totalCount + count;
count = fwrite(fid, length(chunkList), 'uint32'); totalCount = totalCount + 4 * count;
count = fwrite(fid, chunkList, 'schar'); totalCount = totalCount + count;

if ~tandemObjectFlag && isfield(stfObject, 'nextFile')
    count = fwrite(fid, length(stfObject.nextFile), 'uint32'); totalCount = totalCount + 4 * count;
    count = fwrite(fid, stfObject.nextFile, 'schar'); totalCount = totalCount + count;
end

function randomComponent = calculateRandomComponent(apStructure, fftl)
% original: displayAperiodicityStructure.m

fs = apStructure.samplingFrequency;
f0 = apStructure.f0;
f0Safe = max(apStructure.targetF0,f0);
frequencyAxis = (0:fftl-1)'/fftl*fs;
displayFrequencyAxis = frequencyAxis(frequencyAxis<=fs/2);
nFrames = length(apStructure.f0);
stretchingFactor = f0Safe/apStructure.targetF0;
staticBoundaryList = [0;apStructure.cutOffListOriginal;fs/2];
fixedBoundaryList = [0;apStructure.cutOffListFix;fs/2];

randomComponent = ones(length(displayFrequencyAxis),nFrames);
for ii = 1:nFrames
    if f0(ii) > 0
        randomLevels = apStructure.residualMatrixOriginal(:,ii);
        originalPart = ...
            exp(interp1(staticBoundaryList,log([0.0000000005;randomLevels(:)]),displayFrequencyAxis,'linear','extrap'));
        randomLevels = apStructure.residualMatrixFix(:,ii);
        fixedPart = ...
            exp(interp1(fixedBoundaryList*stretchingFactor(ii),...
            log([0.00000000005;randomLevels(:)]),displayFrequencyAxis,'linear','extrap'));
        randomComponent(:,ii) = min([fixedPart, originalPart]')';
    end;
end;
