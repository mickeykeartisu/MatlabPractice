function [ X_cut, cut_info ] = cut_wav( X, fs, thre_v, thre_v2, thre_l, edge_l, speech_l, s_p, e_p )
%CUT_WAV 入力音声を単語ごとに分割する関数
%   X:入力信号
%   fs:サンプリング周波数
%   thre_v:無音区間判定用閾値
%   thre_v2:無音区間判定用閾値（基本的にはthre_vと同じ値でOK）
%   thre_l:無音区間判定区間の長さ（ミリ秒）
%   edge_l:切り取った音声の端の長さ
%   speech_l:切り取った区間から音声の区間だけを取り出す際の閾値
%   s_p:入力音声の分割開始ポイント（この引数は無くてもOK）
%   e_p:入力音声の分割終了ポイント（この引数は無くてもOK）


if nargin < 8
    s_p = 1;
    e_p = length(X);
end
X = X(s_p:e_p);

thre_p = fs/1000*thre_l;

edge_p = fs/1000*edge_l;
speech_p = fs/1000*speech_l;


% keyboard
c_s = zeros(1,100);
c_e = zeros(1,100);
cut_info = zeros(10,2);
count = 1;
% count_2;
% p_memo == p+thre_l-1 || 
% X = X(1495671:2408470);

Xabs =  abs(X);
p = 1;
% for p = 1:length(X),
while 1,
    if thre_v > Xabs(p) %閾値以下か判別
        if p+thre_p-1 < length(X),%音声の長さを超えてないとき
            disc = mean(Xabs(p:p+thre_p-1));
        else%音声の長さを超えた場合
            disc = mean(Xabs(p:end));
        end
        if thre_v > disc, %現在のポイントから指定の区間の平均の振幅が閾値以下だった場合          
           c_s(count) = p;
           p_memo = p;
%            keyboard
            while 1,
                if (thre_v2 < Xabs(p_memo) && thre_v2 < Xabs(p_memo+1)) || p_memo == length(X),
                    c_e(count) = p_memo;
                    count = count + 1;
                    break
                else
                    p_memo = p_memo + 1;
                end
                
            end
            p = p_memo;
        end
    end  
    
    if p == length(X),
        break
    else
        p = p+1;
    end
end

count = 1;
for n = 1:length(c_s)-1,
    if c_s(n+1)-c_e(n) >= speech_p,
%         figure
%         plot(X(c_e(n)-edge_l:c_s(n+1)+edge_l))
%         soundsc(X(c_e(n)-edge_l:c_s(n+1)+edge_l),fs)
        cut_info(count,1) = c_e(n)-edge_p/2;
        cut_info(count,2) = c_s(n+1)+edge_p;
%         keyboard
        count = count + 1; 
    end
end

X_cut = cell(1,size(cut_info,1));
for n = 1:size(cut_info,1),
    X_cut{n} = X(cut_info(n,1):cut_info(n,2));
%     if n == 50,
%         X_cut{n} = X(cut_info(n,1):cut_info(n,2)+edge_p);
%     end
end

end

