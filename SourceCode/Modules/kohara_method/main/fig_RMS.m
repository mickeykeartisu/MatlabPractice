clear all

scrsz = get(0,'ScreenSize'); %%ウィンドウサイズを取得


%%パラメータの指定
%強調する変調周波数の値(Hz)
empha_Hz = 16;
%ゲインの増幅の倍率の指定(dB)
setGain = 6;
%分割数を定義(2帯域に分割するなら2 3帯域なら3....)
T = 16; 
%ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
maxfreq = 500;

inputDirName = '../voice_data/sample/';
inputDirName_AE = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/'];

outputDirName = '../fig_data/RMS_comparison/';
mkdir(outputDirName);

frame_t = 10; %フレーム長(ミリ秒)
shift_t = 1; %シフト長（ミリ秒）

% for i = 1:5,
%     inputName_AN = ['AN' num2str(i,'%02d')];
%     inputName_AE = ['AN' num2str(i, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz'];
%     [AN.X, AN.fs]= audioread ([inputDirName 'wav/ATR_16kHz/' inputName_AN '.wav']);
%     [AE.X, AE.fs]= audioread ([inputDirName_AE inputName_AE '.wav']);
% 
%     AN.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AN '_lab.txt'],'point',1/1000);
% %     AE.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AE '_lab.txt'],'point',1/1000);
%     
%     frame_p = AN.fs/1000 * frame_t; %サンプリング周波数16kHzの時のフレーム長20ms%
%     shift_p = AN.fs/1000 * shift_t; %サンプリング周波数16kHzの時のフレームシフト1ms%
% 
%     AN.R = floor((length(AN.X)-frame_p)/shift_p); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める
%     AE.R = floor((length(AE.X)-frame_p)/shift_p); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める
% 
%     AN.rms = zeros(1,AN.R);
%     AE.rms = zeros(1,AE.R);
%     point = 1;
%     for ii = 1:1:AN.R,
%         x = AN.X(point:point+(frame_p-1));
%         rmsV = getRms(x,frame_p);
%         AN.rms(ii) = 20*log10(rmsV);
%         point = point+shift_p;
%     end
%     
%     point = 1;
%     for ii = 1:1:AE.R,
%         x = AE.X(point:point+(frame_p-1));
%         rmsV = getRms(x,frame_p);
%         AE.rms(ii) = 20*log10(rmsV);
%         point = point+shift_p;
%     end
%     
%     x_lim = [AN.label(1).time-50 AN.label(end).time+50];
%     y_lim = [min(AE.rms)-10 max(AE.rms)+10];
%     fontsize = 20;
%     ylabel_fontsize = 20;
%     
%     figure('Name',[''],'NumberTitle','off', 'Position',[1 1 9*scrsz(3)/10 5*scrsz(4)/10])
%     plot(AN.rms,'b');
%     set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
%     xlabel('Time [ms]', 'fontsize', fontsize);
%     ylabel('RMS [dB]', 'fontsize', ylabel_fontsize);
%     xlim(x_lim);
%     ylim(y_lim)
%     spplotlabel(AN.label,'k:',26);
%     
%     hold on
%     plot(AE.rms,'r');
%     xlim(x_lim)
%     ylim(y_lim)
% %     spplotlabel(AN.label,'k:',26);
%     hold off
%     
%     saveas(gcf,[outputDirName inputName_AE '_RMS.emf']); %直前のfigureを保存
% end

inputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\sample\wav\center_listeningTest_sample\test_4\';
inputDirName_AE = 'C:\Users\share\Documents\MATLAB\voice_data\center_listeningTest\test_4\';

outputDirName = '../fig_data/RMS_comparison/';

for i = 1:1,
    inputName_AN = ['No1_S01_16kHz'];
    inputName_AE = ['No1_S01_16kHz_3dB_16band_hanning500Hz_Gainlimit6dB'];
    [AN.X, AN.fs]= audioread ([inputDirName inputName_AN '.wav']);
    [AE.X, AE.fs]= audioread ([inputDirName_AE inputName_AE '.wav']);

%     AN.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AN '_lab.txt'],'point',1/1000);
%     AE.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AE '_lab.txt'],'point',1/1000);
    
    frame_p = AN.fs/1000 * frame_t; %サンプリング周波数16kHzの時のフレーム長20ms%
    shift_p = AN.fs/1000 * shift_t; %サンプリング周波数16kHzの時のフレームシフト1ms%

    AN.R = floor((length(AN.X)-frame_p)/shift_p); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める
    AE.R = floor((length(AE.X)-frame_p)/shift_p); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める

    AN.rms = zeros(1,AN.R);
    AE.rms = zeros(1,AE.R);
    point = 1;
    for ii = 1:1:AN.R,
        x = AN.X(point:point+(frame_p-1));
        rmsV = getRms(x,frame_p);
        AN.rms(ii) = 20*log10(rmsV);
        point = point+shift_p;
    end
    
    point = 1;
    for ii = 1:1:AE.R,
        x = AE.X(point:point+(frame_p-1));
        rmsV = getRms(x,frame_p);
        AE.rms(ii) = 20*log10(rmsV);
        point = point+shift_p;
    end
    
%     x_lim = [AN.label(1).time-50 AN.label(end).time+50];
    y_lim = [min(AE.rms)-10 max(AE.rms)+10];
    fontsize = 20;
    ylabel_fontsize = 20;
    
    figure('Name',[''],'NumberTitle','off', 'Position',[1 1 9*scrsz(3)/10 5*scrsz(4)/10])
    plot(AN.rms,'b');
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlabel('Time [ms]', 'fontsize', fontsize);
    ylabel('RMS [dB]', 'fontsize', ylabel_fontsize);
%     xlim(x_lim);
    ylim(y_lim)
%     spplotlabel(AN.label,'k:',26);
    
    hold on
    plot(AE.rms,'r');
%     xlim(x_lim)
    ylim(y_lim)
%     spplotlabel(AN.label,'k:',26);
    hold off
    
%     saveas(gcf,[outputDirName inputName_AE '_RMS.emf']); %直前のfigureを保存
end
