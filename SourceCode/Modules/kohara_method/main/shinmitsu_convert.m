%4モーラ単語リストの音声のサンプリング周波数を変換した音声を出力し、STRAIGHTスペクトログラムも求めて出力する%
clear all
inputDirName = '../voice_data/sample/';
s_num = 1;
e_num = 300;

fs = 16000;

for n = s_num:e_num,
%     inputName = ['YSB_' num2str(n, '%04d')];
    inputName = ['YSB_C_' num2str(n, '%04d')];
%     outputName = ['YSB_N_' num2str(n, '%04d')];
    outputName = ['YSB_C_' num2str(n, '%04d')];

%     [X_in,fs_in] = audioread([inputDirName 'wav/shinmitsu_24kHz_cut/' inputName '.wav']);
    [X_in,fs_in] = audioread([inputDirName 'wav/shinmitsu_takeuchi/cut/' inputName '.wav']);
    nbit = audioinfo([inputDirName 'wav/shinmitsu_takeuchi/cut/' inputName '.wav']);
    nbit = nbit.BitsPerSample;
    
    X = sfconv(X_in,fs_in,fs);
    
    [f0raw, ap] = exstraightsource(X, fs);

    [n3sgram] = exstraightspec(X, f0raw, fs);
        
%     save ([inputDirName 'mat/shinmitsu_16kHz_cut/' inputName], 'X', 'fs', 'f0raw', 'ap','n3sgram');
%     
%     audiowrite([inputDirName 'wav/shinmitsu_16kHz_cut/' inputName '.wav'],X, fs, 'BitsPerSample',24)

    save ([inputDirName 'mat/shinmitsu_takeuchi_16kHz/' outputName], 'X', 'fs', 'f0raw', 'ap','n3sgram','nbit');
    
    audiowrite([inputDirName 'wav/shinmitsu_takeuchi_16kHz/' outputName '.wav'],X, fs, 'BitsPerSample',nbit)
end

%柴田合成音用
% calib_file = 'calib_95dB';
% refdb = 98;
% setDB = 60;
% cut_wave = 50;
% [y_ref, fs_ref, bit_ref] = wavread([calib_file '.wav']);
% [compensate_db, y_max, y_max_fact] = defCalibrationParams(y_ref, fs_ref, refdb);
% for n = s_num:e_num,
%     inputName = ['YSB_' num2str(n, '%04d')];
% 
%     [X_in,fs_in] = audioread([inputDirName 'wav/shibata_sample/syn_data_test_60_dB_110202/' inputName '_PeakHz16_lin_6.wav']);
%     
%     X = sfconv(X_in,fs_in,fs);
%     
%     
% %     X_width = [cut_wave length(X)-cut_wave];
% %     [X] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
% %     [f0raw, ap] = exstraightsource(X, fs);
% % 
% %     [n3sgram] = exstraightspec(X, f0raw, fs);
% 
% %     save ([inputDirName 'mat/shinmitsu_16kHz_cut/' inputName], 'X', 'fs', 'f0raw', 'ap','n3sgram');
%     
%     audiowrite([inputDirName 'wav/shibata_sample/syn_data_test_60_dB_110202_16kHz/' inputName '_PeakHz16_lin_6.wav'],X, fs, 'BitsPerSample',24)
% end


%matファイル確認用
% for n = s_num:e_num,
%     inputName = ['YSB_' num2str(n, '%04d')];
%     
%     load([inputDirName 'mat/shinmitsu_16kHz/' inputName])
%     
%     synthParams.pconv = 1.0;    synthParams.fconv = 1.0;    synthParams.sconv = 1.0;
%     X_syn = exstraightsynth(f0raw,n3sgram,ap,fs,synthParams);
%     
%     sound(X_syn./32768,fs);
% 
%     save ([inputDirName 'mat/shinmitsu_16kHz/' inputName], 'X', 'fs', 'f0raw', 'ap','n3sgram');
%     
%     audiowrite([inputDirName 'wav/shinmitsu_16kHz/' inputName '.wav'],X, fs, 'BitsPerSample',24)
% end