%音声を均等にn個の帯域に分割し、強調処理を行うプログラム()
clear all

calib_file = 'calib_95dB'; %1000Hzのsin波の参照信号の収録信号？
refdb = 98; %参照信号の騒音計dB値　ref・・・reference
setDB = 60; %目標の音圧レベル？
[y_ref, fs_ref] = audioread([calib_file '.wav']);
bit_ref = 24;
[compensate_db, y_max, y_max_fact] = defCalibrationParams(y_ref, fs_ref, refdb);
% audiowrite([calib_file '_maxfact_' num2str(y_max_fact)], y_max, fs_ref, 'BitsPerSample', bit_ref)
cut_wave = 50;

%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = 9;
%フィルタ長(ミリ秒)を指定
f_t = 6;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [16]; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = [0];

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


[gain_v] = getGain4normalization(sigma,setGain);

inputDirName = '../voice_data/sample/';
inputDirName3 = ['../voice_data/new_BandDivision_tec/ATR_16kHz/'];
s_num = 1;
e_num = 1;
hw = waitbar(0,'Please wait...');
for n = s_num:1:e_num,
    waitbar(n/e_num)
    for v = 1:length(maxfreq),
        inputName = ['AN' num2str(n, '%02d')];
        [X,fs] = audioread([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
        load([inputDirName 'mat/ATR_16kHz/' inputName])
        % load ([inputDirName 'mat/label/' inputName '_label']) %ポイントの情報%
        % label = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1/1000);
        % label2 = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1);



        %----------------------straightスペクトルから変動情報信号を求める----------------------------



        % dims = 1;

        flag = 1; %-1:ゲイン系列の正負を反転させる　1:なにもしない

        %フィルタの生成
        load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(f_t) 'ms'])
        % n = 0:N-1;
        % h0 = QMFDesign(N, 0.3, 1); % H0(z)ローパスフィルタ
        % % h0 = lowpass(0.25, 80, 0.3);
        % g0 = h0;
        % h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)ハイパスフィルタ
        % g1 = -1 * h1;

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
            [gainS,D,gainS2]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));

            for i = 1:T(t),
                gainS{i} = mean(gainS{i});
                gainS{i} = LinearInt(gainS{i},stock{i});
            end
            figure
            plot(gainS{1});
            figure
            plot(gainS{16});
            figure
            plot(20*log10(gainS{1}));
            figure
            plot(20*log10(gainS{16}));
            [gainS_t, Weighting_factor] = gainS_processing_test(gainS,T(t),12);
            
%             figure
%             plot(Weighting_factor);
% 
            figure
            plot(gainS_t{1});
            figure
            plot(gainS_t{16});
            figure
            plot(20*log10(gainS_t{1}));
            figure
            plot(20*log10(gainS_t{16}));
            
            %%ループ2:強調処理
            for i = 1:T(t),
%                     gainS{i} = mean(gainS{i});
                    
                    
%                     threshold = mean(gainS{i});
%                     thre.max = max(gainS{i});
%                     thre.min = min(gainS{i});
%                     
%                     for j = 1:length(gainS{i}),
% %                         if threshold > gainS{i}(j) && gainS{i}(j) >= 1,
% %                             gainS{i}(j) = 1;
% %                         end
% %                         if gainS{i}(j) >= (thre.max+thre.min)/2,
% %                             gainS{i}(j) = (thre.max+thre.min)/2;
% %                         end
%                         if gainS{i}(j) >= 4,
%                             gainS{i}(j) = 4;
%                         end
%                     end
%                     
%                     gainS{i} = LinearInt(gainS{i},stock{i});
%                     stockRe{i} = stock{i}.* gainS{i}';
%                     gainS_t{i} = LinearInt(gainS_t{i},stock{i});
                stockRe{i} = stock{i}.* gainS_t{i}';
            end
%             save(['../mat_data/gainS/gainS_' inputName '_' num2str(T(t)) 'Band_' num2str(setGain) 'dB_hanning_' num2str(maxfreq) 'Hz'],'gainS')
%             keyboard
%             figure
%             plot(Weighting_factor);
% 
%             figure
%             plot(gainS_t{1});
%             figure
%             plot(gainS_t{16});

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

            
            outputDirName = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq(v)) 'Hz/'];
    %         outputName = [inputName '_' num2str(empha_Hz) 'Hz_' num2str(setGain) 'dB_' num2str(T(t)) 'band_taper_hanning' num2str(maxfreq) 'Hz'];
            outputName = [inputName '_' num2str(setGain) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz'];
            audiowrite([outputDirName outputName '_test12.wav'],ReX, fs, 'BitsPerSample',24)
            
%             %STRAIGHTスペクトログラムを求める
%             [f0raw, ap] = exstraightsource(ReX, fs);
%             [n3sgram] = exstraightspec(ReX, f0raw, fs);
%             outputDirName = inputDirName3;
%             save ([outputDirName num2str(maxfreq(v)) 'Hz/mat/' outputName '_straight'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram');

            %強調音声を正規化する
            ReX_width = [cut_wave length(ReX)-cut_wave];
            [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);
            outputDirName = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq(v)) 'Hz/'];
    %         outputName = [inputName '_' num2str(empha_Hz) 'Hz_' num2str(setGain) 'dB_' num2str(T(t)) 'band_taper_hanning' num2str(maxfreq) 'Hz'];
            outputName = [inputName '_' num2str(setGain) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz'];
%             audiowrite([outputDirName outputName '_normalization.wav'],ReX_norm/2, fs, 'BitsPerSample',24)
        end


    end
    %入力音声の音圧レベルを正規化する
    X_width = [cut_wave length(X)-cut_wave];
    [X_norm] = getSig4SplNormalization(X/2, fs, compensate_db, setDB, X_width);
%     outputDirName2 = ['../voice_data/shinmitsu_test/normalization/original_normalization/' ];
%     audiowrite([outputDirName inputName '_normalization.wav'],X_norm/2, fs, 'BitsPerSample',24)
end
close(hw)
disp('Completion');
% save('AN01_gainS_16Band_hanning0Hz','gainS')