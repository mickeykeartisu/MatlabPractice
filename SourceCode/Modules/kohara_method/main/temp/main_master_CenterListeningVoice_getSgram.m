%音声を均等にn個の帯域に分割し、強調処理を行うプログラム
%straightスペクトログラム上で強調を行い疑似的に強調された音声のStraightスペクトログラムを求める
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
setGain = 0;
%フィルタ長(ミリ秒)を指定
f_t = 6;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [16]; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = [500];

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

inputDirName = '../voice_data/center_listeningTest_sample/16kHz/';
s_num = 7;
e_num = 7; %max:50
hw = waitbar(0,'Please wait...');
for n = s_num:1:e_num,
    waitbar(n/e_num)
    for v = 1:length(maxfreq),
        inputName = ['No1_S01_16kHz-' num2str(n, '%02d')];
        [X,fs] = audioread([inputDirName inputName '.wav']);
        load([inputDirName inputName])
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
%             [gainS,D,gainS2,D2]= getGainSeries3(gainM,T(t),1,'hanning',fs,maxfreq(v));
            [gainS,D,gainS2,D2]= getGainSeries4_test(gainM,T(t),1,'hanning',fs,maxfreq(v));
            % D：反転させなかった係数行列
            
            %%STRAIGHTスペクトログラムに対して強調処理
            band_length = round(size(n3sgram,1)/T(t));
            pt = 1;
            emp_sgram = n3sgram;
%             for i =1: T(t),
% 
%             end
%             keyboard
            
            %%ループ2:強調処理
            for i = 1:T(t),
                %%%STRAIGHTスペクトログラムに対して強調処理
                gainS_sgram = mean(D{i});
                gainS2_sgram = mean(D2{i});
%                 plot(gainS_sgram);
%                 hold on
%                 plot(gainS2_sgram,'r--')
%                 hold off
%                 title(i)
%                 keyboard
%                 plot(gainS2_sgram./gainS_sgram);
%                 title(i)
%                 keyboard
%                 plot((gainS2_sgram*0.4845)./gainS_sgram);
%                 title(i)
%                 keyboard
                
                if i ~= T(t),
                    gainS_sgram = repmat(gainS_sgram,band_length,1); %ゲイン系列を拡張
                    emp_sgram(pt:pt+band_length-1,:) = emp_sgram(pt:pt+band_length-1,:) .* gainS_sgram;
%                     plot(gainS_sgram);
%                     title(i)
%                     keyboard
                else
                    gainS_sgram = repmat(gainS_sgram,band_length+1,1); %ゲイン系列を拡張
                    emp_sgram(pt:end,:) = emp_sgram(pt:end,:) .* gainS_sgram;
                end
                pt=pt+band_length;
                %%%
                
                gainS{i} = mean(gainS{i});
                gainS{i} = LinearInt(gainS{i},stock{i});

                stockRe{i} = stock{i}.* gainS{i}';
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

            
            outputDirName = '../voice_data/center_listeningTest_sample/16kHz/';
    %         outputName = [inputName '_' num2str(empha_Hz) 'Hz_' num2str(setGain) 'dB_' num2str(T(t)) 'band_taper_hanning' num2str(maxfreq) 'Hz'];
            outputName = [inputName '_' num2str(setGain) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz'];
%             audiowrite([outputDirName outputName '.wav'],ReX, fs, 'BitsPerSample',nbits)

            ReX_width = [cut_wave length(ReX)-cut_wave];
            [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);

            
%             %STRAIGHTスペクトログラムを求める
%             [f0raw, ap] = exstraightsource(ReX, fs);
%             [n3sgram] = exstraightspec(ReX, f0raw, fs);
%             outputDirName = inputDirName3;
            save ([outputDirName 'mat/' outputName '_empSgram'], 'ReX', 'fs', 'f0raw', 'ap','emp_sgram');

            %強調音声を正規化する
%             ReX_width = [cut_wave length(ReX)-cut_wave];
%             [ReX_norm] = getSig4SplNormalization(ReX, fs, compensate_db, setDB, ReX_width);
%             outputDirName = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq(v)) 'Hz/'];
%     %         outputName = [inputName '_' num2str(empha_Hz) 'Hz_' num2str(setGain) 'dB_' num2str(T(t)) 'band_taper_hanning' num2str(maxfreq) 'Hz'];
%             outputName = [inputName '_' num2str(setGain) 'dB_' num2str(T(t)) 'band_hanning' num2str(maxfreq(v)) 'Hz'];
% %             audiowrite([outputDirName outputName '_normalization.wav'],ReX_norm/2, fs, 'BitsPerSample',24)
        end


    end
    %入力音声の音圧レベルを正規化する
%     X_width = [cut_wave length(X)-cut_wave];
%     [X_norm] = getSig4SplNormalization(X/2, fs, compensate_db, setDB, X_width);
%     outputDirName2 = ['../voice_data/shinmitsu_test/normalization/original_normalization/' ];
%     audiowrite([outputDirName inputName '_normalization.wav'],X_norm/2, fs, 'BitsPerSample',24)
end
close(hw)
disp('Completion');