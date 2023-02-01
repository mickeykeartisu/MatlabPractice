% 音声の帯域ごとの動的特徴を求める(高速化Ver)
clear all

s_num = 1;
e_num = 5;

%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = [6];
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = 1; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = 500;
threshold_dB =[9];
ratio = Inf;
kneeWidth_dB = 6;
T_2 = 16;

% outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB'];
for g = 1:length(setGain)
    inputDirName_wav = '../voice_data/sample/wav/ATR_16kHz/';
    inputDirName_mat = '../voice_data/sample/mat/ATR_16kHz/';
    inputDirName_label = '../voice_data/sample/label/ATR_label/';

%     inputDirName_AE = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/'];
    inputDirName_AE = ['C:\Users\share\Documents\MATLAB\voice_data\ATR_gainlimit\kneeWidth_dB_06dB\500Hz\6dB\Gainlimit_09dB/'];
    inputDirName_AS = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_50dB_ATR/'];
    outputDirName = '../voice_data/Ddelta_phoneme/';

    %ファイル名を定義

    AN_name = cell(e_num,1); %通常音声
    AC_name = cell(e_num,1); %明瞭音声（意図的に明瞭になるように発声した音声）
    AE_name = cell(e_num,1); %強調音声
    AS_name = cell(e_num,1); %柴田手法音声

    for n = s_num:e_num
        AN_name{n} = ['AN' num2str(n, '%02d')];
        AC_name{n} = ['AC' num2str(n, '%02d')];
    %     AE_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_straight'];
        AE_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain(g)) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB_sgram'];
        AS_name{n} = ['AN' num2str(n, '%02d') '_PeakHz16_lin_' num2str(setGain(g)) '_empSgram'];
    end

    p.msdceptime = 50;
    
    % keyboard

    % label = cell(1,e_num);
    %%通常音声
    AN_allDcep = cell(T,e_num);
    AE_allDcep = cell(T,e_num);
    AS_allDcep = cell(T,e_num);
    AC_allDcep = cell(T,e_num);
    for n = s_num:e_num,
        AN = load ([inputDirName_mat AN_name{n}]); %%Matデータ読み込み
        AE = load ([inputDirName_AE 'mat/' AE_name{n}]); %%Matデータ読み込み
        AS = load ([inputDirName_AS 'mat/' AS_name{n}]); %%Matデータ読み込み
        AC = load ([inputDirName_mat AC_name{n}]); %%Matデータ読み込み
        lifter = round(3 * AN.fs /1000);
%         lifter = 3;
        band_length = round(size(AN.n3sgram,1)/T);
        AN.label = sploadlabel([inputDirName_label AN_name{n} '_lab.txt'],'point',1/1000);
        AC.label = sploadlabel([inputDirName_label AC_name{n} '_lab.txt'],'point',1/1000);
%         keyboard
        pt = 1;
        for i = 1:T,
            AN.band_n3sgram = AN.n3sgram(pt:pt+band_length-1,:);
            AE.band_n3sgram = AE.n3sgram_emp(pt:pt+band_length-1,:);
            AS.band_n3sgram = AS.n3sgram(pt:pt+band_length-1,:);
            AC.band_n3sgram = AC.n3sgram(pt:pt+band_length-1,:);
            if i ==T,
                AN.band_n3sgram = AN.n3sgram(pt:end,:);
                AE.band_n3sgram = AE.n3sgram_emp(pt:end,:);
                AS.band_n3sgram = AS.n3sgram(pt:end,:);
                AC.band_n3sgram = AC.n3sgram(pt:end,:);
            end
            xq = 1:(size(AN.band_n3sgram,1)/size(AN.n3sgram,1)):size(AN.band_n3sgram,1);
            AN.band_n3sgram = interp1(1:size(AN.band_n3sgram,1),AN.band_n3sgram,xq);
            AE.band_n3sgram = interp1(1:size(AE.band_n3sgram,1),AE.band_n3sgram,xq);
            AS.band_n3sgram = interp1(1:size(AS.band_n3sgram,1),AS.band_n3sgram,xq);
            AC.band_n3sgram = interp1(1:size(AC.band_n3sgram,1),AC.band_n3sgram,xq);
            
%             keyboard
            %通常音声
            AN.cep = getSt2Cep(AN.band_n3sgram, lifter);
            AN.dcep = getDeltaCep4(AN.cep, p);
%             plot(AN.dcep);
%             keyboard
%             AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
            
%             keyboard
            AN.norm_dcep = getDcepNorm(AN.dcep, 0);
%             keyboard
            %強調音声
            AE.cep = getSt2Cep(AE.band_n3sgram, lifter);
            AE.dcep = getDeltaCep4(AE.cep, p);
            AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
            AE.norm_dcep = getDcepNorm(AE.dcep, 0);
            %柴田強調音声
            AS.cep = getSt2Cep(AS.band_n3sgram, lifter);
            AS.dcep = getDeltaCep4(AS.cep, p);
            AS.dcep = trunc2(AS.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
            AS.norm_dcep = getDcepNorm(AS.dcep, 0);
            %明瞭音声
            AC.cep = getSt2Cep(AC.band_n3sgram, lifter);
            AC.dcep = getDeltaCep4(AC.cep, p);
%             AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
            AC.norm_dcep = getDcepNorm(AC.dcep, 0);
            
            
            for ii = 1:(length(AN.label)-1),
                section = [round(AN.label(ii).time) round(AN.label(ii+1).time)];
%                 section = [round(label(ii).time) round( label(ii).time + ((label(ii+1).time - label(ii).time)*0.5) )];
        %         keyboard

                %通常音声:AN
                AN.Dcep_Ave= sum(AN.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
%                 AN.Dcep_Ave= AN.norm_dcep(section(1));
                S.phoneme = AN.label(ii).phoneme;
                S.dcep = AN.Dcep_Ave;
                AN_allDcep{i,n}(ii) = S;
                %強調音声:AE
                AE.Dcep_Ave= sum(AE.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
%                 AE.Dcep_Ave= AE.norm_dcep(section(1));
                S.phoneme = AN.label(ii).phoneme;
                S.dcep = AE.Dcep_Ave;
                AE_allDcep{i,n}(ii) = S;
                %柴田音声:AS
                AS.Dcep_Ave= sum(AS.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
%                 AS.Dcep_Ave= AS.norm_dcep(section(1));
                S.phoneme = AN.label(ii).phoneme;
                S.dcep = AS.Dcep_Ave;
                AS_allDcep{i,n}(ii) = S;       
            end
            %明瞭音声用
            for ii = 1:(length(AC.label)-1)
                section = [round(AC.label(ii).time) round(AC.label(ii+1).time)];
%                 section = [round(label(ii).time) round( label(ii).time + ((label(ii+1).time - label(ii).time)*0.5) )];
                AC.Dcep_Ave= sum(AC.norm_dcep(section(1):section(2)))/((section(2) - section(1)));
%                 AC.Dcep_Ave= AC.norm_dcep(section(1));
                S.phoneme = AC.label(ii).phoneme;
                S.dcep = AC.Dcep_Ave;
                AC_allDcep{i,n}(ii) = S;
            end
            
            pt = pt+band_length;
        end
    end

%     % keyboard


    save([outputDirName 'AN_DynamicFeature_BandDivision_' num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'],...
    'AN_allDcep');

    save([outputDirName 'AC_DynamicFeature_BandDivision_' num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'],...
    'AC_allDcep');

    save([outputDirName 'AE_DynamicFeature_BandDivision_' num2str(setGain(g)) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB_' num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'],...
    'AE_allDcep');

    save([outputDirName 'AS_DynamicFeature_BandDivision_'  num2str(setGain(g)) 'dB_'  num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'],...
    'AS_allDcep');
        
end
