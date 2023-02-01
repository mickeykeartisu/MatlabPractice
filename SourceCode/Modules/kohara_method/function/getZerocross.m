function [X_zeroscoss, frame_p, shift_p] = getZerocross(X, fs, frame_t, shift_t),
%フレーム分析により零交差数を求める関数

close all

frame_p = fs*frame_t/1000; %フレーム長（ポイント数）を計算
shift_p = fs*shift_t/1000; %シフト長（ポイント数）を計算

L = ceil(length(X)/shift_p);
% L = ceil((length(X)-frame_p)/shift_p);
X_zeroscoss = zeros(1,L);
% keyboard
st = 1;
for l = 1: L,
    zerocross = 0;
    if length(X) >= st+frame_p-1,
        sig = X(st:st+frame_p-1);
    else
        %分析したい音声の残りの長さが分析フレーム長より小さい場合
        sig = X(st:end);
    end
    for t= 1:length(sig)-1,
        if sig(t) >= 0
            if sig(t+1) < 0
                zerocross = zerocross + 1;
            end
        elseif sig(t) < 0
            if sig(t+1) >= 0
                zerocross = zerocross + 1;
            end
        else
            zerocross = zerocross + 1;
        end
    end
    X_zeroscoss(l) = zerocross; 
    st = st+shift_p;
end
end
%syn(syn_pos) = zerocross*100/ms;%1秒間の零交差数を格納
% syn= zerocross;


%%分析フレームを使用し分析する場合は以下

% frame_pos = 1;
% % frame_len = 480;%分析フレーム長
% % shift_len = 240;%分析シフト
% frame_len = round(fs/100);
% shift_len = round(frame_len/2);
% syn_pos = 1;
% %FF = (0:length(sig)-1)/ fs * 1000;
% ms = frame_len / fs * 1000;%point数をmsに直す
% %syn = zeros(length(sig),1);

% while frame_pos + frame_len < length(sig)
%     zerocross = 0;
%     for t = 0 : frame_len-1
%         if sig(frame_pos+t) >= 0
%             if sig(frame_pos+t+1) < 0
%                 zerocross = zerocross + 1;
%             end
%         elseif sig(frame_pos+t) < 0
%             if sig(frame_pos+t+1) > 0
%                 zerocross = zerocross + 1;
%             end
%         else
%             %zerocross = zerocross + 1;
%         end
%     end
%     %syn(syn_pos) = zerocross*100/ms;%1秒間の零交差数を格納
%     syn(syn_pos) = zerocross;
%     syn_pos = syn_pos + 1;
%     frame_pos = frame_pos + shift_len;
% end

% ff = (0:length(syn)-1)/length(syn)*length(sig)/fs;
% figure
% plot (ff,syn);
% set( gca,'FontSize',16 ); 
% xlabel('時間[s]','FontSize',16);
% ylabel('零交差数[回/s]','FontSize',16);
% h = gcf;
% str2 = ['zerocross_' str '.fig'];
% str3 = ['zerocross_' str '.emf'];
% saveas(h,str2)
% saveas(h,str3)
% saveas(h,'zerocross_040_org.fig')
% saveas(h,'zerocross_040_org.emf')
% saveas(h,'zerocross_040_04Hz.fig')
% saveas(h,'zerocross_040_04Hz.emf')