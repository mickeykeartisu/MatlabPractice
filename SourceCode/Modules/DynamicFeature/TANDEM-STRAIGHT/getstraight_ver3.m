function [f, rc, q, fs] = getstraight_ver3(x, fs, noisy)

% % �\�[�X���𒊏o����
r = exF0candidatesTSTRAIGHTGB_ver3(x,fs);    % Extract F0 information�A�uframePeriod�v��ύX�����uexF0candidatesTSTRAIGHTGB.m�v���g�p
if noisy
    x = removeLF(x,fs,r.f0,r.periodicityLevel); % Low frequency noise remover
    r = exF0candidatesTSTRAIGHTGB_ver3(x,fs);
end;

rc = autoF0Tracking(r,x); % Clean F0 trajectory by tracking
rc.vuv = refineVoicingDecision(x,rc);

q = aperiodicityRatioSigmoid(x,rc,1,2,0);    % aperiodicity extraction

% % �X�y�N�g�����𒊏o����
f = exSpectrumTSTRAIGHTGB_ver3(x,fs,q);    %�uframePeriod�v��ύX�����uexSpectrumTSTRAIGHTGB.m�v���g�p

STRAIGHTobject.waveform = x;
STRAIGHTobject.samplingFrequency = fs;
STRAIGHTobject.refinedF0Structure.temporalPositions = r.temporalPositions;
STRAIGHTobject.SpectrumStructure.spectrogramSTRAIGHT = f.spectrogramSTRAIGHT;
STRAIGHTobject.refinedF0Structure.vuv = rc.vuv;
f.spectrogramSTRAIGHT = unvoicedProcessing(STRAIGHTobject);
