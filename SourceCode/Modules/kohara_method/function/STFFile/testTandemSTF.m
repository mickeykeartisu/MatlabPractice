writeTestFlag = true;
readTestFlag = true;

if writeTestFlag
    [x, fs, nbits] = wavread('vaiueo2d.wav');

    clear optP;
    optP.framePeriod = 1;
    r = exF0candidatesTSTRAIGHTGB(x,fs,optP); % Extract F0 information

    rc = autoF0Tracking(r,x); % Clean F0 trajectory by tracking
    rc.vuv = refineVoicingDecision(x,rc);
    q = aperiodicityRatioSigmoid(x,rc,1,2,false); % aperiodicity extraction

    f = exSpectrumTSTRAIGHTGB(x,fs,q);

    STRAIGHTobject.waveform = x;
    STRAIGHTobject.samplingFrequency = fs;
    STRAIGHTobject.refinedF0Structure = rc;
    STRAIGHTobject.AperiodicityStructure = q;
    STRAIGHTobject.SpectrumStructure = f;

    writeSTFFile('vaiueo2d_tandem.stf', STRAIGHTobject);
    disp('writeSTFFile done');
end

if readTestFlag
    [STRAIGHTobjectRead, machineFormat] = readSTFFile('vaiueo2d_tandem.stf', x);
    disp('readSTFFile done');

    s = exTandemSTRAIGHTsynthNx(STRAIGHTobjectRead.AperiodicityStructure, STRAIGHTobjectRead.SpectrumStructure);
    sound(s.synthesisOut/max(abs(s.synthesisOut))*0.8,fs)

    s2 = exGeneralSTRAIGHTsynthesisR2(STRAIGHTobjectRead.AperiodicityStructure, STRAIGHTobjectRead.SpectrumStructure);
    sound(s2.synthesisOut/max(abs(s2.synthesisOut))*0.8,fs)
end
