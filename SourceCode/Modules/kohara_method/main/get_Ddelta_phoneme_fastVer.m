% 音声ごとのDΔを求める(高速化Ver)
clear all

s_num = 1;
e_num = 50;

%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = 3;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = 16; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = 500;


inputDirName_wav = '../voice_data/sample/wav/ATR_16kHz/';
inputDirName_mat = '../voice_data/sample/mat/ATR_16kHz/';
inputDirName_label = '../voice_data/sample/label/ATR_label/';

inputDirName_AE = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/'];
inputDirName_AE0 = ['../voice_data/new_BandDivision_tec/ATR_16kHz/0Hz/'];
inputDirName_AS = ['../voice_data/sample/mat/shibata_original/'];
outputDirName = '../voice_data/Ddelta_phoneme/';

%ファイル名を定義

AN_name = cell(e_num,1); %通常音声
AC_name = cell(e_num,1); %明瞭音声（意図的に明瞭になるように発声した音声）
AE_name = cell(e_num,1); %強調音声
AE0_name = cell(e_num,1); %強調音声(ハニングなし固定)
AS_name = cell(e_num,1); %柴田手法音声

for n = s_num:e_num
    AN_name{n} = ['AN' num2str(n, '%02d')];
    AC_name{n} = ['AC' num2str(n, '%02d')];
    AE_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_empsgram'];
    AE0_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning0Hz_empsgram'];
    AS_name{n} = ['AN' num2str(n, '%02d') '_PeakHz16_lin_' num2str(setGain)];
end


% keyboard

% label = cell(1,e_num);
%%通常音声,強調音声,柴田音声
AN_allDcep = cell(1,e_num);
AE_allDcep = cell(1,e_num);
AE0_allDcep = cell(1,e_num);
AS_allDcep = cell(1,e_num);
for n = s_num:e_num,
    AN = load ([inputDirName_mat AN_name{n}]); %%Matデータ読み込み
    AE = load ([inputDirName_AE 'mat/' AE_name{n}]); %%Matデータ読み込み
    AE0 = load ([inputDirName_AE0 'mat/' AE0_name{n}]); %%Matデータ読み込み
    AS = load ([inputDirName_AS AS_name{n}]);
    label = sploadlabel([inputDirName_label AN_name{n} '_lab.txt'],'point',1/1000);
    
    p.msdceptime = 50;
    AN.cep = getSt2Cep(AN.n3sgram, 45);
    AN.dcep = getDeltaCep4(AN.cep, p);
    AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AN.norm_dcep = getDcepNorm(AN.dcep, 0);
    
    AE.cep = getSt2Cep(AE.emp_sgram, 45);
    AE.dcep = getDeltaCep4(AE.cep, p);
    AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AE.norm_dcep = getDcepNorm(AE.dcep, 0);
    
    AE0.cep = getSt2Cep(AE0.emp_sgram, 45);
    AE0.dcep = getDeltaCep4(AE0.cep, p);
    AE0.dcep = trunc2(AE0.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AE0.norm_dcep = getDcepNorm(AE0.dcep, 0);
    
    AS.cep = getSt2Cep(AS.n3sgram, 45);
    AS.dcep = getDeltaCep4(AS.cep, p);
    AS.dcep = trunc2(AS.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AS.norm_dcep = getDcepNorm(AS.dcep, 0);
    for ii = 1:(length(label)-1),
    
        section = [round(label(ii).time) round(label(ii+1).time)];
%         keyboard
        AN.Dcep_Ave= sum(AN.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
        S.phoneme = label(ii).phoneme;
        S.dcep = AN.Dcep_Ave;
        AN_allDcep{n}(ii) = S;
        
        AE.Dcep_Ave= sum(AE.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
        S.phoneme = label(ii).phoneme;
        S.dcep = AE.Dcep_Ave;
        AE_allDcep{n}(ii) = S;
        
        AE0.Dcep_Ave= sum(AE0.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
        S.phoneme = label(ii).phoneme;
        S.dcep = AE0.Dcep_Ave;
        AE0_allDcep{n}(ii) = S;
        
        AS.Dcep_Ave= sum(AS.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
        S.phoneme = label(ii).phoneme;
        S.dcep = AS.Dcep_Ave;
        AS_allDcep{n}(ii) = S;
    end
end

%%明瞭音声
AC_allDcep = cell(1,e_num);
for n = s_num:e_num,
    AC = load ([inputDirName_mat AC_name{n}]); %%Matデータ読み込み
    % AE = load('sample Normal6_enhanced_straight.mat');
    label = sploadlabel([inputDirName_label AC_name{n} '_lab.txt'],'point',1/1000);
    
    p.msdceptime = 50;
    AC.cep = getSt2Cep(AC.n3sgram, 45);
    AC.dcep = getDeltaCep4(AC.cep, p);
    AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AC.norm_dcep = getDcepNorm(AC.dcep, 0);
    for ii = 1:(length(label)-1)
        section = [round(label(ii).time) round(label(ii+1).time)];

        AC.Dcep_Ave= sum(AC.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
        S.phoneme = label(ii).phoneme;
        S.dcep = AC.Dcep_Ave;
        AC_allDcep{n}(ii) = S;
    end
end

save([outputDirName 'phoneme by EachVoice_' num2str(setGain) 'dB_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'],...
    'AN_allDcep','AC_allDcep','AE_allDcep','AE0_allDcep','AS_allDcep');
