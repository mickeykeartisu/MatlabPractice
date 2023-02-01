%�������ϓ���n�̑ш�ɕ������A�����������s���v���O����()
clear all

calib_file = 'calib_95dB'; %1000Hz��sin�g�̎Q�ƐM���̎��^�M���H
refdb = 98; %�Q�ƐM���̑����vdB�l�@ref�E�E�Ereference
setDB = 50; %�ڕW�̉������x���H
[y_ref, fs_ref] = audioread([calib_file '.wav']);
bit_ref = 24;
[compensate_db, y_max, y_max_fact] = defCalibrationParams(y_ref, fs_ref, refdb);
% audiowrite([calib_file '_maxfact_' num2str(y_max_fact)], y_max, fs_ref, 'BitsPerSample', bit_ref)
cut_wave = 50;

%%�p�����[�^�̎w��
%��������ϒ����g���̒l(Hz)
empha_Hz = 16;
%�Q�C���̑����̔{���̎w��(dB)
setGain = [0 3 6];
%�t�B���^��(�~���b)���w��
f_t = 6;
%���������`(2�ш�ɕ�������Ȃ�2 3�ш�Ȃ�3....)
T = [16]; 
%�n�j���O������Hz�܂ł����邩�i�ő�l�̓i�C�L�X�g���g���j
maxfreq = [500];

threshold_dB = [9];
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


dir_num_max=4;

name{1} = {'No1_H22_S03_F','No2_H22_S02_F','No3_H22_S13_F','No4_H22_S13_M','No5_H22_S10_M','No6_H22_S15_M','No7_H23_S10_F',...
    'No8_H23_S14_F','No9_H23_S05_F','No10_H23_S11_M','No11_H23_S20_M','No12_H23_S16_M'};

% name{2} = [4 10 19 20 24 31 4 10 19 20 24 31 4 10 19 20 24 31];
name{2} = {'BM081B04','BM081B10','BM081B19','BM081B20','BM081B24','BM081B31','BM082B04','BM082B10','BM082B19','BM082B20',...
    'BM082B24','BM082B31','BM083B04','BM083B10','BM083B19','BM083B20','BM083B24','BM083B31'};

name{3} = {'F1_NF005072','F2_NF008052','F3_NF017058','F4_NF018051','F5_NF023053','F6_NF027086','F7_NF028089','F8_NF051088',...
    'M0_NM003056','M1_NM007014','M2_NM010090','M3_NM026056','M4_NM042090','M5_NM071090','M6_NM084089','M7_NM086013','M8_NM092056'};

name{4} = {'No1_S01','No1_S02','No1_S03','No1_S04','No1_S05','No1_S06',...
    'No2_S07','No2_S08','No2_S09','No2_S10','No2_S11','No2_S12','No2_S13',...
    'No3_S14','No3_S15','No3_S16','No3_S17-19','No4_S20-22','No4_S23-25'};


inputDirName = ['../voice_data/sample/wav/center_listeningTest_sample/'];
outputDirName = '../voice_data/center_listeningTest/';



% for dir_num = 1:dir_num_max,
for dir_num = 3:3,
    inputDirName_2 = [inputDirName 'test_' num2str(dir_num) '/'];
    for n = 1:length(name{dir_num}),
%     for n = 1:1,
%     for n = 18:19, %%'No4_S20-22','No4_S23-25'�p
        for setGain_num = 1:length(setGain)
            [gain_v] = getGain4normalization(sigma,setGain(setGain_num));
%             outputDirName_2 = [outputDirName 'test_' num2str(dir_num) '/' num2str(setGain(setGain_num)) 'dB/'];
%             outputDirName_2_norm = [outputDirName 'test_' num2str(dir_num) '/normalization/' num2str(setGain(setGain_num)) 'dB/'];
%             mkdir(outputDirName_2)
%             mkdir(outputDirName_2_norm)
            for threshold_dB_num = 1:length(threshold_dB)
                for v = 1:length(maxfreq),
                    outputDirName_2 = [outputDirName 'test_' num2str(dir_num) '/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/indistinctness/' num2str(setGain(setGain_num)) 'dB/' num2str(maxfreq(v)) 'Hz/'];
                    outputDirName_2_norm = [outputDirName 'test_' num2str(dir_num) '/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/indistinctness/normalization/' num2str(setGain(setGain_num)) 'dB/' num2str(maxfreq(v)) 'Hz/'];
                    mkdir(outputDirName_2)
                    mkdir(outputDirName_2_norm)
        %         inputName = ['No1_S01_16kHz-' num2str(n, '%02d')];
    %             inputName = ['No1_S' num2str(n, '%02d') '_16kHz'];
                    if dir_num == 1 || dir_num == 4,
                        inputName = [name{dir_num}{n} '_16kHz'];
                    else
                        inputName = [name{dir_num}{n}];
                    end
                    [X,fs] = audioread([inputDirName_2 inputName '.wav']);
                    nbit = audioinfo([inputDirName_2 inputName '.wav']);
                    nbit = nbit.BitsPerSample;
                    if strcmp('No4_S20-22',name{dir_num}{n}) == 1 || strcmp('No4_S23-25',name{dir_num}{n}) == 1,
                        n3sgram = readSTFFile([inputDirName_2 'mat/' inputName '.stf']);
                        n3sgram = n3sgram.spectrogram;
                    else
                        load([inputDirName_2 'mat/' inputName])
                    end
        %             X = X/nbit;
                    % load ([inputDirName 'mat/label/' inputName '_label']) %�|�C���g�̏��%
                    % label = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1/1000);
                    % label2 = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1);



                    %----------------------straight�X�y�N�g������ϓ����M�������߂�----------------------------



                    % dims = 1;

                    flag = 1; %-1:�Q�C���n��̐����𔽓]������@1:�Ȃɂ����Ȃ�

                    %�t�B���^�̐���
                    load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(f_t) 'ms'])
                    % n = 0:N-1;
                    % h0 = QMFDesign(N, 0.3, 1); % H0(z)���[�p�X�t�B���^
                    % % h0 = lowpass(0.25, 80, 0.3);
                    % g0 = h0;
                    % h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)�n�C�p�X�t�B���^
                    % g1 = -1 * h1;

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
                    clear cep;
                    LogCep = LogCep * gain_v;
                    %���ΐ��ŏo�͂����悤�ɕύX
                    gainM = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'dB'); %�P�v�X�g�����̌W���s������g���̈�ɖ߂�% % 
                    clear LogCep;

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
                        [gainS]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));

                        %%���[�v2:��������
                        for i = 1:T(t),
                                gainS{i} = mean(gainS{i});

                            if threshold_dB(threshold_dB_num) ~= 0,
                                %�Q�C���n��Ƀ��~�b�g��������
                                gainS_limit{i} = softlimit(gainS{i} , threshold_dB(threshold_dB_num), ratio, kneeWidth_dB);
%                                 clear gainS;
            %                     figure
            %                     plot(gainS{i},'b')
            %                     hold on 
            %                     plot(gainS_limit{i},'r')
            %                     hold off
                                gainS_limit{i} = LinearInt(gainS_limit{i},stock{i});
%                                 stockRe{i} = stock{i}.* gainS_limit{i}';
                                stockRe{i} = stock{i}./ gainS_limit{i}';
%                                 clear gainS_limit;
%                                 stockRe{i} = stock{i}./ gainS{i}'; %�s���ĉ��p
%                                 keyboard
                            else
                                gainS{i} = LinearInt(gainS{i},stock{i});
%                                 stockRe{i} = stock{i}.* gainS{i}';
                                stockRe{i} = stock{i}./ gainS{i}';
%                                 clear gainS;
                            end
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

                       
                        if threshold_dB(threshold_dB_num) ~= 0,
                            outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d')  'dB_Gainlimit' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB'];
                        else
                            outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_nolimit'];
                        end
        %                 outputName = [inputName '_' num2str(setGain) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_Obscurity']; %�s���ĉ��p
                        audiowrite([outputDirName_2 outputName '_indistinctness.wav'],ReX, fs, 'BitsPerSample',nbit)
                        
                        %���������𐳋K������
                        ReX_width = [cut_wave length(ReX)-cut_wave];
                        [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);
        %                 outputName = [inputName '_' num2str(setGain) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_Obscurity']; %�s���ĉ��p
                        audiowrite([outputDirName_2_norm outputName '_indistinctness_normalization.wav'],ReX_norm, fs, 'BitsPerSample',nbit)
        %                 audiowrite([outputDirName_2 outputName '_normalization_max.wav'],ReX_norm/4, fs, 'BitsPerSample',nbit)
                        % %--------S/N��--------
                %         S = sqrt(mean((X.^2))); 
                %         N = sqrt(mean((ReX-X).* conj(ReX-X)));
                %         SN = 20*log10(S/N)
                    %     disp(['SN_' num2str(T(t)) 'band:' num2str(SN)]);
                    end
                end
            end
        end
%         %���͉����̉������x���𐳋K������
%         X_width = [cut_wave length(X)-cut_wave];
%         [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
% %         outputDirName_2_norm_2 = [outputDirName 'test_' num2str(dir_num) '/normalization/original_normalization/'];
%         outputDirName_2_norm_2 = [outputDirName 'test_' num2str(dir_num) '/original_normalization/'];
%         mkdir(outputDirName_2_norm_2)
%         audiowrite([outputDirName_2_norm_2 inputName '_normalization.wav'],X_norm, fs, 'BitsPerSample',nbit)
%         keyboard
    end
end
% close(hw)
disp('Completion');