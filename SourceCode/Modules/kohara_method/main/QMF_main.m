clear all;
inputDirName = '../voice_data/sample/';

inputName = 'sample Normal';
% inputName = 'sample Normal_kita';
% inputName = 'sample Normal_kawa';
% inputName = 'sample Normal2';
% inputName = 'he ra zu ke';

[X,fs_X] = audioread([inputDirName 'wav/' inputName '.wav']);

%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = [4 5 6 7 8 9]; 


%フィルタの生成
N = 96%フィルタのポイント数
% n = 0:N-1;
h0 = QMFDesign(N, 0.3, 1); % H0(z)ローパスフィルタ
% h0 = lowpass(0.25, 100, 0.3);
g0 = h0;
h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)ハイパスフィルタ
g1 = -1 * h1;

%フィルターの遅延を求める
fd = conv(h0,g0); %filter delayを計算
[d,fd] = max(fd);
fdp = fd - 1; %フィルターの遅延を計算（ピーク-1の値）
fdph = floor(fdp/2); 

    
for t = 1:length(T)

    L = T(t)-1;


    %セル配列の定義
    LowX = cell(L,1);
    HighX = cell(L,1);
    LowXRe =  cell(L,1);
    HighXRe = cell(L,1);
    % Lsgram = cell(L,1); %低域のstraightスペクトログラムを格納
    % Hsgram = cell(L,1); %高域の〃
    LCep = cell(L,1); %低域のケプストラムの時系列を格納
    HCep = cell(L,1); %高域の〃


    %ループ1:音声の帯域分割
    buf_X = X; %波形のバッファ
    for i =1:L,
        LowX{i} = conv(h0,buf_X);
        LowX{i} = LowX{i}(1+fdph:end);
        LowX{i} = LowX{i}(1:2:length(LowX{i})); %ダウンサンプリング

        HighX{i} = conv(h1,buf_X);
        HighX{i} = HighX{i}(1+fdph:end);
        HighX{i} = HighX{i}(1:2:length(HighX{i})); %ダウンサンプリング

        buf_X = LowX{i};
    end

    %ループ3;音声の再構成
    for i = L:-1:1,
       if i == L,
           LowXRe{i} = upsample(LowX{i},2); %アップサンプリング
    %        disp('first');
       else
           LowXRe{i} = upsample(LowXRe{i},2); %アップサンプリング
    %        disp('second');
       end

       LowXRe{i} = conv(g0,LowXRe{i});
       LowXRe{i} = LowXRe{i}(1+fdph:end); %遅延を考慮

       HighXRe{i} = upsample(HighX{i},2); %アップサンプリング
       HighXRe{i} = conv(g1,HighXRe{i});
       HighXRe{i} = HighXRe{i}(1+fdph:end); %遅延を考慮

       LowXRe{i} = LowXRe{i}(1:length(HighXRe{i}));

       if i ~= 1,
           LowXRe{i-1} = 2*(LowXRe{i}+HighXRe{i});
           LowXRe{i-1} = LowXRe{i-1}(1+1:end);
       end
    end
    ReX = 2*(LowXRe{1} + HighXRe{1});
    ReX = ReX(1+1:length(X)+1);

    % %--------S/N比--------
    S = sqrt(mean((X.^2))); 
    N = sqrt(mean((ReX-X).* conj(ReX-X)));
    SN = 20*log10(S/N);
    
    disp(['SN_' num2str(T(t)) 'band:' num2str(SN)]);
    
end