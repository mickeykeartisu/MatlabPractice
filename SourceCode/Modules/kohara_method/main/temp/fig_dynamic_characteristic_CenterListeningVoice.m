% 通常音声と強調音声の動的特徴を比較するプログラム
clear all

scrsz = get(0,'ScreenSize'); %%ウィンドウサイズを取得

inputDirName = '../voice_data/center_listeningTest_sample/16kHz/';
% inputDirName2 = '../voice_data/';
% inputDirName_mat = '../voice_data/sample/';

% inputName = 'AN01';
% inputName2 = 'AC01';

setdB = 3;

%     inputName = ['No1_S01_16kHz-' num2str(n, '%02d')];
%     if n == 0,
        inputName = ['No1_S01_16kHz'];
%     end
    
    AN = load ([inputDirName inputName]); %%Matデータ読み込み
    AE = load([inputDirName 'mat/' inputName '_' num2str(setdB) 'dB_16band_hanning500Hz_empSgram']);
    % AC = load([inputDirName 'mat/ATR_16kHz/' inputName2]); %%Matデータ読み込み
    


    % label = sploadlabel([inputDirName 'label/ATR_label/' inputName '_lab.txt'],'point',1/1000);
    % label = sploadlabel([inputDirName 'label/ATR_label/' inputName '_lab.txt'],'point',1);
    % keyboard
    % load('../mat_data/user/shibata/label/ac06.mat')
    % AC.label3 = label;
    % load('../mat_data/user/shibata/label/aN06.mat')
    % AN.label3 = label;

    % label3 = spoffsetlabel(label3, 25);

    % keep3 n3sgram fs ap f0raw label3
    % dispsgram(n3sgram, fs)
    % xlim([200 1330])
    % spplotlabel(label3)
    %%
    p.msdceptime = 50;

    AN.cep = getSt2Cep(AN.n3sgram, 45);
    % AC.cep = getSt2Cep(AC.n3sgram, 45);
    AE.cep = getSt2Cep(AE.emp_sgram, 45);

    AN.dcep = getDeltaCep4(AN.cep, p);
    AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AN.norm_dcep = getDcepNorm(AN.dcep, 0);

    % AC.dcep = getDeltaCep4(AC.cep, p);
    % AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    % AC.norm_dcep = getDcepNorm(AC.dcep, 0);

    AE.dcep = getDeltaCep4(AE.cep, p);
    AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AE.norm_dcep = getDcepNorm(AE.dcep, 0);

    %パワースペクトル算出
%     AN.power = mean(AN.n3sgram);
%     AN.power = 10*log10(AN.power.^2);
%     plot(AN.power);
%     keyboard

    %%
    xplot_AN = (0:length(AN.norm_dcep)-1) / (16000/1000);
    xplot_AN = (0:length(AN.norm_dcep)-1) / (16000);
    % xplot_AN = linspace(220,1300,length(AN.norm_dcep));
%     xplot_AC = (0:length(AC.norm_dcep)-1) / (24000/1000);
%     xplot_AE = (0:length(AE.norm_dcep)-1) / (24000/1000);


%     x_lim = [250 1100];

%     figure('Name',[''],'NumberTitle','off', 'Position',[0.1 0.1 3.7*scrsz(3)/5 2.5*scrsz(4)/5])
%     % set(gcf, 'position',  [130 531 650 280])
%     plot(AN.norm_dcep, 'r--', 'linewidth', 3)
%     set( gca, 'FontName','MS UI Gothic','FontSize',32);
%     % set( gca, 'XTick', 0:100:length(AN.norm_dcep));
%     % set( gca, 'XTicklabel', 0:0.1:length(AN.norm_dcep)/1000);
%     xlim(x_lim)
% %     ylim([0 1.2])
%     a = ylabel('D_\Delta(t) [dB]', 'fontsize', 32);
%     xlabel('Time [ms]', 'fontsize', 32);
%     % set(gca, 'OuterPosition', [0 0.53 1 0.46])
%     % L = legend('Normal Speech','Clear Speech','Enhanced Speech');
%     % set( L, 'FontSize',32);
%     set( gca, 'FontName','MS UI Gothic','FontSize',26);
% %     spplotlabel(label,'k:',26);

for n = 0:0,
    switch n
        case 0
            x_lim = [250 12650];
        case 1
            x_lim = [250 1150];
        case 2
            x_lim = [1700 3550];
        case 3
            x_lim = [4200 5150];
        case 4
            x_lim = [5550 8000];
        case 5
            x_lim = [8700 10600];
        case 6
            x_lim = [11110 12650];
    end
    
    
    gcf = figure('Name',[''],'NumberTitle','off', 'Position',[0.1 0.1 3.7*scrsz(3)/5 2.5*scrsz(4)/5]);
    % set(gcf, 'position',  [130 531 650 280])
    plot(AN.norm_dcep, 'r', 'linewidth', 3)
    if n==0
        title(['No1\_S01\_16kHz\_' num2str(setdB) 'dB'],'FontSize',32)
%         title(['No1\_S01\_16kHz\_' num2str(setdB) 'dB\_OriginalSpeechOnly'],'FontSize',32)
    else
        title(['No1\_S01\_16kHz\_' num2str(setdB) 'dB\_' num2str(n,'%02d')],'FontSize',32)
    end
    hold on
    % plot(AC.norm_dcep, 'b--', 'linewidth', 3)
    plot(AE.norm_dcep, 'b--', 'linewidth', 3)
    % plot(AE.norm_dcep, 'r:', 'linewidth', 2)
    set( gca, 'FontName','MS UI Gothic','FontSize',32);
    % set( gca, 'XTick', 0:100:length(AN.norm_dcep));
    % set( gca, 'XTicklabel', 0:0.1:length(AN.norm_dcep)/1000);
    xlim(x_lim)
    ylim([0 2.0])
    a = ylabel('D_\Delta(t) [dB]', 'fontsize', 32);
    xlabel('Time [ms]', 'fontsize', 32);
    % set(gca, 'OuterPosition', [0 0.53 1 0.46])
    L = legend('Original Speech','Enhanced Speech');
%     L = legend('Original Speech');
    set( L, 'FontSize',24);
    set( gca, 'FontName','MS UI Gothic','FontSize',26);
%     spplotlabel(label,'k:',26);
    hold off
    
    if n==0
        saveas(gcf,[inputDirName 'No1_S01_16kHz_' num2str(setdB) 'dB.emf'])
%         saveas(gcf,[inputDirName 'No1_S01_16kHz_' num2str(setdB) 'dB_OriginalSpeechOnly.emf'])
    else
        saveas(gcf,[inputDirName 'No1_S01_16kHz_' num2str(setdB) 'dB_' num2str(n,'%02d') '.emf'])
    end
%     keyboard
end



% subplot 311
% plot(AN.norm_dcep, 'k', 'linewidth', 2)
% % spplotlabel(AN.label3, 'msec')
% xlim([1750 2750])
% ylim([0 1.2])
% % set(gca, 'OuterPosition', [0 0.97 1 0.46], 'xticklabel', [])
% title('Normal Speech', 'fontsize', 14)
% set(gca, 'YMinorGrid', 'on', 'fontsize', 16)
% a = ylabel('D_\Delta(t) [dB]', 'fontsize', 18);
% 
% subplot 312
% plot(AC.norm_dcep, 'k', 'linewidth', 2)
% % spplotlabel(AC.label3, 'msec')
% xlim([1750 2750])
% ylim([0 1.2])
% % set(gca, 'OuterPosition', [0 0.53 1 0.46])
% title('Clear Speech', 'fontsize', 14)
% set(gca, 'YMinorGrid', 'on', 'fontsize', 16)
% 
% subplot 313
% plot(AE.norm_dcep, 'k', 'linewidth', 2)
% % spplotlabel(AC.label3, 'msec')
% xlim([1750 2750])
% ylim([0 1.2])
% % set(gca, 'OuterPosition', [0 0.090 1 0.46])
% title('Clear Speech', 'fontsize', 14)
% set(gca, 'YMinorGrid', 'on', 'fontsize', 16)
% 
% 
% 
% 
% 
% set(a, 'Position', [1700 -0.05 0])
% text(2170, -0.55, 0, 'Time [ms]', 'fontsize', 18)



