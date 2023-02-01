%�����̉������x���𐳋K������v���O����
%�L�����u���[�g�M���ǂݍ���
calib_Dirname = './calib_wav/';
calib_A_name = 'calib_A_02.wav';
calib_B_name = 'calib_B_rec_sin_noise_07.wav';
calib_B__original_name = 'sinwave_whitenoise_48kHz_24bit_-12dB.wav';
calib_A_dB = 91.3; %�L�����u���[�^�[����
thre_s_dB = 15; %������Ԍ��o�p臒l
compensate_db = getSoundPressureCorrection(calib_Dirname, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB);

setDB = 70; %�ڕW�̉������x��

inputDirName = '../voice_data/sample/';

s_num = 1;
e_num = 10;
for n = s_num:1:e_num, %�������鉹���̐�
    inputName = ['AN' num2str(n, '%02d')];
    [X,fs] = audioread([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
    
    [X_s_len, X_e_len] = getSilentTime(X, fs, thre_s_dB);
    X_width = [X_s_len X_e_len];
    [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
    outputDirName = ['../voice_data/ATR_gainlimit/original_normalization/normalization' num2str(setDB) 'dB/'];
    mkdir(outputDirName);
    audiowrite([outputDirName inputName '_normalization' num2str(setDB) 'dB.wav'],X_norm, fs, 'BitsPerSample',24)
end