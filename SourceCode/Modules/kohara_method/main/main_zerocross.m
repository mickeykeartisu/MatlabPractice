%各音声の零交差点を抽出するプログラム
clear all;
close all;

st = 1;                 %ファイルの読み込み開始番号
ed = 1;                %ファイルの読み込み終了番号

inputDirName = '../voice_data/sample/';
inputDirName2 = '../voice_data/';
inputDirName_mat = '../voice_data/sample/';

frame_t = 6; %フレーム長(ミリ秒)
shift_t = 3; %シフト長（ミリ秒）
for i = st:ed
    inputName = ['AN' num2str(i,'%02d')];
    [X, fs]= audioread ([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
%     label = get_label_tanabe(i);        %音声のラベル情報を抽出
    label = sploadlabel([inputDirName 'label/ATR_label/' inputName '_lab.txt'],'point',1);
    
%     N_zero = zeros(length(label),1);
%     zerocross_time = zeros(length(label),1);
    
    [X_zerocross, frame_p, shift_p]= getZerocross(X,fs,frame_t,shift_t);
%     keyboard
    
    xplot = (0:length(X_zerocross)-1) .* shift_p ./ (fs/1000);
%     xplot = linspace(1,X*,length(X_zerocross))
    xplot_1 = (0:length(X)-1) ./ (fs/1000);
    
    
%     figure
%     subplot 211
%     plot(xplot_1,X);
%     
%     subplot 212
    plot(xplot,X_zerocross);
    xlim([1 length(X_zerocross)])
    set( gca, 'FontName','MS UI Gothic','FontSize',20);
    a = ylabel('Zero crossing rate', 'fontsize', 20);
    xlabel('Time [ms]', 'fontsize', 20);
%     
    
    outputname = [inputName '_zerocorss'];
%     save(['C:/work/kennkyu/zerocross/mat/' rfilename '.mat'],'N_zero','zerocross_time','fs');
%     save([outputname '.mat'],'N_zero','zerocross_time','fs');
end

    