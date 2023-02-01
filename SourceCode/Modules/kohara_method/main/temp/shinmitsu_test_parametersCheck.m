%親密音声の強調音声のRMS値を求める
% inputName = 'YSB';
% inputName = 'sample Normal2';

Hz = 3000;
gain = 6;

inputDirName1 = '../voice_data/sample/';
inputDirName2 = ['../voice_data/shinmitsu_test/' ];
inputDirName3 = ['../voice_data/shinmitsu_test/normalization/'];
% outputDirName = '../fig_data/new_BandDivision_tec/figplot_5/';

% label = sploadlabel([inputDirName1 'label/' inputName '_label.txt'],'point',1/1000);
% label2 = sploadlabel([inputDirName1 'label/' inputName '_label.txt'],'point',1);

% if strcmp(inputName,'sample Normal'),
%     % x_lim{1} = [0.2 2.3]; %sample Normal前半
%     % x_lim{2} = [2.59 4.4]; %sample Normal後半
% %     x_lim = [2.59 4.35]; %sample Normal前半
%     x_lim = [200 4400]
% end
% if strcmp(inputName,'sample Normal2'),
%     % x_lim{1} = [0.2 1.77]; %sample Normal2前半
%     % x_lim{2} = [1.77 2.9]; %sample Normal2後半
%     x_lim = [200 2900];
% end
y_lim = [-0.15 0.15];

s_num = 1;
e_num = 3;

for n = s_num:e_num,

    inputName = ['YSB_' num2str(n, '%04d')];
    [X,fs] = audioread([inputDirName1 'wav/shinmitsu_16kHz/' inputName '.wav']);
    X_n = audioread([inputDirName3 'original_normalization/' inputName '_normalization.wav']);
    ReX = audioread([inputDirName2 num2str(Hz) 'Hz/' inputName '_' num2str(gain) 'dB_16band_hanning' num2str(Hz) 'Hz.wav']);
    ReX_n= audioread([inputDirName3 num2str(Hz) 'Hz/' inputName '_' num2str(gain) 'dB_16band_hanning' num2str(Hz) 'Hz_normalization.wav']);

    % X_spe = fft(X,1024);
    % X_spe = abs(X_spe);
    % 
    % ReX_spe = fft(ReX,1024);
    % ReX_spe = abs(ReX_spe);
    % 
    % ReX2_spe = fft(ReX2,1024);
    % ReX2_spe = abs(ReX2_spe);

    %%
    %RMSを確認する
    Frame = 16*20; %サンプリング周波数16kHzの時のフレーム長20ms%
    Shift = 16*1; %サンプリング周波数16kHzの時のフレームシフト1m%
    point = 1;
    fftpoint = 256;
    R = floor((length(ReX')-Frame)/Shift); %入力音声の長さをシフト長で割り、格納するベクトルの長さを求める
    X_Syn = zeros(1, R);
    xplot_2 = (0:length(X_Syn)-1) ./ (length(X_Syn)/length(ReX))./fs .*1000;
    for jj = 1:1:R,
        B = X';
        x = B(point:point+(Frame-1));
        rmsV = getRms(x,fftpoint,Frame);

        X_Syn(jj) = rmsV;
        point = point+Shift;
    end

    X_n_Syn = zeros(1, R);
    point = 1;
    for jj = 1:1:R,
        B = X_n';
        x = B(point:point+(Frame-1));
        rmsV = getRms(x,fftpoint,Frame);

        X_n_Syn(jj) = rmsV;
        point = point+Shift;
    end

    ReX_Syn = zeros(1, R);
    point = 1;
    for jj = 1:1:R,
        B = ReX';
        x = B(point:point+(Frame-1));
        rmsV = getRms(x,fftpoint,Frame);

        ReX_Syn(jj) = rmsV;
        point = point+Shift;
    end

    ReX_n_Syn = zeros(1, R);
    point = 1;
    for jj = 1:1:R,
        B = ReX_n';
        x = B(point:point+(Frame-1));
        rmsV = getRms(x,fftpoint,Frame);

        ReX_n_Syn(jj) = rmsV;
        point = point+Shift;
    end

    % figure
    % plot(xplot_2,20*log10(Syn),'r', xplot_2,20*log10(Syn2),'b:',xplot_2,20*log10(Syn3),'k--',xplot_2,20*log10(Syn4),'g');
    % setLabel('Time[ms]', 'amplitude[dB]', '', 16);
    % set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
    % title('hanning')
    % legend('強調音声', '強調音声正規化', '原音声正規化')

    figure
    plot(xplot_2,20*log10(X_Syn),'r',xplot_2,20*log10(ReX_Syn),'b--');
    % xlim(x_lim)
    setLabel('Time [ms]', 'Amplitude [dB]', '', 16);
    set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
    title(['YSB' num2str(n, '%04d') ' normal'])
    legend('原音声', '強調音声')

    figure
    plot(xplot_2,20*log10(X_n_Syn),'r',xplot_2,20*log10(ReX_n_Syn),'b--');
    % xlim(x_lim)
    setLabel('Time[ms]', 'amplitude[dB]', '', 16);
    set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
    title(['YSB' num2str(n, '%04d') ' normalization'])
    legend('原音声(正規化)', '強調音声(正規化)')



    % 
    % 
    % X_rms = mean(20*log10(X_Syn))
    % ReX_rms = mean(20*log10(ReX_Syn))
    % 
    % X_n_rms = mean(20*log10(X_n_Syn))
    % ReX_n_rms = mean(20*log10(ReX_n_Syn))


    %%
    %音圧レベルを調べる
    X_spl = getsplcompensation(X,fs,30)
    ReX_spl = getsplcompensation(ReX,fs,30)
    X_n_spl = getsplcompensation(X_n,fs,30)
    ReX_n_spl = getsplcompensation(ReX_n,fs,30)
    % X_spl = mean(getsplsig(X, fs, 0, 'fast', 'A'))
    % ReX_spl = mean(getsplsig(ReX, fs, 0, 'fast', 'A'))

    % X_n_spl = mean(getsplsig(X_n, fs, 0, 'fast', 'A'))
    % ReX_n_spl = mean(getsplsig(ReX_n, fs, 0, 'fast', 'A'))
    % 
    % X_spl = mean(10*log10(X))
    % ReX_spl = mean(10*log10(ReX))
    % 
    % X_n_spl = mean(10*log10(X_n))
    % ReX_n_spl = mean(10*log10(ReX_n))
end
