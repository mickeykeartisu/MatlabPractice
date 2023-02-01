scrsz = get(0,'ScreenSize');
title_fontsize = 20;
label_fontsize = 20;
legend_fontsize = 20;
fontsize = 20;

%% ゲイン系列算出の周波数応答
if 0,
    fftl = 1024*3;
    % sigma = 40;
    sigma = 44.7340;
    marg = 200;
    x = -marg:1:marg;
    % [sigma_v] = getpeakf2sigma(5, marg, 0.01, 0);

    % sigma_v = [55.49   27.94   14.01];
    sigma_v = [14.01];
    % sigma_v = [45.00];
    % peakf = [4 8 16];
    peakf = [16];
     for l=1:length(sigma_v),
         f_nd = getNormalDistribution(x, sigma_v(l));
         [h, f] = freqz(f_nd, 1, fftl, 1000); % 2nd_diff
         [h_mix, f, h_nd, h_dd] = freqz4log(f_nd, fftl, 1000);

         clf
         plot(f, 20*log10(h_nd), 'color', [0.2 0.2 1], 'linewidth', 2, 'linestyle', '--')
         hold on
         plot(f, 20*log10(h_dd), 'color', [0.2 1 0.2], 'linewidth', 2, 'linestyle', '-.')
         plot(f, 20*log10(h_mix), 'color', [0.7 0 0], 'linewidth', 2.5)
         yth = -100;
    %      axis([0 100 yth 0])
         grid on
         setLabel('Frequency [Hz]', 'Gain [dB]','', label_fontsize)
         set(gca, 'fontsize', fontsize, 'YTick', yth:10:10)
         % legax = legend('G(t)', '2nd-differential', 'd^2G(t)/dt^2', 'Location', 'Best');
         legax = legend('g(t)', '2nd derivative', 'g''''(t)', 'Location', 'Best');
         % set(legax, 'fontsize', 15, 'position', [0.5599 0.4938 0.3321 0.2222])
         set(legax, 'fontsize', legend_fontsize)
         title(['σ = ' num2str(sigma_v(l))], 'fontsize', 14)
         xlim([0 70])
         ylim([-100 10])
    %      
    %      myprint(['FreqzOfLoG_' num2str(round(peakf(l)))], 1)
    end
end

%% 動的特徴の比較
if 1,
    %パラメータの指定
    %強調する変調周波数の値(Hz)
    empha_Hz = 16;
    %ゲインの増幅の倍率の指定(dB)
    setGain = [6];
    %分割数を定義(2帯域に分割するなら2 3帯域なら3....)
    T = 80; 
    %ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
    maxfreq = 500;
    threshold_dB =[9];
    ratio = Inf;
    kneeWidth_dB = 6;
    T_2 = 16;

    inputDirName_wav = '../voice_data/sample/wav/ATR_16kHz/';
    inputDirName_mat = '../voice_data/sample/mat/ATR_16kHz/';
    inputDirName_label = '../voice_data/sample/label/ATR_label/';

    %     inputDirName_AE = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/'];
    inputDirName_AE = ['C:\Users\share\Documents\MATLAB\voice_data\ATR_gainlimit\kneeWidth_dB_06dB\500Hz\6dB\Gainlimit_09dB/'];
    inputDirName_AS = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_50dB_ATR/'];
    outputDirName = '../voice_data/Ddelta_phoneme/';

    n = 1;
    AN_name = ['AN' num2str(n, '%02d')];
    AC_name = ['AC' num2str(n, '%02d')];
    %     AE_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_straight'];
    AE_name = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB'];
    AS_name = ['AN' num2str(n, '%02d') '_PeakHz16_lin_' num2str(setGain) '_empSgram'];


    AN = load ([inputDirName_mat AN_name]); %%Matデータ読み込み
    AC = load ([inputDirName_mat AC_name]); %%Matデータ読み込み
    AE = load ([inputDirName_AE 'mat/' AE_name '_sgram']); %%Matデータ読み込み
    AS = load ([inputDirName_AS 'mat/' AS_name]); %%Matデータ読み込み

    AN.label = sploadlabel([inputDirName_label AN_name '_lab.txt'],'point',1/1000);
    AC.label = sploadlabel([inputDirName_label AC_name '_lab.txt'],'point',1/1000);

    [AN.X,AN.fs] = audioread([inputDirName_wav AN_name '.wav']);
    [AE.X,AE.fs] = audioread([inputDirName_AE AE_name '.wav']);
    
    % inputDirName_wav = '../voice_data/sample/wav/ATR/';
    % 
    % [AN.wav, AN.fs] =  audioread([inputDirName_wav AN_name '.wav']); 
    % 
    % %STRAIGHTスペクトログラムを求める
    % [f0raw, ap] = exstraightsource(AN.wav, AN.fs);
    % [AN.n3sgram] = exstraightspec(AN.wav, f0raw, AN.fs);
    % 
    % [AC.wav, AC.fs] =  audioread([inputDirName_wav AC_name '.wav']); 
    % 
    % %STRAIGHTスペクトログラムを求める
    % [f0raw, ap] = exstraightsource(AC.wav, AC.fs);
    % [AC.n3sgram] = exstraightspec(AC.wav, f0raw, AC.fs);
    % % outputDirName = inputDirName3;
    % % save ([outputDirName num2str(maxfreq(v)) 'Hz/mat/' outputName '_straight'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram');
    % 
    % keyboard
    p.msdceptime = 50;

    AN.cep = getSt2Cep(AN.n3sgram, 45);
    AC.cep = getSt2Cep(AC.n3sgram, 45);
    AE.cep = getSt2Cep(AE.n3sgram_emp, 45);
    AS.cep = getSt2Cep(AS.n3sgram, 45);
    
    keyboard
    AN.dcep = getDeltaCep4(AN.cep, p);
    keyboard
    AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    keyboard
    AN.norm_dcep = getDcepNorm(AN.dcep, 1);

    AC.dcep = getDeltaCep4(AC.cep, p);
    AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AC.norm_dcep = getDcepNorm(AC.dcep, 1);

    AE.dcep = getDeltaCep4(AE.cep, p);
    AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AE.norm_dcep = getDcepNorm(AE.dcep, 1);

    AS.dcep = getDeltaCep4(AE.cep, p);
    AS.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AS.norm_dcep = getDcepNorm(AE.dcep, 1);

    % keyboard
    xplot_AN = (0:length(AN.X)-1) / (AN.fs/1000);
    xplot_AC = (0:length(AC.norm_dcep)-1) / (AC.fs/1000);
    xplot_AE = (0:length(AE.X)-1) / (AE.fs/1000);
    xplot_AS = (0:length(AS.norm_dcep)-1) / (16000/1000);
    
    

    fontsize = 24;
    label_fontsize = 30;
    legend_fontsize = 24;
%     label_ns = 9;
%     label_ne = 24;
    label_ns = 24;
    label_ne = 40;

    % x_lim = [1500 2700];
    if 0, %通常音声・明瞭音声
        label_ns = 24;
        label_ne = 40;
        figure
        subplot 211
        plot(AN.norm_dcep, 'linewidth', 2)
        % spplotlabel(AN.label3, 'msec')
%         xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        % xlim([AN.label(label_ns).time AN.label(length(AN.label)).time])
        % xlim([1500 2700])
        ylim([0 1.2])
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % spplotlabel(AN.label,'k:',20);


        subplot 212
        plot(AC.norm_dcep,  'linewidth', 2)
        % spplotlabel(AC.label3, 'msec')
%         xlim([AC.label(label_ns).time-50 AC.label(label_ne).time+50])
        % xlim([AC.label(label_ns).time AC.label(length(AC.label)).time])
        % xlim([1500 2700])
        ylim([0 1.2])
        title('Clear speech', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % set(gca, 'YMinorGrid', 'on', 'fontsize', fontsize)
        % spplotlabel(AC.label,'k:',20);
    end
    
    if 0, %通常音声・提案手法
        label_ns = 24;
        label_ne = 40;
        y_lim =[0 1.5];
        
        figure
        subplot 211
        plot(AN.norm_dcep, 'linewidth', 2)
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        ylim(y_lim)
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % spplotlabel(AN.label,'k:',20);

        subplot 212
        plot(AE.norm_dcep,  'linewidth', 2)
%         xlim([AE.label(label_ns).time-50 AE.label(label_ne).time+50])
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        ylim(y_lim)
        title('Enhansed speech of proposed method ', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % spplotlabel(AC.label,'k:',20);
    end
    
    if 0, %通常音声・提案手法
        label_ns = 24;
        label_ne = 40;
        y_lim =[0 1.5];
        
        figure
        subplot 211
%         plot(AN.norm_dcep, 'linewidth', 2)
        plot(xplot_AN,AN.X, 'linewidth', 2)
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
%         ylim(y_lim)
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        spplotlabel(AN.label,'k:',20);

        subplot 212
        plot(AN.norm_dcep,  'linewidth', 2)
%         xlim([AE.label(label_ns).time-50 AE.label(label_ne).time+50])
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        ylim(y_lim)
        title('Enhansed speech of proposed method ', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        spplotlabel(AC.label,'k:',20);
    end
    
    if 1, %通常音声・提案手法（修論公聴会用）
        label_ns = 24;
        label_ne = 40;
        y_lim =[0.05 0.65];
        
        x_lim = [200 1500];
        
        fig_size = [0.1 0.1 3*scrsz(3)/5 1*scrsz(4)/2];
        figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
        plot(AN.norm_dcep, 'linewidth', 3)
        hold on
        plot(AE.norm_dcep,'r' , 'linewidth', 4)
        hold off 
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        ylim(y_lim)
        xlim(x_lim)
        spplotlabel(AN.label,'k:',26);

        figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
        plot(AN.norm_dcep, 'linewidth', 3)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        ylim(y_lim)
        xlim(x_lim)
        spplotlabel(AN.label,'k:',26);        

    end
end

%% 動的特徴の比較(4モーラ)
if 0,
    %パラメータの指定
    %強調する変調周波数の値(Hz)
    empha_Hz = 16;
    %ゲインの増幅の倍率の指定(dB)
    setGain = [6];
    %分割数を定義(2帯域に分割するなら2 3帯域なら3....)
    T = 16; 
    %ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
    maxfreq = 500;
    threshold_dB =[9];
    ratio = Inf;
    kneeWidth_dB = 6;
    T_2 = 16;

    inputDirName_wav = '../voice_data/sample/wav/shinmitsu_16kHz_cut/';
    inputDirName_mat = '../voice_data/sample/mat/shinmitsu_16kHz_cut/';
    inputDirName_label = '../voice_data/sample/label/ATR_label/';

    %     inputDirName_AE = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/'];
    inputDirName_AE = ['C:\Users\share\Documents\MATLAB\voice_data\shinmitsu_test_gainlimit\shinmitsu_shibata\kneeWidth_dB_06dB\500Hz\6dB\Gainlimit_09dB/'];
    inputDirName_AS = ['C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shibata_sample\shinmitsu_16kHz_50dB_ATR/'];
    outputDirName = '../voice_data/Ddelta_phoneme/';

    n = 2;
    AN_name = ['YSB_' num2str(n, '%04d')];
%     AC_name = ['AC' num2str(n, '%02d')];
    %     AE_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_straight'];
    AE_name = ['YSB_' num2str(n, '%04d') '_' num2str(setGain) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_Gainlimit' num2str(threshold_dB) 'dB'];
%     AS_name = ['AN' num2str(n, '%02d') '_PeakHz16_lin_' num2str(setGain) '_empSgram'];


    AN = load ([inputDirName_mat AN_name]); %%Matデータ読み込み
%     AC = load ([inputDirName_mat AC_name]); %%Matデータ読み込み
    AE = load ([inputDirName_AE 'mat/' AE_name '_sgram']); %%Matデータ読み込み
%     AS = load ([inputDirName_AS 'mat/' AS_name]); %%Matデータ読み込み

%     AN.label = sploadlabel([inputDirName_label AN_name '_lab.txt'],'point',1/1000);
%     AC.label = sploadlabel([inputDirName_label AC_name '_lab.txt'],'point',1/1000);

    [AN.X,AN.fs] = audioread([inputDirName_wav AN_name '.wav']);
    [AE.X,AE.fs] = audioread([inputDirName_AE AE_name '.wav']);
    
    % inputDirName_wav = '../voice_data/sample/wav/ATR/';
    % 
    % [AN.wav, AN.fs] =  audioread([inputDirName_wav AN_name '.wav']); 
    % 
    % %STRAIGHTスペクトログラムを求める
    % [f0raw, ap] = exstraightsource(AN.wav, AN.fs);
    % [AN.n3sgram] = exstraightspec(AN.wav, f0raw, AN.fs);
    % 
    % [AC.wav, AC.fs] =  audioread([inputDirName_wav AC_name '.wav']); 
    % 
    % %STRAIGHTスペクトログラムを求める
    % [f0raw, ap] = exstraightsource(AC.wav, AC.fs);
    % [AC.n3sgram] = exstraightspec(AC.wav, f0raw, AC.fs);
    % % outputDirName = inputDirName3;
    % % save ([outputDirName num2str(maxfreq(v)) 'Hz/mat/' outputName '_straight'], 'ReX', 'fs', 'f0raw', 'ap','n3sgram');
    % 
    % keyboard
    p.msdceptime = 50;
    lifter = round(4 * AN.fs /1000);
    AN.cep = getSt2Cep(AN.n3sgram, lifter);
%     AC.cep = getSt2Cep(AC.n3sgram, 45);
%     AE.cep = getSt2Cep(AE.n3sgram_emp, 45);
    AE.cep = getSt2Cep(AE.n3sgram, lifter);
%     AS.cep = getSt2Cep(AS.n3sgram, 45);

    AN.dcep = getDeltaCep4(AN.cep, p);
    AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AN.norm_dcep = getDcepNorm(AN.dcep, 1);

%     AC.dcep = getDeltaCep4(AC.cep, p);
%     AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
%     AC.norm_dcep = getDcepNorm(AC.dcep, 0);

    AE.dcep = getDeltaCep4(AE.cep, p);
    AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
    AE.norm_dcep = getDcepNorm(AE.dcep, 1);

%     AS.dcep = getDeltaCep4(AE.cep, p);
%     AS.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
%     AS.norm_dcep = getDcepNorm(AE.dcep, 0);

    % keyboard
    xplot_AN = (0:length(AN.X)-1) / (AN.fs/1000);
%     xplot_AC = (0:length(AC.norm_dcep)-1) / (AC.fs/1000);
    xplot_AE = (0:length(AE.X)-1) / (AE.fs/1000);
%     xplot_AS = (0:length(AS.norm_dcep)-1) / (16000/1000);
    
    

    fontsize = 20;
    label_fontsize = 20;
    legend_fontsize = 24;
%     label_ns = 9;
%     label_ne = 24;
    label_ns = 24;
    label_ne = 40;

    % x_lim = [1500 2700];
    if 0, %通常音声・明瞭音声
        label_ns = 24;
        label_ne = 40;
        figure
        subplot 211
        plot(AN.norm_dcep, 'linewidth', 2)
        % spplotlabel(AN.label3, 'msec')
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        % xlim([AN.label(label_ns).time AN.label(length(AN.label)).time])
        % xlim([1500 2700])
        ylim([0 1.2])
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % spplotlabel(AN.label,'k:',20);


        subplot 212
        plot(AC.norm_dcep,  'linewidth', 2)
        % spplotlabel(AC.label3, 'msec')
        xlim([AC.label(label_ns).time-50 AC.label(label_ne).time+50])
        % xlim([AC.label(label_ns).time AC.label(length(AC.label)).time])
        % xlim([1500 2700])
        ylim([0 1.2])
        title('Clear speech', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % set(gca, 'YMinorGrid', 'on', 'fontsize', fontsize)
        % spplotlabel(AC.label,'k:',20);
    end
    
    if 0, %通常音声・提案手法
        label_ns = 24;
        label_ne = 40;
        y_lim =[0 1.5];
        
        figure
        subplot 211
        plot(AN.norm_dcep, 'linewidth', 2)
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        ylim(y_lim)
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % spplotlabel(AN.label,'k:',20);

        subplot 212
        plot(AE.norm_dcep,  'linewidth', 2)
%         xlim([AE.label(label_ns).time-50 AE.label(label_ne).time+50])
        xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        ylim(y_lim)
        title('Enhansed speech of proposed method ', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
        % spplotlabel(AC.label,'k:',20);
    end
    
    if 1, %通常音声(波形・動的特徴)
        label_ns = 24;
        label_ne = 40;
        y_lim =[0 0.5];
        x_lim = [25 725];
        
        
        figure
        subplot 211
%         plot(AN.norm_dcep, 'linewidth', 2)
        plot(xplot_AN,AN.X, 'linewidth', 2)
        xlim(x_lim)
        ylim([-0.2 0.2])
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
%         spplotlabel(AN.label,'k:',20);

        subplot 212
        plot(AN.norm_dcep,  'linewidth', 2)
%         xlim([AE.label(label_ns).time-50 AE.label(label_ne).time+50])
%         xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        xlim(x_lim)
        ylim(y_lim)
        title('Enhansed speech of proposed method ', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
%         spplotlabel(AC.label,'k:',20);
    end
    if 1, %提案手法（波形・動的特徴）
        label_ns = 24;
        label_ne = 40;
        y_lim =[0 0.5];
        x_lim = [25 725];
        
        
        figure
        subplot 211
%         plot(AN.norm_dcep, 'linewidth', 2)
        plot(xplot_AE,AE.X, 'linewidth', 2)
        xlim(x_lim)
        ylim([-0.2 0.2])
        title('Normal speech', 'fontsize', label_fontsize)
        set( gca, 'YMinorGrid', 'on','FontName','MS UI Gothic','FontSize',fontsize);
        % xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
%         spplotlabel(AN.label,'k:',20);

        subplot 212
        plot(AE.norm_dcep,  'linewidth', 2)
%         xlim([AE.label(label_ns).time-50 AE.label(label_ne).time+50])
%         xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
        xlim(x_lim)
        ylim(y_lim)
        title('Enhansed speech of proposed method ', 'fontsize', label_fontsize)
        set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
        xlabel('Time [ms]', 'fontsize', label_fontsize)
        ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
%         spplotlabel(AC.label,'k:',20);
    end
end

%% 波形の比較
if 0,
    setDB = 30; %目標の音圧レベル
    %%パラメータの指定
    %強調する変調周波数の値(Hz)
    empha_Hz = 16;
    %ゲインの増幅の倍率の指定(dB)
    setGain = [6];
    %フィルタ長(ミリ秒)を指定
    f_t = 6;
    %分割数を定義(2帯域に分割するなら2 3帯域なら3....)
    T = [16]; 
    %ハニング窓を何Hzまでかけるか（最大値はナイキスト周波数）
    maxfreq = [500];

    %%ゲインリミット用
    threshold_dB =[9];
    ratio = Inf;
    kneeWidth_dB = 6;

    n = 30;
    inputDirName = '../voice_data/';
    AN.inputName = ['YSB_' num2str(n, '%04d')];
    AE.inputName = ['YSB_' num2str(n, '%04d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_Gainlimit' num2str(threshold_dB) 'dB'];

    [AN.X,AN.fs] = audioread([inputDirName 'sample/wav/shinmitsu_16kHz_cut/' AN.inputName '.wav']);
    [AE.X,AE.fs] = audioread([inputDirName 'shinmitsu_test_gainlimit\shinmitsu_shibata\kneeWidth_dB_06dB\500Hz\6dB\Gainlimit_09dB\' AE.inputName '.wav']);
    AN.xplot = (0:length(AN.X)-1) / (AN.fs/1000);
    AE.xplot = (0:length(AE.X)-1) / (AE.fs/1000);
    fontsize = 20;
    label_fontsize = 20;

    x_lim = [10 700];
    y_lim = [-0.2 0.2];
    
    fig_size = [0.1 0.1 2*scrsz(3)/5 1*scrsz(4)/2];
    figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
    subplot 211
    plot(AN.xplot,AN.X ,'linewidth', 1.4);
    ylabel('Amplitude', 'fontsize', label_fontsize)
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlim(x_lim)
    ylim(y_lim)

    subplot 212
    plot(AE.xplot,AE.X ,'linewidth', 1.4);
    xlabel('Time [ms]', 'fontsize', label_fontsize)
    ylabel('Amplitude', 'fontsize', label_fontsize)
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlim(x_lim)
    ylim(y_lim)
end

%% ソフトリミットの例
if 0,
    
    threshold_dB = 9;
    ratio = Inf;
    kneeWidth_dB = 6;

    if 1
        threshold_dB = 9;
        ratio = Inf;
        kneeWidth_dB = 6;
        
        x_dB = 0:0.01:12;
        x = 10 .^ (x_dB / 20);
        y_dB = x_dB;
        
        figure
        plot(x_dB, y_dB, 'k','linewidth', 1);
        hold on
        
        [y, gain, y_dB] = softlimit(x, threshold_dB, ratio, kneeWidth_dB);
        plot(x_dB, y_dB, 'r:','linewidth', 3);
        
        kneeWidth_dB = 0;
        [y, gain, y_dB] = softlimit(x, threshold_dB, ratio, kneeWidth_dB);
        plot(x_dB, y_dB, 'b--','linewidth', 2);

        hold off
        set( gca, 'YTick', 0:1:12);
        set( gca, 'YTicklabel', 0:1:12);
        set( gca, 'XTick', 0:1:12);
        set( gca, 'XTicklabel', 0:1:12);
%         ylabel('\fontname{Cambria}\sly_G \fontname{MS UI Gothic}\rm[dB]', 'fontsize', label_fontsize)
%         xlabel('\fontname{Cambria}\slx_G \fontname{MS UI Gothic}\rm[dB]', 'fontsize', label_fontsize)
        
%         y = latex '\tilde{g_d_B}';
        
        ylabel('$$\tilde{g}_{\rm dB}$$ {\rm \sf [dB]}', 'fontsize', label_fontsize, 'Interpreter', 'Latex')
        xlabel('$$g_{\rm dB}$$ {\rm \sf [dB]}', 'fontsize', label_fontsize, 'Interpreter', 'Latex')
        set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
        legax = legend('No compression', 'W(Knee width) = 6 dB', 'W(Knee width) = 0 dB');
        set(legax, 'fontsize', legend_fontsize)
    else
        x = 0:0.001:4;
        y = 4 * sin(2 * pi * x);
        [y2, gain, y_dB]= softlimit(y, threshold_dB, ratio, kneeWidth_dB);
        
        x_lim = [0 2];
        
        label_fontsize = 18;
        
        figure
        plot(x, y ,'linewidth', 2);
        ylabel('Magnification', 'fontsize', label_fontsize)
        xlabel('Time', 'fontsize', label_fontsize)
        set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
        set( gca, 'XTick', []);
        xlim(x_lim)
%         ylim([-0.1 0.1])
        
        figure
        plot(x, y,'b--', x, y2, 'r','linewidth', 2);
        xlabel('Time', 'fontsize', label_fontsize)
        ylabel('Magnification', 'fontsize', label_fontsize)
        set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
        set( gca, 'XTick', []);
        xlim(x_lim)
%         ylim([-0.1 0.1])

    end
end