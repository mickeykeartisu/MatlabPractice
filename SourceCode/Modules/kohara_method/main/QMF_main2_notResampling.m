%音声波形をn個に分割して再構成するプログラム(偶数個のみ)
% clear all;
inputDirName = '../voice_data/sample/';

inputName = 'sample Normal';
% inputName = 'sample Normal_kita';
% inputName = 'sample Normal_kawa';
% inputName = 'sample Normal2';
% inputName = 'he ra zu ke';

[X,fs] = audioread([inputDirName 'wav/' inputName '.wav']);

%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [4]; 
%フィルタ長(ミリ秒)を指定
t = 6;

%フィルタの生成
% N = 96%フィルタのポイント数
% % n = 0:N-1;
% h0 = QMFDesign(N, 0.3, 1); % H0(z)ローパスフィルタ
% % h0 = lowpass(0.25, 100, 0.3);
% g0 = h0;
% h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)ハイパスフィルタ
% g1 = -1 * h1;

load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(t) 'ms'])

%フィルターの遅延を求める
fd = conv(h0,g0); %filter delayを計算
[d,fd] = max(fd);
fdp = fd - 1; %フィルターの遅延を計算（ピーク-1の値）
fdph = floor(fdp/2); 
% fdph = fdp; 

    
for t = 1:length(T)

    L = T(t)-1;
    mode = 1; 
    % 1:ケプストラムを2階微分した系列をフーリエ変換して系列を求める(線形に戻してから平均)
    % 2:ケプストラムを2階微分した系列をフーリエ変換して系列を求める(平均してから線形に戻す)
    % 3:強調されたスペクトル/スペクトルで系列を求める
    % 4:特定次元のケプストラムからゲイン系列を求める(卒論の系列)


    %セル配列の定義   
    stock = cell(T(t),1);
    
    %ループ1:音声の帯域分割
    stock{1} = X;
    for i =1:log2(T(t)),
        for ii=1:2^( log2(T(t)) +1-i ):T(t),
            p = 2^( log2(T(t)) - i);
            stock{ii+p} = conv(h0,stock{ii});
%             keyboard
            stock{ii+p} = stock{ii+p}(1+fdph:end);
%             stock{ii+p} = stock{ii+p}(1:2:length(stock{ii+p}));
            
            stock{ii} = conv(h1,stock{ii});
            stock{ii} = stock{ii}(1+fdph:end);
%             stock{ii} = stock{ii}(1:2:length(stock{ii}));
        end
    end
    
    soundsc(stock{3},16000,24); 
    
    
    %ループ3;音声の再構成
    stockRe = stock;
    for i =log2(T(t)):-1:1,
        for ii=1:2^( log2(T(t)) +1-i ):T(t),
            p = 2^( log2(T(t)) - i);
%             stockRe{ii+p} = upsample(stockRe{ii+p},2);
            stockRe{ii+p} = conv(g0,stockRe{ii+p});
            stockRe{ii+p} = stockRe{ii+p}(1+fdph:end);
            
%             stockRe{ii} = upsample(stockRe{ii},2);
            stockRe{ii} = conv(g1,stockRe{ii});
            stockRe{ii} = stockRe{ii}(1+fdph:end);
            
%             stockRe{ii} = 2*(stockRe{ii}+stockRe{ii+p});
            stockRe{ii} = stockRe{ii}+stockRe{ii+p};
            stockRe{ii} = stockRe{ii}(1+1:end);
%             keyboard
        end
        if i ==1,
           keyboard 
            ReX = stockRe{i}(1:length(X));
        end
    end

    % %--------S/N比--------
    S = sqrt(mean((X.^2))); 
    N = sqrt(mean((ReX-X).* conj(ReX-X)));
    SN = 20*log10(S/N)
    
%     disp(['SN_' num2str(T(t)) 'band:' num2str(SN)]);
    
end