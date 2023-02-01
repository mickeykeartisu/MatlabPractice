%�����ɃX�s�[�`�m�C�Y��t������v���O����
%���t���Ώۉ����̒��������m�C�Y������蒷���ꍇ�G���[�����������肠��i2017/10/30�j
%�����̏ꍇ�m�C�Y�������J��Ԃ����ƂŁA������₤�g�p�ɕύX(2017/10/31)
clear all


calib_Dirname = './calib_wav/';
calib_A_name = 'calib_A_02.wav';
calib_B_name = 'calib_B_rec_sin_noise_07.wav';
calib_B__original_name = 'sinwave_whitenoise_48kHz_24bit_-12dB.wav';
calib_A_dB = 91.3;
compensate_db = getSoundPressureCorrection(calib_Dirname, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB);
thre_s_dB = 15;

%�m�C�Y�ǂݍ��ݕ���
inputDirName_noise = '../voice_data/sample/wav/speech_noise/';
num_speaker_max = 64; %�m�C�Y�̘b�Ґ�
num_noise_max = 3;  %�b�҂ЂƂ肠����̃m�C�Y�����̐�
num_conv_max = 30; %�m�C�Y�����Z�����
noise_speech = cell(num_speaker_max,num_noise_max);
% min_length = inf;


s_num = 1;
e_num = 10; 

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

%%�Q�C�����~�b�g�p
threshold_dB = [9];
ratio = Inf;
kneeWidth_dB = 6;

highfreq = 0;

% speaker_name = {'shibata','takeuchi'};
% speaker_name = 'shibata';
speaker_name = 'shibata_straight';
speaker_name_st = 'shibata';
% speaker_name = 'takeuchi';

add_info = cell(e_num,num_conv_max);

%�t������鉹���̎�ނ��w��
sentence_type = 'YSB'; %YSB or ATR

mode = [0 1]; % 0:�������ɎG����t���@1:���������ɎG����t��
% mode = [0]; % 0:�������ɎG����t���@1:���������ɎG����t��
setDB = 70; %�t������鉹���̉������x��
set_noise_DB = [3]; %�t������X�s�[�`�m�C�Y�̉������x���i�t������鉹���̉������x���Ƃ̍����w��j


for setDBvar_num = 1:length(set_noise_DB),
    setDB_noise = setDB - set_noise_DB(setDBvar_num);
    for num_speaker = 1:num_speaker_max,
        for num_noise = 1:num_noise_max,
            inputName_noise = ['SN_ATR' num2str(num_noise, '%02d') '_' num2str(num_speaker, '%02d')];
            [noise_speech{num_speaker,num_noise}, fs_noise] = audioread([inputDirName_noise inputName_noise '.wav']);
        end
    end
    for setGain_num = 1:length(setGain)
        for threshold_dB_num = 1:length(threshold_dB),
            for num_mode = 1:length(mode),
        %     keyboard
                switch mode(num_mode)
                    case 0
                        if strcmp(sentence_type,'YSB') == 1,
                            if strcmp(speaker_name,'shibata') == 1 || strcmp(speaker_name,'shibata_straight') == 1,
                                inputDirName = '../voice_data/sample/wav/shinmitsu_16kHz_cut/'; %�]�����������p
                            elseif strcmp(speaker_name, 'takeuchi') == 1,
                                inputDirName = '../voice_data/sample/wav/shinmitsu_takeuchi_16kHz/'; %�]�����������p     
                            end
                        elseif strcmp(sentence_type,'ATR') == 1,
                            inputDirName = '../voice_data/sample/wav/ATR_16kHz/'; %ATR�����p
                        end
                        outputDirName = ['../voice_data/noise_add_speech/original/'];
                        outputDirName_norm = ['../voice_data/noise_add_speech/normalization/original/'];
                    case 1
                        if strcmp(sentence_type,'YSB') == 1,
                            if threshold_dB(threshold_dB_num) ~= 0,
                                if strcmp(speaker_name,'shibata_straight') == 1,
%                                     inputDirName = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_' num2str(setDB) 'dB/'];
                                    inputDirName = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_30dB/' speaker_name_st '/'];
                                else
                                    inputDirName = ['../voice_data/shinmitsu_test_gainlimit/shinmitsu_' speaker_name '/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/' num2str(maxfreq) 'Hz/' num2str(setGain(setGain_num)) 'dB/Gainlimit_' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB/'];
                                end
                            else
                                if strcmp(speaker_name,'shibata_straight') == 1,
%                                     inputDirName = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_' num2str(setDB) 'dB/'];
                                    inputDirName = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_30dB/' speaker_name_st '/'];
                                else
                                    inputDirName = ['../voice_data/shinmitsu_test_gainlimit/shinmitsu_' speaker_name '/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/' num2str(maxfreq) 'Hz/' num2str(setGain(setGain_num)) 'dB/nolimit/'];
                                end
                                
                            end
                        elseif strcmp(sentence_type,'ATR') == 1,
                            inputDirName = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/']; %ATR�����p
                        end
                        outputDirName = [inputDirName 'add_noise_speech/speech' num2str(setDB) 'dB_noise' num2str(setDB_noise) 'dB/'];
                        outputDirName_norm = [outputDirName 'normalization/'];
                    otherwise
                        disp('error')
                end
                mkdir(outputDirName)

                for n = s_num:1:e_num,
                    switch mode(num_mode)
                        case 0
                            if strcmp(sentence_type,'YSB') == 1,
                                if strcmp(speaker_name,'shibata') == 1 || strcmp(speaker_name,'shibata_straight') == 1,
                                    inputName = ['YSB_' num2str(n, '%04d')]; %�]�����������p
                                elseif strcmp(speaker_name, 'takeuchi') == 1,
                                    inputName = ['YSB_N_' num2str(n, '%04d')]; %�]�����������p
                                end
                            elseif strcmp(sentence_type,'ATR') == 1,
                                inputName = ['AN' num2str(n, '%02d')]; %ATR�����p
                            end
                        case 1
                            if strcmp(sentence_type,'YSB') == 1, %�]�����������p
                                if strcmp(speaker_name,'shibata') == 1,
                                    if threshold_dB(threshold_dB_num) ~= 0,
                                        if highfreq == 0,
                                            inputName = ['YSB_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB'];
                                        else
                                            inputName = ['YSB_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB_HighSup' num2str(highfreq) 'Hz'];
                                        end
                                        
                                    else
                                        if highfreq == 0,
                                            inputName = ['YSB_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_nolimit'];
                                        else
                                            inputName = ['YSB_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_nolimit_HighSup' num2str(highfreq) 'Hz'];
                                        end
                                    end
                                elseif strcmp(speaker_name, 'takeuchi') == 1,
                                    if threshold_dB(threshold_dB_num) ~= 0,
                                        if highfreq == 0,
                                            inputName = ['YSB_N_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB'];
                                        else
                                            inputName = ['YSB_N_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB_HighSup' num2str(highfreq) 'Hz'];
                                        end
                                        
                                    else
                                        if highfreq == 0,
                                            inputName = ['YSB_N_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_nolimit'];
                                        else
                                            inputName = ['YSB_N_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_nolimit_HighSup' num2str(highfreq) 'Hz'];
                                        end
                                        
                                    end
                                elseif strcmp(speaker_name, 'shibata_straight') == 1,
                                    inputName = ['YSB_' num2str(n, '%04d') '_PeakHz16_lin_' num2str(setGain(setGain_num))];
%                                     keyboard
                                end
            %                     inputName = ['YSB_' num2str(n, '%04d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz'];
                            elseif strcmp(sentence_type,'ATR') == 1, %ATR�����p
                                inputName = ['AN' num2str(n, '%02d') '_' num2str(setGain(setGain_num)) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz'];
                            end 
                        otherwise
                            disp('error')
                    end
                    [X,fs] = audioread([inputDirName inputName '.wav']);
                    nbits = audioinfo([inputDirName inputName '.wav']);
                    nbits = nbits.BitsPerSample;
                    s_len  = getSilentTime(X, fs, thre_s_dB);
                    X = getSig4SplNormalization(X, fs, compensate_db, setDB, [s_len length(X)]);

                    noise_conv = zeros(length(X),1);
                    for num_conv = 1:num_conv_max,
                        switch mode(num_mode)
                            case 0
                                r1 = randi([1 num_speaker_max],1);
                                r2 = randi([1 num_noise_max],1);
                                if length(noise_speech{r1,r2}) >= length(X),
                                    r3 = randi([1 (length(noise_speech{r1,r2})-length(X)-1)],1); %�t���Ώۉ����̒��������m�C�Y������蒷���ꍇ�G���[������
                                    add_noiseSpeech = noise_speech{r1,r2}(r3:r3+length(X)-1);
                                elseif length(noise_speech{r1,r2}) < length(X),
                                    add_noiseSpeech = noise_speech{r1,r2};
            %                         keyboard
                                    while length(add_noiseSpeech) < length(X),
                                        add_noiseSpeech = [add_noiseSpeech; noise_speech{r1,r2}];
            %                             keyboard
                                    end
                                    r3 = randi([1 (length(add_noiseSpeech)-length(X)-1)],1);
                                    add_noiseSpeech = add_noiseSpeech(r3:r3+length(X)-1);
                                end
                                    add_info{n,num_conv} = add_noiseSpeech;
                            case 1
                                  add_noiseSpeech = add_info{n,num_conv};
                            otherwise
                                disp('error')
                        end
                        noise_conv = noise_conv + add_noiseSpeech;
            %             keyboard
                    end
                    s_len  = getSilentTime(noise_conv, fs, thre_s_dB);
                    [noise_conv] = getSig4SplNormalization(noise_conv, fs, compensate_db, setDB_noise, [s_len length(noise_conv)]);
                    if length(X) == length(noise_conv),
                        X_conv = X + noise_conv;
                    else
                        if length(X) < length(noise_conv),
                            X_conv = X + noise_conv(1:length(X));
                        elseif length(X) < length(noise_conv),
                            X_conv = X(1:noise_conv) + noise_conv;
                        end
                    end

                    outputName = [inputName '_add_noise_speech' num2str(setDB) 'dB_noise' num2str(setDB_noise) 'dB'];
                    audiowrite([outputDirName outputName '.wav'],X_conv, fs, 'BitsPerSample',nbits)
                    
                    %�m�C�Y�t���ʏ퉹����STRAIGHT�X�y�N�g���O���������߂�
            %         if mode(num_mode) == 0,
            %             [f0raw, ap] = exstraightsource(X_conv, fs);
            %     
            %             [n3sgram] = exstraightspec(X_conv, f0raw, fs);
            %             %keyboard
            %             X = X_conv;
            %             save ([outputDirName 'mat/' outputName], 'X', 'fs', 'nbits', 'f0raw', 'ap','n3sgram');
            %         end
%                     s_len  = getSilentTime(X_conv, fs, thre_s_dB);
%                     X_conv_width = [s_len length(X_conv)];
%                     [X_conv_norm] = getSig4SplNormalization(X_conv, fs, compensate_db, setDB, X_conv_width);
% 
%                     outputName = [inputName '_add_noise_speech' num2str(setDB) 'dB_noise' num2str(setDB_noise) 'dB_normalization'];
%                     audiowrite([outputDirName_norm outputName '.wav'],X_conv_norm, fs, 'BitsPerSample',nbits)

                %     %���͉����̉������x���𐳋K������
                %     X_width = [cut_wave length(X)-cut_wave];
                %     [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
                % 
                %     outputDirName2 = ['../voice_data/shinmitsu_test/normalization/original_normalization/' ];
                %     audiowrite([outputDirName2 inputName '_normalization.wav'],X_norm/4, fs, 'BitsPerSample',24)
                end
            end
        end
    end
end
% close(hw)
disp('Completion');