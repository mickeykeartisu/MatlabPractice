%音声を均等にn個の帯域に分割し、強調処理を行うプログラム(修論の主観評価実験を行うための音声を作成したプログラムはこれです)
clear all

%キャリブレーション信号読み込み
%この入力信号を基に，音声の音圧正規化を行います
calib_Dirname = './calib_wav/';
calib_A_name = 'calib_A_02.wav';
calib_B_name = 'calib_B_rec_sin_noise_07.wav';
calib_B__original_name = 'sinwave_whitenoise_48kHz_24bit_-12dB.wav';
calib_A_dB = 91.3; %キャリブレーター音圧
thre_s_dB = 15; %無音区間検出用閾値
compensate_db = getSoundPressureCorrection(calib_Dirname, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB);

%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = [6];
%フィルタ長(ミリ秒)を指定
f_t = 6;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [16]; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = [500];
%音声正規化の目標音圧レベル
setDB = 70;

%%ゲインリミット条件
threshold_dB =[9];
ratio = Inf;
kneeWidth_dB = 6;

%音声の種類（話者の違い）
% speaker_name = {'shibata','takeuchi'};
speaker_name = {'shibata'};
% speaker_name = {'takeuchi'};

%周波数特性のピークを基にガウス関数のσの値を求める
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
for s_n = 1:length(speaker_name) %話者数
    for n = s_num:1:e_num, %処理する音声の数
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
                    
                    %フィルタの生成
                    %※saveQMFfilterCoeで事前にフィルタを作っておく
                    %必ず入力音声のサンプリング周波数にあったフィルタを作成すること
                    load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(f_t) 'ms'])

                    %フィルターの遅延を求める
                    fd = conv(h0,g0); %filter delayを計算
                    [d,fd] = max(fd);
                    fdp = fd - 1; %フィルターの遅延を計算（ピーク-1の値）
                    fdph = floor(fdp/2); 

                    %---------------柴田メソッドによる強調されたスペクトルを求める----------------
                    flag = 1; %-1:ゲイン系列の正負を反転させる　1:なにもしない
                    coe = [-1, 2, -1];
                    lifter = round(4 * fs /1000);
                    cep = getSt2Cep(n3sgram,lifter); %関数getSt2Cep呼び出し
                    plot(cep(1,:))%%一行目を取り出し=0次のケプストラムの時系列
                    LogCep = getLogCep(cep, sigma, marg,flag,coe); %平滑化
                    LogCep = LogCep * gain_v;
                    %※対数で出力されるように変更
                    gainM = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'dB'); %ケプストラムの係数行列を周波数領域に戻す% % 

                    for t = 1:length(T),
                        %セル配列の定義
                        stock = cell(T(t),1);
                        stockRe = cell(T(t),1);
                        gainS_limit = cell(T(t),1);

                       %ループ1:音声の帯域分割
                       %※stockには高域の帯域から順番に格納されます．
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
                                                
                        %係数行列の分割
                        [gainS,D,gainS2]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));
                       
                        %%ループ2:強調処理
                        for i = 1:T(t),
                                gainS{i} = mean(gainS{i});
                                gainS2{i} = mean(gainS2{i});
                                if threshold_dB(threshold_dB_num) ~= 0,
                                    %ゲイン系列にリミットをかける
                                    gainS_limit{i} = softlimit(gainS{i} , threshold_dB(threshold_dB_num), ratio, kneeWidth_dB);
                                    gainS_limit{i} = LinearInt(gainS_limit{i},stock{i});
                                    stockRe{i} = stock{i}.* gainS_limit{i}';
                                else
                                    gainS{i} = LinearInt(gainS{i},stock{i});
                                    stockRe{i} = stock{i}.* gainS{i}';
                                end
                        end
                        
                        %ループ3;音声の再構成（強調音声の生成）
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

                        %STRAIGHTスペクトログラムを求める
%                         mkdir([outputDirName 'mat/']);
%                         [f0raw, ap] = exstraightsource(ReX, fs);
%                         [n3sgram] = exstraightspec(ReX, f0raw, fs);
%                         save ([outputDirName 'mat/' outputName '_sgram'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram');

                        %強調音声の音圧レベルを正規化する
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
        %入力音声（原音声）の音圧レベルを正規化する
        X_s_len  = getSilentTime(X, fs, thre_s_dB);
        X_width = [X_s_len length(X)];
        [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
        outputDirName_orinorm = ['../voice_data/shinmitsu_test_gainlimit/shinmitsu_' speaker_name{s_n} '/original_normalization/normalization' num2str(setDB) 'dB/' ];
        mkdir(outputDirName_orinorm);
        audiowrite([outputDirName_orinorm inputName '_normalization' num2str(setDB) 'dB.wav'],X_norm, fs, 'BitsPerSample',24)
    end
end
disp('Completion');