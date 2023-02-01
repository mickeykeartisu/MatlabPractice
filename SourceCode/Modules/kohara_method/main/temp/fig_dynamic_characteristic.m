% 通常音声と強調音声の動的特徴を比較するプログラム
clear all

% inputDirName = '../voice_data/sample/';
% inputDirName_mat = '../voice_data/sample/';
% 
% inputName = 'sample Normal';
% inputName2 = 'sample Clear';
% 
% AC = load([inputDirName 'mat/' inputName2]); %%Matデータ読み込み
% AE = load([inputDirName 'mat/enhanced_speech/' inputName '_16Hz_6dB_16band_taper_hanning3000Hz_straight']);
% AN = load ([inputDirName 'mat/' inputName]); %%Matデータ読み込み


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

%%パラメータの指定
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

n = 46;
AN_name = ['AN' num2str(n, '%02d')];
AC_name = ['AC' num2str(n, '%02d')];
%     AE_name{n} = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz_straight'];
AE_name = ['AN' num2str(n, '%02d') '_' num2str(setGain) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB_sgram'];
AS_name = ['AN' num2str(n, '%02d') '_PeakHz16_lin_' num2str(setGain) '_empSgram'];


AN = load ([inputDirName_mat AN_name]); %%Matデータ読み込み
AC = load ([inputDirName_mat AC_name]); %%Matデータ読み込み
AE = load ([inputDirName_AE 'mat/' AE_name]); %%Matデータ読み込み
AS = load ([inputDirName_AS 'mat/' AS_name]); %%Matデータ読み込み

AN.label = sploadlabel([inputDirName_label AN_name '_lab.txt'],'point',1/1000);
AC.label = sploadlabel([inputDirName_label AC_name '_lab.txt'],'point',1/1000);

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

%%
p.msdceptime = 50;

AN.cep = getSt2Cep(AN.n3sgram, 45);
AC.cep = getSt2Cep(AC.n3sgram, 45);
AE.cep = getSt2Cep(AE.n3sgram_emp, 45);
AS.cep = getSt2Cep(AS.n3sgram, 45);

AN.dcep = getDeltaCep4(AN.cep, p);
AN.dcep = trunc2(AN.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
AN.norm_dcep = getDcepNorm(AN.dcep, 0);

AC.dcep = getDeltaCep4(AC.cep, p);
AC.dcep = trunc2(AC.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
AC.norm_dcep = getDcepNorm(AC.dcep, 0);

AE.dcep = getDeltaCep4(AE.cep, p);
AE.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
AE.norm_dcep = getDcepNorm(AE.dcep, 0);

AS.dcep = getDeltaCep4(AE.cep, p);
AS.dcep = trunc2(AE.dcep, round(p.msdceptime/2), 2, 'both', 1, nan);
AS.norm_dcep = getDcepNorm(AE.dcep, 0);


% keyboard
%%
xplot_AN = (0:length(AN.norm_dcep)-1) / (AN.fs/1000);
xplot_AC = (0:length(AC.norm_dcep)-1) / (AC.fs/1000);
xplot_AE = (0:length(AE.norm_dcep)-1) / (16000/1000);
xplot_AS = (0:length(AS.norm_dcep)-1) / (16000/1000);

figure
fontsize = 20;
label_fontsize = 20;
legend_fontsize = 24;
label_ns = 9;
label_ne = 24;

label_ns = 24;
label_ne = 40;



% x_lim = [1500 2700];
subplot 211
plot(AN.norm_dcep, 'linewidth', 2)
% spplotlabel(AN.label3, 'msec')
xlim([AN.label(label_ns).time-90 AN.label(label_ne).time])
% xlim([AN.label(label_ns).time AN.label(length(AN.label)).time])
% xlim([1500 2700])
ylim([0 1.2])
% set(gca, 'OuterPosition', [0 0.97 1 0.46], 'xticklabel', [])
title('Normal Speech', 'fontsize', label_fontsize)
% set(gca, 'YMinorGrid', 'on', 'fontsize', fontsize)
% a = ylabel('D_\Delta(t) [dB]', 'fontsize', 18);
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
% set(gca, 'OuterPosition', [0 0.53 1 0.46])
title('Clear Speech', 'fontsize', label_fontsize)
set( gca,'YMinorGrid', 'on', 'FontName','MS UI Gothic','FontSize',fontsize);
xlabel('Time [ms]', 'fontsize', label_fontsize)
ylabel('D_\Delta(t) [dB]', 'fontsize', label_fontsize)
% set(gca, 'YMinorGrid', 'on', 'fontsize', fontsize)
% spplotlabel(AC.label,'k:',20);

% set(gcf, 'position',  [130 531 650 280])

% plot(AN.norm_dcep, 'k', 'linewidth', 2, 'linewidth', 2)
% 
% hold on
% plot(AC.norm_dcep, 'b--', 'linewidth', 2)
% % plot(AE.norm_dcep, 'r:', 'linewidth', 2)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% set( gca, 'XTick', 0:100:length(AN.norm_dcep));
% set( gca, 'XTicklabel', 0:0.1:length(AN.norm_dcep)/1000);
% xlim([500 1300])
% ylim([0 1.5])
% a = ylabel('D_\Delta(t) [dB]', 'fontsize', 18);
% xlabel('Time [s]', 'fontsize', 18);
% % set(gca, 'OuterPosition', [0 0.53 1 0.46])
% L = legend('Normal Speech','Clear Speech','Enhanced Speech');
% set( L, 'FontSize',14);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% spplotlabel(label,'k:',14);
% hold off
% 
% myprint('Dcepnorm', 1)

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



