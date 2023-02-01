%�������ϓ���n�̑ш�ɕ������A�����������s���v���O����(ATR�����p)
clear all


%�L�����u���[�g�M���ǂݍ���
calib_Dirname = './calib_wav/';
calib_A_name = 'calib_A_02.wav';
calib_B_name = 'calib_B_rec_sin_noise_07.wav';
calib_B__original_name = 'sinwave_whitenoise_48kHz_24bit_-12dB.wav';
calib_A_dB = 91.3; %�L�����u���[�^�[����
thre_s_dB = 15; %������Ԍ��o�p臒l
compensate_db = getSoundPressureCorrection(calib_Dirname, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB);
setDB = 50; %�ڕW�̉������x��

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
maxfreq = [0 500];

%%�Q�C�����~�b�g�p
threshold_dB =[0 9];
ratio = Inf;
kneeWidth_dB = 6;


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
% marg = 200;
marg = sigma * 5;

% noisedB = 10; %�m�C�Y���艹���p�F�m�C�Y�Ɖ����̉����̍��̒l



inputDirName = '../voice_data/sample/';
% inputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\noise_add_speech\original\'; %�m�C�Y���艹���p
s_num = 1;
e_num = 10;
for n = s_num:1:e_num,
    for setGain_num = 1:length(setGain)
        [gain_v] = getGain4normalization(sigma,setGain(setGain_num));
        for threshold_dB_num = 1:length(threshold_dB)
            for v = 1:length(maxfreq),
                inputName = ['AN' num2str(n, '%02d')];
        %         inputName = ['AN' num2str(n, '%02d') '_add_noise_' num2str(noisedB) 'dB']; %�m�C�Y����p�t�@�C����
                [X,fs] = audioread([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
                load([inputDirName 'mat/ATR_16kHz/' inputName])

        %         %�m�C�Y���艹���p
        %         [X,fs] = audioread([inputDirName inputName '.wav']);
        %         load([inputDirName 'mat\' inputName])
        %         %
                % load ([inputDirName 'mat/label/' inputName '_label']) %�|�C���g�̏��%
                label = sploadlabel([inputDirName 'label/ATR_label/' inputName '_lab.txt'],'point',1/1000);
                % label2 = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1);



                %----------------------straight�X�y�N�g������ϓ����M�������߂�----------------------------



                % dims = 1;

                flag = 1; %-1:�Q�C���n��̐����𔽓]������@1:�Ȃɂ����Ȃ�

                %�t�B���^�̐���
                %��saveQMFfilterCoe�Ŏ��O�Ƀt�B���^������Ă���
                load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(f_t) 'ms'])

                %�t�B���^�[�̒x�������߂�
                fd = conv(h0,g0); %filter delay���v�Z
                [d,fd] = max(fd);
                fdp = fd - 1; %�t�B���^�[�̒x�����v�Z�i�s�[�N-1�̒l�j
                fdph = floor(fdp/2); 

                %---------------�ēc���\�b�h�ɂ�鋭�����ꂽ�X�y�N�g�������߂�----------------
                coe = [-1, 2, -1];
                lifter = round(4 * fs /1000);
                cep = getSt2Cep(n3sgram,lifter); %�֐�getSt2Cep�Ăяo��
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
                %     gainS = getGainSeries2(gainM,T(t),1);
                    [gainS,D,gainS2]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));
%                     [gainS,D,gainS2]= getGainSeries4(gainM,T(t),1,'hanning',fs,maxfreq(v),4000);


                    %%���[�v2:��������
                    for i = 1:T(t),
                            gainS{i} = mean(gainS{i});

                            if threshold_dB(threshold_dB_num) ~= 0,
                                %�Q�C���n��Ƀ��~�b�g��������
                                gainS_limit{i} = softlimit(gainS{i} , threshold_dB(threshold_dB_num), ratio, kneeWidth_dB);
            %                     figure
            %                     plot(gainS{i},'b')
            %                     hold on 
            %                     plot(gainS_limit{i},'r')
            %                     hold off
                                gainS_limit{i} = LinearInt(gainS_limit{i},stock{i});
                                stockRe{i} = stock{i}.* gainS_limit{i}';
%                                 stockRe{i} = stock{i}./ gainS{i}'; %�s���ĉ��p
                            else
                                gainS{i} = LinearInt(gainS{i},stock{i});
                                stockRe{i} = stock{i}.* gainS{i}';
                            end

                    end
                    
                    if 0, %�g�`�ƃQ�C���n��̔�r�̃v���b�g(�C�_�X���C�h�p) (1�ŕ\��)
                        scrsz = get(0,'ScreenSize');
                        fig_size = [0.1 0.1 2*scrsz(3)/5 1.2*scrsz(4)/2];

                        ii = [16 10 8 1];
%                         ii = [16 1];

                        fontsize = 20;
                        lim_fontsize = 20;

                        label_ns = 24;
                        label_ne = 40;
                        
                        x_lim = [10 700];
                        x_lim =[label(1).time-90 label(length(label)).time];
                        x_lim =[label(label_ns).time-90 label(label_ne).time];
                        
                        for iii = 1:length(ii),
                            xplot = (0:length(stock{ii(iii)})-1) / (1000/1000);
                            figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
                            subplot 211
                            plot(xplot,stock{ii(iii)} ,'linewidth', 2);
%                             xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
                            ylabel('Amplitude', 'fontsize', lim_fontsize)
                            set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
                            
                            xlim(x_lim)
                            spplotlabel(label,'k:',20);
%                                 ylim([-0.1 0.1])

                            subplot 212
                            plot(xplot,gainS_limit{ii(iii)} ,'linewidth', 2);
%                             xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
                            ylabel({'Magnification'; ''}, 'fontsize', lim_fontsize)
                            set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
                            
                            xlim(x_lim)
                            spplotlabel(label,'k:',20);
%                             ylim([0 1.1]) 
                        end
                        keyboard
                    end                  

                    %���[�v3;�����̍č\��
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


%                     outputDirName = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/'];
                    
                    if threshold_dB(threshold_dB_num) ~= 0,
                        outputDirName = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/Gainlimit_' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB/'];
                        outputDirName_norm = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/Gainlimit_' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB/normalization/'];
                        outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB'];
                    else
                        outputDirName = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/nolimit/' ];
                        outputDirName_norm = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/nolimit/normalization/' ];
                        outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_nolimit'];
                    end
                    mkdir(outputDirName);
                    audiowrite([outputDirName outputName '.wav'],ReX, fs, 'BitsPerSample',24)

                    %STRAIGHT�X�y�N�g���O���������߂�
%                     [f0raw, ap] = exstraightsource(ReX, fs);
%                     [n3sgram_emp] = exstraightspec(ReX, f0raw, fs);
%                     outputDirName_mat = [outputDirName 'mat/'];
%                     mkdir(outputDirName_mat);
%                     save ([outputDirName_mat outputName '_sgram'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram_emp');

                    %���������𐳋K������
                    ReX_s_len  = getSilentTime(ReX, fs, thre_s_dB);
                    ReX_width = [ReX_s_len length(ReX)];
                    [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);
%                     outputDirName = ['../voice_data/ATR_gainlimit/normalization/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/' num2str(maxfreq(v)) 'Hz/'];
                    mkdir(outputDirName_norm);
                    audiowrite([outputDirName_norm outputName '_normalization' num2str(setDB) 'dB.wav'],ReX_norm, fs, 'BitsPerSample',24)
                end
            end
        end
    end
    %���͉����̉������x���𐳋K������
    X_s_len  = getSilentTime(X, fs, thre_s_dB);
    X_width = [X_s_len length(X)];
    [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
    outputDirName = ['../voice_data/ATR_gainlimit/original_normalization/normalization' num2str(setDB) 'dB/'];
    mkdir(outputDirName);
    audiowrite([outputDirName inputName '_normalization' num2str(setDB) 'dB.wav'],X_norm, fs, 'BitsPerSample',24)
end
disp('Completion');