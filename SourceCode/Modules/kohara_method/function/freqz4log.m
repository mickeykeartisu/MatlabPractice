function [h_mix, f, h_nd, h_dd] = freqz4log(f_nd, fftl, fs)
% function [h_mix, h_nd, h_dd, f] = freqz4log(f_nd, fftl, fs)

    if nargin<3,
        fs = 1000;
    end
    
    l = fftl/2+1;
    
    [h_nd, f] = freqz(f_nd, 1, l, fs); %ガウス関数の周波数応答
    [h_dd, f] = freqz([-1 2 -1], 1, l, fs); %微分フィルタの周波数応答
    
    h_nd = abs(h_nd);
    h_dd = abs(h_dd);
    h_mix = h_nd .* h_dd; %二つの周波数応答をかけて合成フィルタの周波数応答を求める
    
    
    
%     figure
%     plot(h_nd);
%     title('周波数応答ベクトル(正規分布)')
%     
%     figure
%     plot(f);
%     title('物理周波数ベクトル');
%     
%     figure
%     plot(h_dd);
%     title('周波数応答ベクトル(2次微分)')
    
%     figure
%     plot(20*log10(h_mix));
%     title('h_mix')
%     
%     [a,b] = max(h_mix);