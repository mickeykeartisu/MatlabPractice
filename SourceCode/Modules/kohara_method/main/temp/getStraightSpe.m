%音声のstraightスペクトルを求める

clear all;
inputDirName = '../voice_data/sample/';

inputDirName1 = '../voice_data/sample/';
inputDirName2 = ['../voice_data/new_BandDivision_tec/16Hz/'];
inputDirName3 = ['../voice_data/new_BandDivision_tec/use_hanning/'];
inputDirName4 = ['../voice_data/center_listeningTest_sample/16kHz/'];

% inputName = 'sample Normal';
% filename = 'sample Normal2';
% filename = 'sample Normal3';
% filename = 'sample Normal4';
% inputName = 'sample Normal6';
% filename = 'a_i_kya_ku'
% filename = 'sample_Normal2';
% filename = 'ki ku ba n'
% filename = 'ta ka hi mo';
% filename = 'ka wa da chi'
% filename = 'he ra zu ke';
% filename = 'sample Normal_kita';
% filename = 'sample Normal_kawa';
% inputName = 'sample Clear';


% 
% fs_out = 16000; %出力時のサンプリング周波数
% 
% % [X,fs] = audioread([inputDirName 'wav/' inputName '.wav']);
% [X,fs] = audioread([inputDirName 'wav/sample_clear/' inputName '.wav']);
% 
% if fs ~= fs_out,
%     %入力音声と出力時のサンプリング周波数が異なる場合、サンプリング周波数を変換して出力する
%     X = sfconv(X,fs,fs_out);
%     fs = fs_out;
%     
%     audiowrite([inputDirName inputName '.wav'],X, fs, 'BitsPerSample',24)
% end
% 
% 
% [f0raw, ap] = exstraightsource(X, fs);
% 
% [n3sgram] = exstraightspec(X, f0raw, fs);
% 
% % dispsgram_color(n3sgram,fs,1, 'original' , fontsize, freqinterbal, timeinterbal, fre_range, rangedb, maxdb);
% 
% outputDirName = ['../voice_data/sample/mat/'];
% 
% save ([outputDirName inputName], 'X', 'fs', 'f0raw', 'ap','n3sgram');
% % save ([inputName '_enhanced_straight'], 'x', 'fs', 'f0raw', 'ap','n3sgram');

s_num= 7;
e_num= 7;
for i = s_num:e_num,
%     inputName = ['No1_S01_16kHz-' num2str(i, '%02d')];
    inputName = ['No1_S01_16kHz-' num2str(i, '%02d')];
    [x, fs, nbits] = wavread([inputDirName4 inputName '.wav']);

    [f0raw, ap] = exstraightsource(x, fs);

    [n3sgram] = exstraightspec(x, f0raw, fs);
    %keyboard
    save ([inputDirName4 inputName], 'x', 'fs', 'nbits', 'f0raw', 'ap','n3sgram');
    %clearvars x fs f0raw apn3sgram
    %keyboard
end
