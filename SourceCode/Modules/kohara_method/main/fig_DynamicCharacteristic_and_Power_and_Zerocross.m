% 通常音声と強調音声の動的特徴とパワーとゼロ交差数を比較するプログラム
clear all

scrsz = get(0,'ScreenSize'); %%ウィンドウサイズを取得

inputDirName = '../voice_data/sample/';
inputDirName2 = '../voice_data/';
inputDirName_mat = '../voice_data/sample/';

% i = 1
for i = 1:5,
    inputName_AN = ['AN' num2str(i,'%02d')];
    inputName_AC = ['AC' num2str(i,'%02d')];


    setdB = 3;
    frame_t = 6; %フレーム長(ミリ秒)
    shift_t = 3; %シフト長（ミリ秒）


    AN = load ([inputDirName 'mat/ATR_16kHz/' inputName_AN]); %%Matデータ読み込み
    AE = load([inputDirName2 'new_BandDivision_tec/ATR_16kHz/500Hz/mat/' inputName_AN '_' num2str(setdB) 'dB_16band_hanning500Hz_empSgram']);
    AC = load([inputDirName 'mat/ATR_16kHz/' inputName_AC]); %%Matデータ読み込み

    [AN.X, AN.fs]= audioread ([inputDirName 'wav/ATR_16kHz/' inputName_AN '.wav']);
    [AC.X, AC.fs]= audioread ([inputDirName 'wav/ATR_16kHz/' inputName_AC '.wav']);

    label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AN '_lab.txt'],'point',1/1000);
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
    AC.cep = getSt2Cep(AC.n3sgram, 45);
    AE.cep = getSt2Cep(AE.emp_sgram, 45);

    AN.dcep = getDeltaCep4(AN.cep, p);
    AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AN.norm_dcep = getDcepNorm(AN.dcep, 0);

    AC.dcep = getDeltaCep4(AC.cep, p);
    AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AC.norm_dcep = getDcepNorm(AC.dcep, 0);

    AE.dcep = getDeltaCep4(AE.cep, p);
    AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AE.norm_dcep = getDcepNorm(AE.dcep, 0);

    %パワースペクトル算出
    AN.power = mean(AN.n3sgram);
    % plot(AN.power);
    AN.power = 10*log10(AN.power.^2);
    % plot(AN.power);
    % keyboard

    %ゼロ交差数を算出
    [X_zerocross, frame_p, shift_p]= getZerocross(AN.X,AN.fs,frame_t,shift_t);
    %%
    xplot_AN_zerocross = (0:length(X_zerocross)-1) .* shift_p ./ (AN.fs/1000);
    %     xplot = linspace(1,X*,length(X_zerocross))
    xplot_AN = (0:length(AN.X)-1) ./ (AN.fs/1000);


    xplot_AN_dcep = (0:length(AN.norm_dcep)-1) / (AN.fs/1000);
    % xplot_AN = (0:length(AN.norm_dcep)-1) / (16000);
    % xplot_AN = linspace(220,1300,length(AN.norm_dcep));
    % xplot_AC = (0:length(AC.norm_dcep)-1) / (24000/1000);
    % xplot_AE = (0:length(AE.norm_dcep)-1) / (24000/1000);

    % keyboard

    % x_lim = [225 1300];

    title_fontsize = 20;
    fontsize = 20;
    ylabel_fontsize = 20;
    x_lim = [label(1).time-50 label(end).time+50];
    % x_lim = [200 4400];
    figure('Name',[''],'NumberTitle','off', 'Position',[0.1 0.1 5*scrsz(3)/5 4*scrsz(4)/5])
    % set(gcf, 'position',  [130 531 650 280])

    % subplot 411
    % plot(xplot_AN,AN.X);
    % title('Speech waveform', 'fontsize', title_fontsize)
    % set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    % ylabel('Amplitude', 'fontsize', ylabel_fontsize);
    % xlim(x_lim)
    % y_lim_max = max([max(AN.X) -1*min(AN.X)])*1.1;
    % ylim([-y_lim_max y_lim_max])
    % spplotlabel(label,'k:',26);

    % subplot 412
    subplot 311
    plot(AN.norm_dcep);
    title('Dynamic characteristic', 'fontsize', title_fontsize)
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlim(x_lim)
    ylabel('D_\Delta(t) [dB]', 'fontsize', ylabel_fontsize);
    spplotlabel(label,'k:',26);

    % subplot 413
    subplot 312
    plot(AN.power);
    title('Time series of power', 'fontsize', title_fontsize)
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlim(x_lim)
    ylim([min(AN.power)-10 max(AN.power)+10]) %最大、最小値を基に、y軸範囲を決定
    ylabel('Power [dB]', 'fontsize', ylabel_fontsize);
    spplotlabel(label,'k:',26);

    % subplot 414
    subplot 313
    plot(xplot_AN_zerocross,X_zerocross);
    title('Time series of zero crossing rate' , 'fontsize', title_fontsize)
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlim(x_lim)
    ylim([1 max(X_zerocross)+5]) 
    ylabel({'Zero crossing';'rate'}, 'fontsize', ylabel_fontsize);
    xlabel('Time [ms]', 'fontsize', fontsize);
    spplotlabel(label,'k:',26);


    outputDirName = '../fig_data/fig_DynamicCharacteristic_and_Power_and_Zerocross/';
    mkdir(outputDirName);
    saveas(gcf,[outputDirName inputName_AN '_DynamicCharacteristic_and_Power_and_Zerocross.emf']); %直前のfigureを保存

    % figure
    % scatter(AN.norm_dcep,AN.power,5,'filled','b');

    if length(X_zerocross)>length(AN.norm_dcep),
            AN.norm_dcep = LinearInt(AN.norm_dcep,X_zerocross);
            AN.power = LinearInt(AN.power,X_zerocross);
    elseif length(X_zerocross)<length(AN.norm_dcep),
            X_zerocross = LinearInt(X_zerocross,AN.norm_dcep);
    end
    figure
    scatter3(AN.norm_dcep,AN.power,X_zerocross,5,'filled','b');
    xlabel('D_\Delta(t) [dB]', 'fontsize', ylabel_fontsize);
    ylabel('Power [dB]', 'fontsize', ylabel_fontsize);
    zlabel('Zero crossing rate', 'fontsize', ylabel_fontsize);
    view(-45,25)
    saveas(gcf,[outputDirName inputName_AN '_scatter_DynamicCharacteristic_and_Power_and_Zerocross.emf']); %直前のfigureを保存
end
% %     setLabel('RMS [dB]', 'Delta Cepstrum', '', 16);
%     hold on 
% %     figure
%     scatter(AC.rms,AC.norm_dcep,sz,'filled','r')
%     setLabel('RMS [dB]', 'Delta Cepstrum', '', 16);
%     legend(AN_name, AC_name)
%     hold off



