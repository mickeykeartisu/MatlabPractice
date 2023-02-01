%�������ϓ���n�̑ш�ɕ������A�����������s���v���O����(�C�_�̎�ϕ]���������s�����߂̉������쐬�����v���O�����͂���ł�)
clear all

%�L�����u���[�V�����M���ǂݍ���
%���̓��͐M������ɁC�����̉������K�����s���܂�
calib_Dirname = './calib_wav/';
calib_A_name = 'calib_A_02.wav';
calib_B_name = 'calib_B_rec_sin_noise_07.wav';
calib_B__original_name = 'sinwave_whitenoise_48kHz_24bit_-12dB.wav';
calib_A_dB = 91.3; %�L�����u���[�^�[����
thre_s_dB = 15; %������Ԍ��o�p臒l
compensate_db = getSoundPressureCorrection(calib_Dirname, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB);

%%�p�����[�^�̎w��
%��������ϒ����g���̒l(Hz)
empha_Hz = 16;
%�Q�C���̑����̔{���̎w��(dB)
setGain = [6];
%�t�B���^��(�~���b)���w��
f_t = 6;
%���������`(2�ш�ɕ�������Ȃ�2 3�ш�Ȃ�3....)
T = [16]; 
%�n�j���O������Hz�܂ł����邩�i�ő�l�̓i�C�L�X�g���g���j
maxfreq = [500];
%�������K���̖ڕW�������x��
setDB = 70;

%%�Q�C�����~�b�g����
threshold_dB =[9];
ratio = Inf;
kneeWidth_dB = 6;

%�����̎�ށi�b�҂̈Ⴂ�j
% speaker_name = {'shibata','takeuchi'};
speaker_name = {'shibata'};
% speaker_name = {'takeuchi'};

%���g�������̃s�[�N����ɃK�E�X�֐��̃Ђ̒l�����߂�
[sigma, marg] = getPeakf2Sigma(empha_Hz);
if empha_Hz ==16,
    sigma = 14.0100;
end
if empha_Hz ==8,
    sigma = 27.9400;
end
if empha_Hz ==4,
    sigma = 55.5500;
end
marg = sigma * 5;

inputDirName = '../voice_data/sample/';
s_num = 1;
e_num = 1;
for s_n = 1:length(speaker_name) %�b�Ґ�
    for n = s_num:1:e_num, %�������鉹���̐�
        for setGain_num = 1:length(setGain)
            [gain_v] = getGain4normalization(sigma,setGain(setGain_num));
            for threshold_dB_num = 1:length(threshold_dB)
                for v = 1:length(maxfreq),
                    if strcmp(speaker_name{s_n},'shibata') == 1,
                        inputName = ['YSB_' num2str(n, '%04d')];
                        [X,fs] = audioread([inputDirName 'wav/shinmitsu_16kHz_cut/' inputName '.wav']);
                        load([inputDirName 'mat/shinmitsu_16kHz_cut/' inputName])
                    elseif strcmp(speaker_name{s_n}, 'takeuchi') == 1,
                        inputName = ['YSB_N_' num2str(n, '%04d')];
                        [X,fs] = audioread([inputDirName 'wav/shinmitsu_takeuchi_16kHz/' inputName '.wav']);
                        load([inputDirName 'mat/shinmitsu_takeuchi_16kHz/' inputName])
                    end
                    
                    %�t�B���^�̐���
                    %��saveQMFfilterCoe�Ŏ��O�Ƀt�B���^������Ă���
                    %�K�����͉����̃T���v�����O���g���ɂ������t�B���^���쐬���邱��
                    load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(f_t) 'ms'])

                    %�t�B���^�[�̒x�������߂�
                    fd = conv(h0,g0); %filter delay���v�Z
                    [d,fd] = max(fd);
                    fdp = fd - 1; %�t�B���^�[�̒x�����v�Z�i�s�[�N-1�̒l�j
                    fdph = floor(fdp/2); 

                    %---------------�ēc���\�b�h�ɂ�鋭�����ꂽ�X�y�N�g�������߂�----------------
                    flag = 1; %-1:�Q�C���n��̐����𔽓]������@1:�Ȃɂ����Ȃ�
                    coe = [-1, 2, -1];
                    lifter = round(4 * fs /1000);
                    cep = getSt2Cep(n3sgram,lifter); %�֐�getSt2Cep�Ăяo��
                    plot(cep(1,:))%%��s�ڂ����o��=0���̃P�v�X�g�����̎��n��
                    LogCep = getLogCep(cep, sigma, marg,flag,coe); %������
                    LogCep = LogCep * gain_v;
                    %���ΐ��ŏo�͂����悤�ɕύX
                    gainM = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'dB'); %�P�v�X�g�����̌W���s������g���̈�ɖ߂�% % 

                    for t = 1:length(T),
                        %�Z���z��̒�`
                        stock = cell(T(t),1);
                        stockRe = cell(T(t),1);
                        gainS_limit = cell(T(t),1);

                       %���[�v1:�����̑ш敪��
                       %��stock�ɂ͍���̑ш悩�珇�ԂɊi�[����܂��D
                        stock{1} = X;
                        for i =1:log2(T(t)),
                            for ii=1:2^( log2(T(t)) +1-i ):T(t),
                                p = 2^( log2(T(t)) - i);
                                stock{ii+p} = conv(h0,stock{ii});
                                stock{ii+p} = stock{ii+p}(1+fdph:end);
                                stock{ii+p} = stock{ii+p}(1:2:length(stock{ii+p}));

                                stock{ii} = conv(h1,stock{ii});
                                stock{ii} = stock{ii}(1+fdph:end);
                                stock{ii} = stock{ii}(1:2:length(stock{ii}));
                            end
                        end
                                                
                        %�W���s��̕���
                        [gainS,D,gainS2]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));
                       
                        %%���[�v2:��������
                        for i = 1:T(t),
                                gainS{i} = mean(gainS{i});
                                gainS2{i} = mean(gainS2{i});
                                if threshold_dB(threshold_dB_num) ~= 0,
                                    %�Q�C���n��Ƀ��~�b�g��������
                                    gainS_limit{i} = softlimit(gainS{i} , threshold_dB(threshold_dB_num), ratio, kneeWidth_dB);
                                    gainS_limit{i} = LinearInt(gainS_limit{i},stock{i});
                                    stockRe{i} = stock{i}.* gainS_limit{i}';
                                else
                                    gainS{i} = LinearInt(gainS{i},stock{i});
                                    stockRe{i} = stock{i}.* gainS{i}';
                                end
                        end
                        
                        %���[�v3;�����̍č\���i���������̐����j
                        for i =log2(T(t)):-1:1,
                            for ii=1:2^( log2(T(t)) +1-i ):T(t),
                                p = 2^( log2(T(t)) - i);
                                stockRe{ii+p} = upsample(stockRe{ii+p},2);
                                stockRe{ii+p} = conv(g0,stockRe{ii+p});
                                stockRe{ii+p} = stockRe{ii+p}(1+fdph:end);

                                stockRe{ii} = upsample(stockRe{ii},2);
                                stockRe{ii} = conv(g1,stockRe{ii});
                                stockRe{ii} = stockRe{ii}(1+fdph:end);

                                stockRe{ii} = 2*(stockRe{ii}+stockRe{ii+p});
                                stockRe{ii} = stockRe{ii}(1+1:end);
                            end
                            if i ==1,
                                ReX = stockRe{i}(1:length(X));
                            end
                        end
                        
                        if threshold_dB(threshold_dB_num) ~= 0,
                            outputDirName = ['../voice_data/shinmitsu_test_gainlimit/shinmitsu_' speaker_name{s_n} '/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/' num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/Gainlimit_' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB/'];
                            outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB'];
                        else
                            outputDirName = ['../voice_data/shinmitsu_test_gainlimit/shinmitsu_' speaker_name{s_n} '/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/' num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/nolimit/'];
                            outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_nolimit'];
                        end
                        mkdir(outputDirName);
                        mkdir([outputDirName 'mat/']);
                        audiowrite([outputDirName outputName '.wav'],ReX, fs, 'BitsPerSample',24)

                        %STRAIGHT�X�y�N�g���O���������߂�
%                         mkdir([outputDirName 'mat/']);
%                         [f0raw, ap] = exstraightsource(ReX, fs);
%                         [n3sgram] = exstraightspec(ReX, f0raw, fs);
%                         save ([outputDirName 'mat/' outputName '_sgram'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram');

                        %���������̉������x���𐳋K������
                        ReX_s_len  = getSilentTime(ReX, fs, thre_s_dB);
                        ReX_width = [ReX_s_len length(ReX)];
                        [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);
                        outputDirName_norm = [outputDirName '/normalization/'];
                        mkdir(outputDirName_norm);
                        audiowrite([outputDirName_norm outputName '_normalization' num2str(setDB) 'dB.wav'],ReX_norm, fs, 'BitsPerSample',24)
                    end
                end
            end
        end
        %���͉����i�������j�̉������x���𐳋K������
        X_s_len  = getSilentTime(X, fs, thre_s_dB);
        X_width = [X_s_len length(X)];
        [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
        outputDirName_orinorm = ['../voice_data/shinmitsu_test_gainlimit/shinmitsu_' speaker_name{s_n} '/original_normalization/normalization' num2str(setDB) 'dB/' ];
        mkdir(outputDirName_orinorm);
        audiowrite([outputDirName_orinorm inputName '_normalization' num2str(setDB) 'dB.wav'],X_norm, fs, 'BitsPerSample',24)
    end
end
disp('Completion');