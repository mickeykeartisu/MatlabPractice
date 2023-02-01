%帯域分割数の違いによる波形・スペクトログラムの比較(新QMF・テーパー窓ver)
% clear all;

gain = [3];

inputName = 'sample Normal';
% inputName = 'sample Normal2';
inputName = 'AN02';

inputDirName1 = '../voice_data/sample/';
inputDirName2 = ['../voice_data/BandDivision_tec/16Hz/'];
inputDirName2 = ['../voice_data/new_BandDivision_tec/16Hz/'];
outputDirName = '../fig_data/new_BandDivision_tec/figplot_5/';

%%
%2017年秋季音響学会用
inputDirName1 = '../voice_data/sample/';
% inputDirName2 = ['../voice_data/new_BandDivision_tec/use_hanning/'];
inputDirName2 = ['../voice_data/new_BandDivision_tec/ATR_16kHz/'];
outputDirName = '../fig_data/new_BandDivision_tec/figplot_5/';

% label = sploadlabel([inputDirName1 'label/' inputName '_label.txt'],'point',1/1000);
label2 = sploadlabel([inputDirName1 'label/ATR_label/' inputName '_lab.txt'],'point',1);

gain = 3;

% [X,fs] = audioread([inputDirName1 'wav/' inputName '.wav']);
[X,fs] = audioread([inputDirName1 'wav/ATR_16kHz/' inputName '.wav']);
ReX= audioread([inputDirName2 '500Hz/' inputName '_' num2str(gain) 'dB_16band_hanning500Hz.wav']);
% ReX= audioread([inputDirName2 num2str(gain) 'dB/' inputName '_16Hz_' num2str(gain) 'dB_16band_over1000Hz_taper.wav']);
% ReX2 = audioread([inputDirName2 num2str(gain) 'dB/' inputName '_16Hz_' num2str(gain) 'dB_16band_taper_trans.wav']);
% ReX3= audioread([inputDirName2 num2str(gain) 'dB/' inputName '_16Hz_' num2str(gain) 'dB_16band_over0Hz_taper.wav']);

if strcmp(inputName,'AN01'),
    % x_lim{1} = [0.2 2.3]; %sample Normal前半
    % x_lim{2} = [2.59 4.4]; %sample Normal後半
    x_lim = [2.59 4.35]; %sample Normal前半
    x_lim = [0.2 4.35]; %sample Normal前半
end
if strcmp(inputName,'AN02'),
    % x_lim{1} = [0.2 1.77]; %sample Normal2前半
    % x_lim{2} = [1.77 2.9]; %sample Normal2後半
    x_lim = [0.2 2.7];
    x_lim = [0.2 2.7]; %sample Normal前半
end
if strcmp(inputName,'AN03'),
    % x_lim{1} = [0.2 1.77]; %sample Normal2前半
    % x_lim{2} = [1.77 2.9]; %sample Normal2後半
    x_lim = [0.2 2.9];
    x_lim = [0.2 2.9]; %sample Normal前半
end

y_lim = [-0.15 0.15];



xplot_1 = (0:length(X)-1) ./ (fs/1000);

figure
subplot(4,1,1)
plot(xplot_1./1000,X);
xlim(x_lim);
ylim(y_lim)
ylabel('Amplitude','FontSize',12)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
spplotlabel(label2,'k:',12);

subplot(4,1,2)
plot(xplot_1./1000,ReX);
xlim(x_lim);
ylim(y_lim)
ylabel('Amplitude','FontSize',12)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
spplotlabel(label2,'k:',12);

subplot(4,1,3)
spectrogram(X,hamming(128),96,256,fs,'yaxis')
xlim(x_lim) ;
setLabel('',{'Frequency [kHz]';' '},'',12)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
set( gca, 'YTick', 0:2000:8000);
set( gca, 'YTicklabel', 0:2:8);

subplot(4,1,4)
spectrogram(ReX,hamming(128),96,256,fs,'yaxis')
xlim(x_lim) ;
setLabel('Time [s]',{'Frequency [kHz]';' '},'',12);
xlabel('Time [s]','FontSize',14)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
set( gca, 'YTick', 0:2000:8000);
set( gca, 'YTicklabel', 0:2:8);

% figure
% subplot(4,1,1)
% plot(xplot_1./1000,X);
% xlim(x_lim);
% ylim(y_lim)
% ylabel('Amplitude','FontSize',12)
% title('trans')
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% spplotlabel(label2,'k:',12);
% 
% subplot(4,1,2)
% spectrogram(X,hamming(128),96,256,fs,'yaxis')
% xlim(x_lim) ;
% setLabel('',{'Frequency [kHz]';' '},'',12)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% set( gca, 'YTick', 0:2000:8000);
% set( gca, 'YTicklabel', 0:2:8);
% 
% subplot(4,1,3)
% plot(xplot_1./1000,ReX2);
% xlim(x_lim);
% ylim(y_lim)
% ylabel('Amplitude','FontSize',12)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% spplotlabel(label2,'k:',12);
% 
% % spectrogram(ReX3,hamming(128),96,256,fs,'yaxis')
% % xlim(x_lim) ;
% % setLabel('',{'Frequency [kHz]';' '},'',12)
% % set( gca, 'FontName','MS UI Gothic','FontSize',12);
% % set( gca, 'YTick', 0:2000:8000);
% % set( gca, 'YTicklabel', 0:2:8);
% 
% 
% subplot(4,1,4)
% spectrogram(ReX2,hamming(128),96,256,fs,'yaxis')
% xlim(x_lim) ;
% setLabel('Time [s]',{'Frequency [kHz]';' '},'',12)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% set( gca, 'YTick', 0:2000:8000);
% set( gca, 'YTicklabel', 0:2:8);



keyboard

%%
%2017年春季音響学会用
inputDirName1 = '../voice_data/sample/';
% inputDirName2 = ['../voice_data/new_BandDivision_tec/use_hanning/'];
inputDirName2 = ['../voice_data/new_BandDivision_tec/ATR_16kHz/'];
outputDirName = '../fig_data/new_BandDivision_tec/figplot_5/';

% label = sploadlabel([inputDirName1 'label/' inputName '_label.txt'],'point',1/1000);
label2 = sploadlabel([inputDirName1 'label/ATR_label/' inputName '_lab.txt'],'point',1);

gain = 6;

% [X,fs] = audioread([inputDirName1 'wav/' inputName '.wav']);
[X,fs] = audioread([inputDirName1 'wav/ATR_16kHz/' inputName '.wav']);
ReX= audioread([inputDirName2 '3000Hz/' inputName '_' num2str(gain) 'dB_16band_hanning3000Hz.wav']);
% ReX= audioread([inputDirName2 num2str(gain) 'dB/' inputName '_16Hz_' num2str(gain) 'dB_16band_over1000Hz_taper.wav']);
% ReX2 = audioread([inputDirName2 num2str(gain) 'dB/' inputName '_16Hz_' num2str(gain) 'dB_16band_taper_trans.wav']);
% ReX3= audioread([inputDirName2 num2str(gain) 'dB/' inputName '_16Hz_' num2str(gain) 'dB_16band_over0Hz_taper.wav']);

if strcmp(inputName,'AN01'),
    % x_lim{1} = [0.2 2.3]; %sample Normal前半
    % x_lim{2} = [2.59 4.4]; %sample Normal後半
    x_lim = [2.59 4.35]; %sample Normal前半
    x_lim = [0.2 4.35]; %sample Normal前半
end
if strcmp(inputName,'AN02'),
    % x_lim{1} = [0.2 1.77]; %sample Normal2前半
    % x_lim{2} = [1.77 2.9]; %sample Normal2後半
    x_lim = [0.2 2.9];
    x_lim = [0.2 2.9]; %sample Normal前半
end
y_lim = [-0.15 0.15];



xplot_1 = (0:length(X)-1) ./ (fs/1000);

figure
subplot(4,1,1)
plot(xplot_1./1000,X);
xlim(x_lim);
ylim(y_lim)
ylabel('Amplitude','FontSize',12)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
spplotlabel(label2,'k:',12);

subplot(4,1,2)
plot(xplot_1./1000,ReX);
xlim(x_lim);
ylim(y_lim)
ylabel('Amplitude','FontSize',12)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
spplotlabel(label2,'k:',12);

subplot(4,1,3)
spectrogram(X,hamming(128),96,256,fs,'yaxis')
xlim(x_lim) ;
setLabel('',{'Frequency [kHz]';' '},'',12)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
set( gca, 'YTick', 0:2000:8000);
set( gca, 'YTicklabel', 0:2:8);

subplot(4,1,4)
spectrogram(ReX,hamming(128),96,256,fs,'yaxis')
xlim(x_lim) ;
setLabel('Time [s]',{'Frequency [kHz]';' '},'',12);
xlabel('Time [s]','FontSize',14)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
set( gca, 'YTick', 0:2000:8000);
set( gca, 'YTicklabel', 0:2:8);

% figure
% subplot(4,1,1)
% plot(xplot_1./1000,X);
% xlim(x_lim);
% ylim(y_lim)
% ylabel('Amplitude','FontSize',12)
% title('trans')
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% spplotlabel(label2,'k:',12);
% 
% subplot(4,1,2)
% spectrogram(X,hamming(128),96,256,fs,'yaxis')
% xlim(x_lim) ;
% setLabel('',{'Frequency [kHz]';' '},'',12)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% set( gca, 'YTick', 0:2000:8000);
% set( gca, 'YTicklabel', 0:2:8);
% 
% subplot(4,1,3)
% plot(xplot_1./1000,ReX2);
% xlim(x_lim);
% ylim(y_lim)
% ylabel('Amplitude','FontSize',12)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% spplotlabel(label2,'k:',12);
% 
% % spectrogram(ReX3,hamming(128),96,256,fs,'yaxis')
% % xlim(x_lim) ;
% % setLabel('',{'Frequency [kHz]';' '},'',12)
% % set( gca, 'FontName','MS UI Gothic','FontSize',12);
% % set( gca, 'YTick', 0:2000:8000);
% % set( gca, 'YTicklabel', 0:2:8);
% 
% 
% subplot(4,1,4)
% spectrogram(ReX2,hamming(128),96,256,fs,'yaxis')
% xlim(x_lim) ;
% setLabel('Time [s]',{'Frequency [kHz]';' '},'',12)
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% set( gca, 'YTick', 0:2000:8000);
% set( gca, 'YTicklabel', 0:2:8);



keyboard

%%
% taitoruyou
% P{1} = 'first';
% P{2} = 'second';

B = [8 16];
% B = [4]
cutHz = 1000;

NameEnd = ['over' num2str(cutHz) 'Hz'];
% NameEnd = 'change'

[X,fs] = audioread([inputDirName1 'wav/' inputName '.wav']);

ReX = cell(length(B),length(gain));
for b = 1:length(B),
    for g = 1:length(gain),
        ReX{b,g} = audioread([inputDirName2 num2str(gain(g)) 'dB/' inputName '_16Hz_' num2str(gain(g)) 'dB_' num2str(B(b)) 'band_' NameEnd '_taper.wav']);
    end
end

label = sploadlabel([inputDirName1 'label/' inputName '_label.txt'],'point',1/1000);
label2 = sploadlabel([inputDirName1 'label/' inputName '_label.txt'],'point',1);

xplot_1 = (0:length(X)-1) ./ (fs/1000);

if strcmp(inputName,'sample Normal'),
    % x_lim{1} = [0.2 2.3]; %sample Normal前半
    % x_lim{2} = [2.59 4.4]; %sample Normal後半
    x_lim{1} = [0.2 4.4]; %sample Normal前半
end
if strcmp(inputName,'sample Normal2'),
    % x_lim{1} = [0.2 1.77]; %sample Normal2前半
    % x_lim{2} = [1.77 2.9]; %sample Normal2後半
    x_lim{1} = [0.2 2.9];
end
y_lim = [-0.2 0.2];

%音声を前半と後半に分けて表示
%スペクトログラム
for g = 1:length(gain), %ゲインの違い
    for l =1:numel(x_lim), %音声の前半後半
        
        scrsz = get(0,'ScreenSize');
        figure('Name',[inputName '_16Hz_' num2str(gain(g)) 'dB ' NameEnd ; ''],'NumberTitle','off', 'Position',[0 0 scrsz(3)/2 scrsz(4)])
        
        for b = 1:length(B), %音声の帯域分割の違い
            if b == 1,
                subplot(length(B)+2,1,b)
                plot(xplot_1./1000,X);
                title([inputName ' 16Hz ' num2str(gain(g)) 'dB ' NameEnd ], 'FontSize',14);
                xlim(x_lim{l});
                ylim(y_lim)
                ylabel({'Original';' '},'FontSize',12)
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
                spplotlabel(label2,'k:',12);

                subplot(length(B)+2,1,b+1)
                spectrogram(X,hamming(128),96,256,fs,'yaxis')
                xlim(x_lim{l}) ;
                setLabel('',{'Original';'Frequency';' '},'',14)
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
                set( gca, 'YTick', 0:1000:8000);
                set( gca, 'YTicklabel', 0:1:8);
            end
            subplot(length(B)+2,1,b+2)
            spectrogram(ReX{b,g},hamming(128),96,256,fs,'yaxis')
            xlim(x_lim{l});
            setLabel('', {[num2str(B(b)) ' Band']; 'Frequency';' '}, '',14);
            if b ~= length(B),
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
                set( gca, 'YTick', 0:1000:8000);
                set( gca, 'YTicklabel', 0:1:8);
            else
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
                set( gca, 'YTick', 0:1000:8000);
                set( gca, 'YTicklabel', 0:1:8);
                xlabel('Time [s]', 'FontSize',14)
            end
        end

        outputName = [inputName '_16Hz_' num2str(gain(g)) 'dB_' NameEnd];
%         saveas(gca,[outputDirName 'spectrogram/' outputName '_Spectrogram.fig'])
        print([outputDirName 'spectrogram/' outputName '_Spectrogram'],'-dmeta','-cmyk')
%         print([outputDirName 'spectrogram/' outputName '_Spectrogram'],'-dmeta','-r200')
%         print([outputDirName outputName '_Spectrogram'],'-dpdf','-r200','-painters')
%         saveas(gcf,[outputDirName outputName '_Spectrogram.emf'],'meta','-r200'); %直前のfigureを保存
        %figデータを保存する
    end
end
% 音声波形
for g = 1:length(gain), %ゲインの違い
    for l =1:numel(x_lim), %音声の前半後半
        
        scrsz = get(0,'ScreenSize');
        figure('Name',[inputName '_16Hz_' num2str(gain(g)) 'dB ' NameEnd],'NumberTitle','off', 'Position',[0 0 scrsz(3)/2 scrsz(4)])
        
        for b = 1:length(B), %音声の帯域分割の違い
            if b == 1,
                subplot(length(B)+1,1,b)
                plot(xplot_1./1000,X);
                title([inputName ' 16Hz ' num2str(gain(g)) 'dB ' NameEnd], 'FontSize',14);
                xlim(x_lim{l}) %sample Normal
                ylim(y_lim)
                setLabel('', {'Original'; 'Amplitude'} , '',14);
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
                spplotlabel(label2,'k:',12);
            end
            subplot(length(B)+1,1,b+1)
            plot(xplot_1./1000,ReX{b,g});
            xlim(x_lim{l}) %sample Normal
            ylim(y_lim) %sample Normal
            setLabel('', {[num2str(B(b)) ' Band'];'Amplitude'}, '',14);
            spplotlabel(label2,'k:',12);
            
            if b ~= length(B),
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
            else
                set( gca, 'FontName','MS UI Gothic','FontSize',12);
                xlabel('Time [s]', 'FontSize',14)
            end
        end
        
        outputName = [inputName '_16Hz_' num2str(gain(g)) 'dB_' NameEnd];
        saveas(gcf,[outputDirName 'waveform/' outputName '_waveform.emf']); %直前のfigureを保存
        
    end
end

