clear all
inputName = 'sample Normal';

[A,fs] = audioread([inputName '.wav']);
load (inputName);
% label = sploadlabel([inputName '_label.txt'],'point',1/1000);


[Hd, b]= Bandtest(fs,100,10,16); %%バンドパスフィルタを定義
freqz(b,1)

% figure
% plot(n3sgram);

%ケプストラムを求める
lifter = 0;
cep = getSt2Cep(n3sgram,1);
% cep(1,:) = []; %0次を削除
cep = 10.^(cep);
%


n3sgram_1 = n3sgram(:,1); 
% 
% figure
% plot(n3sgram_1);

% X = filter2(b,n3sgram_1,'same');

% figure
% plot(n3sgram_1.*b');

X = filter2(b,cep);
plot(log(X))

%%
%柴田メソッド
gain_v = getGain4normalization(sigma_v, set_gain_dB, marg_v);
cep = getSt2Cep(n3sgram,1);cep_emp = cell(length(sigma_v), 1); %セル配列
n3sgram_emp = cell(length(sigma_v), 1); %セル配列
for v=1:length(sigma_v),
    LogCep = getLogCep(cep, sigma_v(v), marg_v(v)); %平滑化
    cep_emp{v} = cep + LogCep * gain_v(v);
    n3sgram_emp{v} = getCep2spec(cep_emp{v}, 2*(size(n3sgram,1)-1), 'linear');
    
    LogCepNorm{v} = (20/log(10)) .* sqrt( 2 .* sum((LogCep(2:end,:)* gain_v(v)).^2, 1) );
end


%%
%フィルタ適用前と適用後の時系列の信号を周波数領域に変換
cep_fft = fft(cep,512); %フーリエ変換
cep_fft = abs(cep_fft); %絶対数を求める
cep_fft = 20*log10(cep_fft);
figure
plot(cep_fft(1:257)); 
title('1次の時系列')
setLabel('Frequency[Hz]', 'log amplitude', '', 16);
set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 


X_fft = fft(X,512); %フーリエ変換
X_fft = abs(X_fft); %絶対数を求める
X_fft = 20*log10(X_fft);
figure
plot(X_fft(1:257)); 
title('フィルタ適用後')
setLabel('Frequency[Hz]', 'log amplitude', '', 16);
set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 

% xplot = (0:length(cep)-1);
% figure
% plot(xplot,20*log10(cep));
% title(['1次ケプストラムの時系列'])
% setLabel('Time[ms]', 'log amplitude', '', 16);
% set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
% xlim([1 max(xplot)])
% figure
% plot(xplot,20*log10(X));
% title(['フィルタ適用後'])
% setLabel('Time[ms]', 'log amplitude', '', 16);
% set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
% xlim([1 max(xplot)])




