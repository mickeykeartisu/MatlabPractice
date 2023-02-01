%音声の音圧レベルを正規化するプログラム
%キャリブレート信号読み込み
calib_Dirname = './calib_wav/';
calib_A_name = 'calib_A_02.wav';
calib_B_name = 'calib_B_rec_sin_noise_07.wav';
calib_B__original_name = 'sinwave_whitenoise_48kHz_24bit_-12dB.wav';
calib_A_dB = 91.3; %キャリブレーター音圧
thre_s_dB = 15; %無音区間検出用閾値
compensate_db = getSoundPressureCorrection(calib_Dirname, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB);

setDB = 70; %目標の音圧レベル

inputDirName = '../voice_data/sample/';

s_num = 1;
e_num = 10;
for n = s_num:1:e_num, %処理する音声の数
    inputName = ['AN' num2str(n, '%02d')];
    [X,fs] = audioread([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
    
    [X_s_len, X_e_len] = getSilentTime(X, fs, thre_s_dB);
    X_width = [X_s_len X_e_len];
    [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
    outputDirName = ['../voice_data/ATR_gainlimit/original_normalization/normalization' num2str(setDB) 'dB/'];
    mkdir(outputDirName);
    audiowrite([outputDirName inputName '_normalization' num2str(setDB) 'dB.wav'],X_norm, fs, 'BitsPerSample',24)
end