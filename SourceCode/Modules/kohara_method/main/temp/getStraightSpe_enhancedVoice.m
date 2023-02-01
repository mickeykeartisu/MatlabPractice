


clear all;
inputDirName = '../voice_data/sample/';

inputDirName1 = '../voice_data/sample/';
inputDirName2 = ['../voice_data/new_BandDivision_tec/16Hz/'];
inputDirName3 = ['../voice_data/new_BandDivision_tec/ATR_16kHz/'];

% inputName = 'sample Normal';
% inputName = 'sample Normal6';

%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = 6;
%フィルタ長(ミリ秒)を指定
f_t = 6;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [16]; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = [3000];

s_num = 1;
e_num = 3;


% [x,fs] = audioread([inputDirName 'wav/' inputName '.wav']);
% if strcmp(inputName,'sample Normal'),
%     x_lim = [195 4400];
%     x_lim_s = [0 4200];
%     fontsize = 12;
%     freqinterbal = 1000;
%     timeinterbal = 500;
%     fre_range = 4000;
%     rangedb = 70;
%     maxdb = 0;
% end

for n = s_num:1:e_num,
    waitbar(n/e_num)
    for v = 1:length(maxfreq),
        inputName = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq(v)) 'Hz'];
        [x,fs] = audioread([inputDirName3 num2str(maxfreq(v)) 'Hz/' inputName '.wav']);
        [f0raw, ap] = exstraightsource(x, fs);

        [n3sgram] = exstraightspec(x, f0raw, fs);

        outputDirName = inputDirName3;

        save ([outputDirName num2str(maxfreq(v)) 'Hz/mat/' inputName '_straight'], 'x', 'fs', 'f0raw', 'ap','n3sgram');

    end

end
% [x,fs] = audioread([inputDirName3 inputName '_16Hz_' num2str(gain) 'dB_16band_taper_hanning3000Hz.wav']);
% 
% [f0raw, ap] = exstraightsource(x, fs);
% 
% [n3sgram] = exstraightspec(x, f0raw, fs);
% 
% % dispsgram_color(n3sgram,fs,1, 'original' , fontsize, freqinterbal, timeinterbal, fre_range, rangedb, maxdb);
% 
% outputDirName = ['../voice_data/sample/mat/enhanced_speech/'];
% 
% save ([outputDirName inputName '_16Hz_' num2str(gain) 'dB_16band_taper_hanning3000Hz_straight'], 'x', 'fs', 'f0raw', 'ap','n3sgram');
% save ([inputName '_enhanced_straight'], 'x', 'fs', 'f0raw', 'ap','n3sgram');

% synthParams.pconv = 1.0; synthParams.fconv = 1.0; synthParams.sconv = 1.0;
% syn = exstraightsynth(f0raw, n3sgram, ap,fs,synthParams);
% 


% calib_file = 'calib_95dB'; %1000Hzのsin波の参照信号の収録信号？
% refdb = 98; %参照信号の騒音計dB値　ref・・・reference
% setDB = 60; %目標の音圧レベル？
% [y_ref, fs_ref] = audioread([calib_file '.wav']);
% bit_ref = 24;
% [compensate_db, y_max, y_max_fact] = defCalibrationParams(y_ref, fs_ref, refdb);
% % audiowrite([calib_file '_maxfact_' num2str(y_max_fact)], y_max, fs_ref, 'BitsPerSample', bit_ref)
% 
% cut_wave = 50;
% 
% X_width = [50 length(syn)-50];
% [syn_norm] = getSig4SplNormalization(syn/(2^24/2), fs, compensate_db, setDB, X_width);
% 
% % audiowrite([inputName '_enhanced_straight.wav'],syn_norm,fs,'BitsPerSample',24)
% 
% % s_num= 1;
% % e_num= 3;
% % for i = s_num:e_num,
% %     inputName = [filename '_' num2str(i, '%04d')];
% %     [x, fs, nbits] = wavread([inputDirName inputName '.wav']);
% % 
% %     [f0raw, ap] = exstraightsource(x, fs);
% % 
% %     [n3sgram] = exstraightspec(x, f0raw, fs);
% %     %keyboard
% %     save ([outputDirName inputName], 'x', 'fs', 'f0raw', 'ap','n3sgram');
% %     %clearvars x fs f0raw apn3sgram
% %     %keyboard
% % end