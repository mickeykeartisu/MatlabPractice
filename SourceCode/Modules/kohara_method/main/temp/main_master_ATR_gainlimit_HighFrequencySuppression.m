%音声を均等にn個の帯域に分割し、強調処理を行うプログラム()
clear all

calib_file = 'calib_95dB'; %1000Hzのsin波の参照信号の収録信号？
refdb = 98; %参照信号の騒音計dB値　ref・・・reference
setDB = 50; %目標の音圧レベル？
[y_ref, fs_ref] = audioread([calib_file '.wav']);
bit_ref = 24;
[compensate_db, y_max, y_max_fact] = defCalibrationParams(y_ref, fs_ref, refdb);
% audiowrite([calib_file '_maxfact_' num2str(y_max_fact)], y_max, fs_ref, 'BitsPerSample', bit_ref)
cut_wave = 50;

%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = [3 6];
%フィルタ長(ミリ秒)を指定
f_t = 6;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [16]; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = [500];

%%ゲインリミット用
threshold_dB =[9 12];
ratio = Inf;
kneeWidth_dB = 6;

highfreq = 6000;
widthfreq = 500;

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

% noisedB = 10; %ノイズあり音声用：ノイズと音声の音圧の差の値



inputDirName = '../voice_data/sample/';
% inputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\noise_add_speech\original\'; %ノイズあり音声用
s_num = 1;
e_num = 1;
% hw = waitbar(0,'Please wait...');
for n = s_num:1:e_num,
%     waitbar(n/e_num)
    for setGain_num = 1:length(setGain)
        [gain_v] = getGain4normalization(sigma,setGain(setGain_num));
        for threshold_dB_num = 1:length(threshold_dB)
            for v = 1:length(maxfreq),
                inputName = ['AN' num2str(n, '%02d')];
        %         inputName = ['AN' num2str(n, '%02d') '_add_noise_' num2str(noisedB) 'dB']; %ノイズあり用ファイル名
                [X,fs] = audioread([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
                load([inputDirName 'mat/ATR_16kHz/' inputName])

        %         %ノイズあり音声用
        %         [X,fs] = audioread([inputDirName inputName '.wav']);
        %         load([inputDirName 'mat\' inputName])
        %         %
                % load ([inputDirName 'mat/label/' inputName '_label']) %ポイントの情報%
                % label = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1/1000);
                % label2 = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1);



                %----------------------straightスペクトルから変動情報信号を求める----------------------------



                % dims = 1;

                flag = 1; %-1:ゲイン系列の正負を反転させる　1:なにもしない

                %フィルタの生成
                %※saveQMFfilterCoeで事前にフィルタを作っておく
                load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(f_t) 'ms'])

                %フィルターの遅延を求める
                fd = conv(h0,g0); %filter delayを計算
                [d,fd] = max(fd);
                fdp = fd - 1; %フィルターの遅延を計算（ピーク-1の値）
                fdph = floor(fdp/2); 

                %---------------柴田メソッドによる強調されたスペクトルを求める----------------
                coe = [-1, 2, -1];
                lifter = round(4 * fs /1000);
                cep = getSt2Cep(n3sgram,lifter); %関数getSt2Cep呼び出し
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
                %     gainS = getGainSeries2(gainM,T(t),1);
%                     [gainS,D,gainS2]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));
                    [gainS,D,gainS2]= getGainSeries4(gainM,T(t),1,'hanning',fs,maxfreq(v),highfreq,widthfreq);


                    %%ループ2:強調処理
                    for i = 1:T(t),
                            gainS{i} = mean(gainS{i});

                            if threshold_dB(threshold_dB_num) ~= 0,
                                %ゲイン系列にリミットをかける
                                gainS_limit{i} = softlimit(gainS{i} , threshold_dB(threshold_dB_num), ratio, kneeWidth_dB);
%                                 figure
%                                 plot(gainS{i},'b')
%                                 hold on 
%                                 plot(gainS_limit{i},'r')
%                                 hold off
%                                 keyboard
                                gainS_limit{i} = LinearInt(gainS_limit{i},stock{i});
                                stockRe{i} = stock{i}.* gainS_limit{i}';
%                                 stockRe{i} = stock{i}./ gainS{i}'; %不明瞭化用
                            else
                                gainS{i} = LinearInt(gainS{i},stock{i});
                                stockRe{i} = stock{i}.* gainS{i}';
                            end

                    end

                    %ループ3;音声の再構成
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


%                     outputDirName = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/'];
%                     mkdir(outputDirName);
                    if threshold_dB(threshold_dB_num) ~= 0,
                        outputDirName = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/Gainlimit_' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB/'];
                        outputDirName_norm = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/Gainlimit_' num2str(threshold_dB(threshold_dB_num), '%02d') 'dB/normalization/'];
                        outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB(threshold_dB_num)) 'dB_HighSup' num2str(highfreq) 'Hz'];
                    else
                        outputDirName = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/nolimit/' ];
                        outputDirName_norm = ['../voice_data/ATR_gainlimit/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/'  num2str(maxfreq(v)) 'Hz/' num2str(setGain(setGain_num)) 'dB/nolimit/normalization/' ];
                        outputName = [inputName '_' num2str(setGain(setGain_num)) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz_nolimit_HighSup' num2str(highfreq) 'Hz'];
                    end
                    mkdir(outputDirName);
                    audiowrite([outputDirName outputName '.wav'],ReX, fs, 'BitsPerSample',24)

        %             %STRAIGHTスペクトログラムを求める
        %             [f0raw, ap] = exstraightsource(ReX, fs);
        %             [n3sgram] = exstraightspec(ReX, f0raw, fs);
        %             outputDirName = inputDirName3;
        %             save ([outputDirName num2str(maxfreq(v)) 'Hz/mat/' outputName '_straight'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram');

                    %強調音声を正規化する
                    ReX_width = [cut_wave length(ReX)-cut_wave];
                    [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);
%                     outputDirName = ['../voice_data/ATR_gainlimit/normalization/kneeWidth_dB_' num2str(kneeWidth_dB, '%02d') 'dB/' num2str(maxfreq(v)) 'Hz/'];
                    mkdir(outputDirName_norm);
                    audiowrite([outputDirName_norm outputName '_normalization.wav'],ReX_norm, fs, 'BitsPerSample',24)
                end
            end
        end
    end
    %入力音声の音圧レベルを正規化する
    X_width = [cut_wave length(X)-cut_wave];
    [X_norm] = getSig4SplNormalization(X, fs, compensate_db, setDB, X_width);
    outputDirName = ['../voice_data/ATR_gainlimit/original_normalization/'];
    mkdir(outputDirName);
    audiowrite([outputDirName inputName '_normalization.wav'],X_norm, fs, 'BitsPerSample',24)
end
% close(hw)
disp('Completion');