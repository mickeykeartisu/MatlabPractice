% 通常音声と強調音声の動的特徴とRMS値を比較するプログラム
clear all

inputDirName = '../voice_data/sample/wav/ATR_16kHz/';
inputDirName_mat = '../voice_data/sample/mat/ATR_16kHz/';

s_num = 1;
e_num = 1;

for n = s_num:1:e_num,
    AN_name = ['AN' num2str(n, '%02d')];
    AC_name = ['AC' num2str(n, '%02d')];

    AN = load([inputDirName_mat AN_name]); %%Matデータ読み込み
    AC = load([inputDirName_mat AC_name]); %%Matデータ読み込み
    % AE = load([inputDirName 'mat/enhanced_speech/' inputName '_16Hz_6dB_16band_taper_hanning3000Hz_straight']);


    % label = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1/1000);

    p.msdceptime = 50;
    
    AN.cep = getSt2Cep(AN.n3sgram, 45);
    AN.dcep = getDeltaCep4(AN.cep, p);
    AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AN.norm_dcep = getDcepNorm(AN.dcep, 0);
    
    AC.cep = getSt2Cep(AC.n3sgram, 45);
    AC.dcep = getDeltaCep4(AC.cep, p);
    AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
%     keyboard
    AC.norm_dcep = getDcepNorm(AC.dcep, 1);

    % AE.dcep = getDeltaCep4(AE.cep, p);
    % AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    % AE.norm_dcep = getDcepNorm(AE.dcep, 0);


    Frame = 16*20; %サンプリング周波数16kHzの時のフレーム長20ms%
    Shift = 16*1; %サンプリング周波数16kHzの時のフレームシフト1ms%

    AN.R = floor((length(AN.X)-Frame)/Shift); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める
    AC.R = floor((length(AC.X)-Frame)/Shift); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める

    point = 1;
    AN.rms = zeros(1,AN.R);
    AC.rms = zeros(1,AC.R);
    for ii = 1:1:max(AN.R,AC.R),
        if ii <= AN.R,
            x = AN.X(point:point+(Frame-1));
            rmsV = getRms3(x,Frame);
            AN.rms(ii) = 20*log10(rmsV);
        end

        if ii <= AC.R,
            x = AC.X(point:point+(Frame-1));
            rmsV = getRms3(x,Frame);
            AC.rms(ii) = 20*log10(rmsV);
        end
        point = point+Shift;
    end

%     keyboard
    
    if length(AN.rms)>length(AN.norm_dcep),
        AN.norm_dcep = LinearInt(AN.norm_dcep,AN.rms);
    elseif length(AN.rms)<length(AN.norm_dcep),
        AN.rms = LinearInt(AN.rms,AN.norm_dcep);
    end
    AN.norm_dcep = AN.norm_dcep(1:end-1);
    AN.rms = AN.rms(1:end-1);
    
    
    if length(AC.rms)>length(AC.norm_dcep),
        AC.norm_dcep = LinearInt(AC.norm_dcep,AN.rms);
    elseif length(AC.rms)<length(AC.norm_dcep),
        AC.rms = LinearInt(AC.rms,AC.norm_dcep);
    end
    AC.norm_dcep = AC.norm_dcep(1:end-1);
    AC.rms = AC.rms(1:end-1);

    AN.xplot = (0:length(AN.rms)-1) ./ (length(AN.rms)/length(AN.X))./(AN.fs/1000);
    AC.xplot = (0:length(AC.rms)-1) ./ (length(AC.rms)/length(AC.X))./(AC.fs/1000);
    
%     figure
%     plot(AN.xplot,AN.rms);
%     setLabel('Time [ms]', 'Amplitude [dB]', AN_name, 16);
%     figure
%     plot(AN.xplot,AN.norm_dcep);
%     setLabel('Time [ms]', 'Delta Cepstrum', AN_name, 16);
%     
%     figure
%     plot(AC.xplot,AC.rms);
%     setLabel('Time [ms]', 'Amplitude [dB]', AC_name, 16);
%     figure
%     plot(AC.xplot,AC.norm_dcep);
%     setLabel('Time [ms]', 'Delta Cepstrum', AC_name, 16);

    sz = 5;
    figure
    scatter(AN.rms,AN.norm_dcep,sz,'filled','b')
%     setLabel('RMS [dB]', 'Delta Cepstrum', '', 16);
    hold on 
%     figure
    scatter(AC.rms,AC.norm_dcep,sz,'filled','r')
    setLabel('RMS [dB]', 'Delta Cepstrum', '', 16);
    legend(AN_name, AC_name)
    hold off
    
end
