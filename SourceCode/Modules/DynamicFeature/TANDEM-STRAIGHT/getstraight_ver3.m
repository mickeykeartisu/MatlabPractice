function [f, rc, q, fs] = getstraight_ver3(x, fs, noisy)

% % ソース情報を抽出する
r = exF0candidatesTSTRAIGHTGB_ver3(x,fs);    % Extract F0 information、「framePeriod」を変更した「exF0candidatesTSTRAIGHTGB.m」を使用
if noisy
    x = removeLF(x,fs,r.f0,r.periodicityLevel); % Low frequency noise remover
    r = exF0candidatesTSTRAIGHTGB_ver3(x,fs);
end;

rc = autoF0Tracking(r,x); % Clean F0 trajectory by tracking
rc.vuv = refineVoicingDecision(x,rc);

q = aperiodicityRatioSigmoid(x,rc,1,2,0);    % aperiodicity extraction

% % スペクトル情報を抽出する
f = exSpectrumTSTRAIGHTGB_ver3(x,fs,q);    %「framePeriod」を変更した「exSpectrumTSTRAIGHTGB.m」を使用

STRAIGHTobject.waveform = x;
STRAIGHTobject.samplingFrequency = fs;
STRAIGHTobject.refinedF0Structure.temporalPositions = r.temporalPositions;
STRAIGHTobject.SpectrumStructure.spectrogramSTRAIGHT = f.spectrogramSTRAIGHT;
STRAIGHTobject.refinedF0Structure.vuv = rc.vuv;
f.spectrogramSTRAIGHT = unvoicedProcessing(STRAIGHTobject);
