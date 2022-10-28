function varargout = readSTFFile(filename, tandemFlag)
%READSTFFILE  Read STRAIGHT format file.
%	[STFOBJECT, MACHINEFORMAT] = READSTFFILE(FILENAME);
%	[TANDEMOBJ, MACHINEFORMAT] = READSTFFILE(FILENAME, true);
%	[TANDEMOBJ, MACHINEFORMAT] = READSTFFILE(FILENAME, WAVDATA);
%	[TANDEMOBJ, MACHINEFORMAT] = READSTFFILE(FILENAME, WAVFILENAME);
%    
%	FILENAME:	file name
%	WAVDATA:	waveform data
%	WAVFILENAME:	WAV file name including waveform data
%	STFOBJECT:	output STRAIGHT-format object
%	TANDEMOBJ:	output TANDEM-STRAIGHT object
%	MACHINEFORMAT:	machine format of the file; 'n': native, 'l': little endian, 'b': big endian

fid = fopen(filename, 'r', 'l');
if fid == -1
    return;
end

inputSignal = [];
dataPath = '.';
dataFileName = [];

if nargin < 2
    tandemFlag = false;
elseif ischar(tandemFlag)
    inputWavName = tandemFlag;
    [dataPath, wavName, wavExt] = fileparts(inputWavName);
    dataFileName = [wavName wavExt];
    if isempty(dataPath)
        [dataPath, name, ext] = fileparts(filename);
        inputWavName = fullfile(dataPath, inputWavName);
    end
    inputSignal = wavread(inputWavName);
    tandemFlag = true;
elseif ~isscalar(tandemFlag)
    inputSignal = tandemFlag;
    tandemFlag = true;
    [dataPath, name, ext] = fileparts(filename);
    dataFileName = [name '.wav'];
end

if tandemFlag
    stfObject.creationDate = datestr(now,30);
    stfObject.dataDirectory = dataPath;
    stfObject.dataFileName = dataFileName;
    stfObject.standAlone = true;
    stfObject.refinedF0Structure = struct([]);
    stfObject.AperiodicityStructure = struct([]);
    stfObject.AperiodicityStructure(1).procedure = 'aperiodicityRatio';
    stfObject.SpectrumStructure = struct([]);
    uvf0 = [];
else
    stfObject = struct([]);
end

machineFormat = 'n';

fileIdRaw = fread(fid, 4, 'schar');
fileId = char(fileIdRaw');
if strcmp(fileId, 'STRT') == 0
    disp([filename ' is not a STRAIGHT file.']);
    fclose(fid);
    return;
end

endianId = fread(fid, 1, 'uint16');
if endianId == 65279
    machineFormat = 'l';
elseif endianId == 65534
    machineFormat = 'b';
else
    disp(['Unsupported endian type: ' num2str(endianId)]);
    fclose(fid);
    return;
end
fclose(fid);

fid = fopen(filename, 'r', machineFormat);
fseek(fid, 6, 0);

headerSize = fread(fid, 1, 'uint32');
formatId = fread(fid, 1, 'uint16');
if ~tandemFlag
    stfObject(1).numberOfChannels = fread(fid, 1, 'uint16');
    stfObject(1).samplingFrequency = fread(fid, 1, 'uint32');
else
    numberOfChannels = fread(fid, 1, 'uint16'); % ignore
    stfObject.refinedF0Structure(1).samplingFrequency = fread(fid, 1, 'uint32');
    stfObject.AperiodicityStructure(1).samplingFrequency = stfObject.refinedF0Structure(1).samplingFrequency;
    stfObject.SpectrumStructure(1).samplingFrequency = stfObject.refinedF0Structure(1).samplingFrequency;
    stfObject.samplingFrequency = stfObject.refinedF0Structure(1).samplingFrequency;

    if ~isempty(inputSignal)
        stfObject.waveform = inputSignal(:, 1);
    end
end

if headerSize > 8
    fseek(fid, headerSize - 8, 0);
end

while 1
    [chunkId, shift, fftl, data, temporalPositions, bitsPerSample, weight] = readSTFDataChunk(fid);
    if length(chunkId) < 4
	break;
    end

    if strcmp(chunkId, 'NXFL')
        if ~tandemFlag
            stfObject(1).nextFile = data;
        end
    elseif strcmp(chunkId, 'F0  ')
        if ~tandemFlag
            if ~isempty(temporalPositions)
                stfObject(1).f0TemporalPositions = temporalPositions;
            else
                stfObject(1).f0ShiftMs = shift;
            end
            stfObject(1).f0 = data;
        else
            stfObject.refinedF0Structure(1).f0 = data';
            stfObject.AperiodicityStructure(1).f0 = stfObject.refinedF0Structure(1).f0;
            if ~isempty(temporalPositions)
                stfObject.refinedF0Structure(1).temporalPositions = temporalPositions;
            else
                stfObject.refinedF0Structure(1).temporalPositions = makeTemporalPositions(shift, length(data));
            end
            if ~isfield(stfObject.AperiodicityStructure(1), 'temporalPositions')
                stfObject.AperiodicityStructure(1).temporalPositions = stfObject.refinedF0Structure(1).temporalPositions;
            end
        end
    elseif strcmp(chunkId, 'UVF0')
        if ~tandemFlag
            stfObject(1).uvf0 = data;
        else
            uvf0 = data';
        end
    elseif strcmp(chunkId, 'F0CN')
        if tandemFlag
            numberOfF0CandidatesParams = round(size(data, 1) / fftl);
            numberOfCandidates = fftl;
 
            stfObject.refinedF0Structure(1).f0CandidatesMap = data(1:numberOfCandidates, :);
            stfObject.refinedF0Structure(1).f0CandidatesScoreMap = data(numberOfCandidates+1:numberOfCandidates*2, :);
            if numberOfF0CandidatesParams >= 3
                % f0'c'andidatesPowerMap is specification of the MATLAB version.
                stfObject.refinedF0Structure(1).f0candidatesPowerMap = data(numberOfCandidates*2+1:numberOfCandidates*3, :);
            end
        end
    elseif strcmp(chunkId, 'PRLV')
        if ~tandemFlag
            stfObject(1).periodicityLevel = data;
        else
            stfObject.refinedF0Structure(1).periodicityLevel = data';
            stfObject.AperiodicityStructure(1).periodicityLevel = stfObject.refinedF0Structure(1).periodicityLevel;
        end
    elseif strcmp(chunkId, 'AP  ')
        if ~tandemFlag
            if ~isempty(temporalPositions)
                stfObject(1).aperiodicityTemporalPositions = temporalPositions;
            else
                stfObject(1).aperiodicityShiftMs = shift;
            end
            stfObject(1).aperiodicity = data;
        else
            randomComponent = 10.^(data / 20);
            if ~isempty(temporalPositions)
                stfObject.AperiodicityStructure(1).temporalPositions = temporalPositions;
            else
                stfObject.AperiodicityStructure(1).temporalPositions = makeTemporalPositions(shift, size(data, 2));
            end
        end
    elseif strcmp(chunkId, 'APSG')
        if tandemFlag
            stfObject.AperiodicityStructure(1).sigmoidParameter = data;
            if ~isempty(temporalPositions)
                stfObject.AperiodicityStructure(1).temporalPositions = temporalPositions;
            else
                stfObject.AperiodicityStructure(1).temporalPositions = makeTemporalPositions(shift, size(data, 2));
            end
        end
    elseif strcmp(chunkId, 'SPEC')
        if ~tandemFlag
            if ~isempty(temporalPositions)
                stfObject(1).temporalPositions = temporalPositions;
            else
                stfObject(1).shiftMs = shift;
            end
            stfObject(1).spectrogram = data;
        else
            if ~isempty(temporalPositions)
                stfObject.SpectrumStructure(1).temporalPositions = temporalPositions;
            else
                stfObject.SpectrumStructure(1).temporalPositions = makeTemporalPositions(shift, size(data, 2));
            end
            stfObject.SpectrumStructure(1).spectrogramSTRAIGHT = data .^ 2;
        end
    end
end

fclose(fid);

if ~tandemFlag
    for k = 1:nargout
        if k == 1
            varargout{k} = stfObject;
        elseif k == 2
            varargout{k} = machineFormat;
        end
    end
else
    for k = 1:nargout
        if k == 1
            stfObject.refinedF0Structure(1).vuv = double(stfObject.refinedF0Structure(1).f0 > 0);
            if ~isempty(uvf0)
                idx = find(stfObject.refinedF0Structure(1).f0 <= 0);
                stfObject.refinedF0Structure(1).f0(idx) = uvf0(idx);
            end
            
            stfObject.AperiodicityStructure(1).f0 = stfObject.refinedF0Structure(1).f0;
            stfObject.AperiodicityStructure(1).vuv = stfObject.refinedF0Structure(1).vuv;
            stfObject.AperiodicityStructure(1).targetF0 = calcTandemAperiodicityTargetF0(stfObject.AperiodicityStructure(1));

            if isfield(stfObject.AperiodicityStructure, 'sigmoidParameter')
                stfObject.AperiodicityStructure(1).procedure = 'aperiodicityRatioSigmoid3';
                stfObject.AperiodicityStructure(1).exponent = 2;
                stfObject.AperiodicityStructure(1).aperiodicityRange ...
                    = repmat([0; 1], 1, length(stfObject.AperiodicityStructure(1).f0));
                
                cutOffList = makeCutOffList(600, stfObject.AperiodicityStructure(1).samplingFrequency);
                stfObject.AperiodicityStructure(1).cutOffListOriginal = cutOffList;
                stfObject.AperiodicityStructure(1).cutOffListFix = cutOffList;
            else
                [stfObject.AperiodicityStructure(1).residualMatrixOriginal, stfObject.AperiodicityStructure(1).residualMatrixFix, cutOffList] ...
                    = randomComponentToResidualMatrix(randomComponent, stfObject.AperiodicityStructure(1).f0, ...
                                                      stfObject.AperiodicityStructure(1).targetF0, ...
                                                      stfObject.AperiodicityStructure(1).samplingFrequency);
                stfObject.AperiodicityStructure(1).cutOffListOriginal = cutOffList;
                stfObject.AperiodicityStructure(1).cutOffListFix = cutOffList;
            end
                
            varargout{k} = stfObject;
        elseif k == 2
            varargout{k} = machineFormat;
        end
    end
end

function [chunkId, shift, fftl, data, temporalPositions, bitsPerSample, weight] = readSTFDataChunk(fid)
shift = 0;
fftl = 0;
data = [];
temporalPositions = [];
bitsPerSample = 0;
weight = 1.0;

[chunkIdRaw, count] = fread(fid, 4, 'schar');
chunkId = char(chunkIdRaw');
if count < 4
    return;
end

chunkSize = fread(fid, 1, 'uint32');

if strcmp(chunkId, 'NXFL') | strcmp(chunkId, 'CHKL')
    dataRaw = fread(fid, chunkSize, 'uchar');
    data = char(dataRaw');
elseif strcmp(chunkId, 'F0  ') | strcmp(chunkId, 'AP  ') | strcmp(chunkId, 'SPEC') ...
        | strcmp(chunkId, 'UVF0') | strcmp(chunkId, 'PRLV') | strcmp(chunkId, 'F0CN') | strcmp(chunkId, 'APSG')
    %shift = fread(fid, 1, 'uint32');
    shift = fread(fid, 1, 'float64');
    nframes = fread(fid, 1, 'uint32');
    fftl = fread(fid, 1, 'uint32');
    bitsPerSample = fread(fid, 1, 'uint16');
    weight = fread(fid, 1, 'float64');
    dataSize = fread(fid, 1, 'uint32');
    dataCount = dataSize / floor(bitsPerSample / 8);
    hfftl = round(dataCount / nframes);

    if bitsPerSample >= 64
	data = fread(fid, [hfftl, nframes], 'float64');
    elseif bitsPerSample >= 33
	data = fread(fid, [hfftl, nframes], 'float32');
    elseif bitsPerSample >= 32
	data = fread(fid, [hfftl, nframes], 'int32');
    elseif bitsPerSample >= 16
	data = fread(fid, [hfftl, nframes], 'int16');
    else
	data = fread(fid, [hfftl, nframes], 'int8');
    end

    data = data ./ weight;

    temporalPositions = [];
    if shift == 0
	temporalPositions = fread(fid, nframes, 'float64');
    end
else
    % skip unsupported chunk
    fseek(fid, chunkSize, 0);
end

function [temporalPositions] = makeTemporalPositions(shiftMs, len)

temporalPositions = (0:len-1) * (shiftMs / 1000);

function [targetF0] = calcTandemAperiodicityTargetF0(sourceStructure)

f0 = sourceStructure.f0;
if isfield(sourceStructure,'vuv') && sum(sourceStructure.vuv) > 0
    targetF0 = min(200, max(32, min(f0(sourceStructure.vuv>0)))); 
else
    targetF0 = min(200, max(32, min(f0(f0>=0))));
end

function [cutOffList] = makeCutOffList(nominalCutOff, fs)

cutOffList = fs/4;
while cutOffList(end) > nominalCutOff
    cutOffList = [cutOffList; cutOffList(end)/2];
end;
cutOffList = cutOffList(end-1:-1:1);

function [residualMatrixOriginal, residualMatrixFix, cutOffList] ...
    = randomComponentToResidualMatrix(randomComponent, f0, targetF0, fs)

f0Safe = max(targetF0, f0);
stretchingFactor = f0Safe / targetF0;

nominalCutOff = 600;
cutOffList = makeCutOffList(nominalCutOff, fs);

nFrames = size(randomComponent, 2);
hfftl = size(randomComponent, 1);
fftl = (hfftl - 1) * 2;

displayFrequencyAxis = (0:hfftl-1)' / fftl * fs;
residualMatrixOriginal = ones(length(cutOffList) + 1, nFrames);
residualMatrixFix = residualMatrixOriginal;

for ii = 1:nFrames
    if f0(ii) > 0
        residualMatrixOriginal(:,ii) = interp1(displayFrequencyAxis, ...
                                               randomComponent(:,ii), [cutOffList; fs/2]);
        residualMatrixFix(:,ii) = interp1(displayFrequencyAxis, ...
                                          randomComponent(:,ii), [cutOffList; fs/2]./stretchingFactor(ii));
    end
end
