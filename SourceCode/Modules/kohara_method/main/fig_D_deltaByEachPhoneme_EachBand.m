%"calculationD_deltaByEachPhoneme_EachBand"で求めた各音声の帯域ごとの音素ごとのDΔtをプロットする
clear all
scrsz = get(0,'ScreenSize');

s_num = 1;
e_num = 5;
setGain = 6;
Fs = 16000;
maxfreq = 500;
T = 80; %帯域分割数

%提案手法のパラメタ
threshold_dB =[9];
ratio = Inf;
kneeWidth_dB = 6;
T_2 = 16;

inputDirName = '../voice_data/Ddelta_phoneme/';
outputDirName = '../fig_data/Ddelta_phoneme/';

inputName_AN = ['AN_DynamicFeature_BandDivision_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Phoneme'];
inputName_AC = ['AC_DynamicFeature_BandDivision_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Phoneme'];
inputName_AE = ['AE_DynamicFeature_BandDivision_' num2str(setGain) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB_' num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Phoneme'];
inputName_AS = ['AS_DynamicFeature_BandDivision_'  num2str(setGain) 'dB_'  num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Phoneme'];

load([inputDirName inputName_AN]);
load([inputDirName inputName_AC]);
load([inputDirName inputName_AE]);
load([inputDirName inputName_AS]);

phoneme_list = {'a', 'i', 'u', 'e', 'o',...
    's', 'sh','f','z','h','hy',...
    'ts','ch',...
    'k','t','g', 'd', 'b', 'p', 'ky','gy', 'by', 'py', 'dy',...
    'w','r','j','ry',...
    'm','n','my','ny','N'};

phoneme_v_list = {'a', 'i', 'u', 'e', 'o'};
phoneme_nv_list = upper(phoneme_v_list);
% phoneme_c_list = {'N', 'k', 's', 'sh', 't', 'ch', 'ts', 'n', 'h', 'f',...
%     'm', 'y', 'r', 'w', 'g', 'z', 'j', 'd', 'b', 'p', 'ky', 'ny',...
%     'hy', 'my', 'ry', 'gy', 'by', 'py', 'dy'};
phoneme_c_list = {'s', 'sh','f','z','h','hy',...
    'ts','ch',...
    'k', 't','g', 'd', 'b', 'p', 'ky','gy', 'by', 'py', 'dy',...
    'w','r','j','ry',...
    'm','n','my','ny','N'};
phoneme_etc_list = {'sp', 'cl', 'q'};

masatsu_list = {'s', 'sh','f','z','h','hy'};
hasatsu_list = {'ts','ch'};
haretsu_list = {'k', 't','g', 'd', 'b', 'p', 'ky','gy', 'by', 'py', 'dy'};
hanboin_list = {'w','r','j','ry'};
bion_list = {'m','n','my','ny','N'};

phoneme_c_typelist = {'摩擦','破擦','破裂','半母音','鼻音'};
phoneme_c_typelist_r = {'masatsu', 'hasatsu','haretsu','hanboin','bion'};
phoneme_c_typelist_e = {'Fricative','Affricate','Plosive','Semivowel','Nasal'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%100Hzごとの動的特徴量から，500Hzごとの動的特徴量を計算する
sp = 1;
AN.allC_500 = zeros(1,80/5);
AC.allC_500 = zeros(1,80/5);
AE.allC_500 = zeros(1,80/5);
AS.allC_500 = zeros(1,80/5);
AN.allV_500 = zeros(1,80/5);
AC.allV_500 = zeros(1,80/5);
AE.allV_500 = zeros(1,80/5);
AS.allV_500 = zeros(1,80/5);
for i = 1:16,
    AN.allC_500(i) = mean(AN.allC(sp:sp+5-1));
    AC.allC_500(i) = mean(AC.allC(sp:sp+5-1));
    AE.allC_500(i) = mean(AE.allC(sp:sp+5-1));
    AS.allC_500(i) = mean(AS.allC(sp:sp+5-1));
    
    AN.allV_500(i) = mean(AN.allV(sp:sp+5-1));
    AC.allV_500(i) = mean(AC.allV(sp:sp+5-1));
    AE.allV_500(i) = mean(AE.allV(sp:sp+5-1));
    AS.allV_500(i) = mean(AS.allV(sp:sp+5-1));
    sp = sp+5;
end

fontsize = 24;
label_fontsize = 24;
legend_fontsize = 24;

% fig_size = [0.1 0.1 3.7*scrsz(3)/5 scrsz(4)/2];
fig_size = [0.1 0.1 4.8*scrsz(3)/5 1.5*scrsz(4)/2];

%1にするとグラフを表示できる．
if 0, %100Hzごと
    Band_Hz = (Fs/2)/T;
    %%plot x軸用
    for t = 1:T,
%         Band_bar_100Hz(t) = {[num2str(Band_Hz * (t-1)) 'Hz-' num2str(Band_Hz * t) 'Hz']};
        Band_bar_100Hz(t) = {[num2str(Band_Hz * (t-1)) '-' num2str(Band_Hz * t)]};
%         Band_bar_100Hz(t) = {[num2str(Band_Hz * t - 50) 'Hz']}; %中心周波数用
%         Band_bar_100Hz(t) = {[num2str(Band_Hz * t - 50)]}; %中心周波数用
    end
    
    fr_100Hz = 1:10; %100Hz用X軸範囲
    y_lim = [0 0.5];
%     y_lim = [0 0.8];
    
    %100Hzごと比較(母音)
    Vowel_100Hz = [AN.allV(fr_100Hz);AC.allV(fr_100Hz)]; %通常音声・明瞭音声100Hz
    Consonant_100Hz = [AN.allC(fr_100Hz);AC.allC(fr_100Hz)]; %通常音声・明瞭音声100Hz
%     Vowel_100Hz = [AN.allV(fr_100Hz);AC.allV(fr_100Hz);AE.allV(fr_100Hz);AS.allV(fr_100Hz)]; %通常音声・明瞭音声100Hz
%     Consonant_100Hz = [AN.allC(fr_100Hz);AC.allC(fr_100Hz);AE.allC(fr_100Hz);AS.allC(fr_100Hz)]; %通常音声・明瞭音声100Hz
%     
    figure('Name',['Vowel'],'NumberTitle','off', 'Position',fig_size)
    b = bar(Vowel_100Hz','grouped');
    set(gca, 'XTickLabel',Band_bar_100Hz(fr_100Hz), 'XTick',1:length(Band_bar_100Hz(fr_100Hz)), 'XLim',[0,length(Band_bar_100Hz(fr_100Hz))+1],'YLim',y_lim);
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    setLabel('Frequency [Hz]','D_Δ(t) [dB/ms]','', 24)
    L = legend('Normal speech','Clear speech','Proposed method','Conventional method');
    set(L, 'fontsize', legend_fontsize)
    set(b,'LineWidth',2)
    set(b,'EdgeColor','black')
    % set(b(1),'FaceColor',[0.3 0.3 0.3])
    set(b(1),'FaceColor','white')
    set(b(2),'FaceColor','black')
    title('Vowel\_100Hz');

    %100Hzごと比較(子音)
    

    figure('Name',['Consonant'],'NumberTitle','off', 'Position',fig_size)
    b = bar(Consonant_100Hz','grouped');
    set(gca, 'XTickLabel',Band_bar_100Hz(fr_100Hz), 'XTick',1:length(Band_bar_100Hz(fr_100Hz)), 'XLim',[0,length(Band_bar_100Hz(fr_100Hz))+1],'YLim',y_lim);
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    setLabel('Frequency [Hz]','D_Δ(t) [dB/ms]','', label_fontsize)
    L = legend('Normal speech','Clear speech','Proposed method','Conventional method');
    set(L, 'fontsize', legend_fontsize)
    set(b,'LineWidth',2)
    set(b,'EdgeColor','black')
    set(b(1),'FaceColor','white')
    set(b(2),'FaceColor','black')
    title('Consonant\_100Hz');
end

if 1, %500Hzごと
    
    Band_Hz = (Fs/2)/T_2;
    for t = 1:16,
        Band_bar_500Hz(t) = {[num2str(Band_Hz * (t-1)) '-' num2str(Band_Hz * t)]};
        Band_bar_500Hz(t) = {[num2str(Band_Hz * (t-1)/1000) '-' num2str(Band_Hz * t/1000)]};
%         Band_bar_500Hz(t) = {[num2str(Band_Hz * t - 250)]}; %中心周波数用
%         Band_bar_500Hz(t) = {[num2str((Band_Hz * t - 250)/1000)]}; %中心周波数用
    end
    
    fr_500Hz = 1:16; %500Hz用X軸範囲
    y_lim = [0 0.5];
    y_lim = [0 0.8];
%     y_lim = [0 0.1];
    
    %500Hzごと比較(母音)
    Vowel_500Hz = [AN.allV_500(fr_500Hz);AC.allV_500(fr_500Hz)]; %通常音声・明瞭音声500Hz
    Consonant_500Hz = [AN.allC_500(fr_500Hz);AC.allC_500(fr_500Hz)]; %通常音声・明瞭音声500Hz
    Vowel_500Hz = [AN.allV_500(fr_500Hz);AC.allV_500(fr_500Hz);AE.allV_500(fr_500Hz);AS.allV_500(fr_500Hz)]; %通常音声・明瞭音声500Hz
    Consonant_500Hz = [AN.allC_500(fr_500Hz);AC.allC_500(fr_500Hz);AE.allC_500(fr_500Hz);AS.allC_500(fr_500Hz)]; %通常音声・明瞭音声500Hz

    figure('Name',['Vowel'],'NumberTitle','off', 'Position',fig_size)
    b = bar(Vowel_500Hz','grouped');
    set(gca, 'XTickLabel',Band_bar_500Hz(fr_500Hz), 'XTick',1:length(Band_bar_500Hz(fr_500Hz)), 'XLim',[0,length(Band_bar_500Hz(fr_500Hz))+1],'YLim',y_lim);
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    setLabel('Frequency [kHz]','D_Δ(t) [dB/ms]','', label_fontsize)
    L = legend('Normal speech','Clear speech','Proposed method','Conventional method');
    set(L, 'fontsize', legend_fontsize)
    % set(b,'LineWidth',2)
    % set(b,'EdgeColor','black')
    % set(b(1),'FaceColor',[0.3 0.3 0.3])
    % set(b(1),'FaceColor','white')
    % set(b(2),'FaceColor','black')
    title('Vowel\_500Hz');


    %500Hzごと比較(子音)
    
    figure('Name',['Consonant'],'NumberTitle','off', 'Position',fig_size)
    b = bar(Consonant_500Hz','grouped');
    set(gca, 'XTickLabel',Band_bar_500Hz(fr_500Hz), 'XTick',1:length(Band_bar_500Hz(fr_500Hz)), 'XLim',[0,length(Band_bar_500Hz(fr_500Hz))+1],'YLim',y_lim);
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    setLabel('Frequency [kHz]','D_Δ(t) [dB/ms]','', label_fontsize)
    L = legend('Normal speech','Clear speech','Proposed method','Conventional method');
    set(L, 'fontsize', legend_fontsize)
    % set(b,'LineWidth',2)
    % set(b,'EdgeColor','black')
    % set(b(1),'FaceColor','white')
    % set(b(2),'FaceColor','black')
    title('Consonant\_500Hz');

end

if 1,%音素ごと比較（音声全体）
%     y_lim = [0 0.5];
    y_lim = [0 0.9];
%     Phoneme_bar = [mean(AN_phoneme_c_bar);mean(AC_phoneme_c_bar);mean(AE_phoneme_c_bar);mean(AS_phoneme_c_bar);];
    Phoneme_bar = [mean([AN_phoneme_v_bar AN_phoneme_c_bar]);mean([AC_phoneme_v_bar AC_phoneme_c_bar]);mean([AE_phoneme_v_bar AE_phoneme_c_bar]);mean([AS_phoneme_v_bar AS_phoneme_c_bar]);];
    
    figure('Name',['Phoneme'],'NumberTitle','off', 'Position',fig_size)
    b = bar(Phoneme_bar','grouped');
    set(gca, 'XTickLabel',phoneme_list, 'XTick',1:length(phoneme_list), 'XLim',[0,length(phoneme_list)+1],'YLim',y_lim);
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    setLabel('Phoneme','D_Δ(t) [dB/ms]','', label_fontsize)
    L = legend('Normal speech','Clear speech','Proposed method','Conventional method');
    set(L, 'fontsize', legend_fontsize)
    % set(b,'LineWidth',2)
    % set(b,'EdgeColor','black')
    % set(b(1),'FaceColor',[0.3 0.3 0.3])
    % set(b(1),'FaceColor','white')
    % set(b(2),'FaceColor','black')
    title('Phoneme');
end

if 0, %調音様式ごと比較（音声全体）
%     y_lim = [0 0.5];
    y_lim = [0 0.8];
    Articulation = [AN.c_articulation_allBand;AC.c_articulation_allBand;AE.c_articulation_allBand;AS.c_articulation_allBand;]; %通常音声・明瞭音声500Hz
    
    figure('Name',['Articulation'],'NumberTitle','off', 'Position',fig_size)
    b = bar(Articulation','grouped');
    set(gca, 'XTickLabel',phoneme_c_typelist_e, 'XTick',1:length(phoneme_c_typelist), 'XLim',[0,length(phoneme_c_typelist)+1],'YLim',y_lim);
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    setLabel('','D_Δ(t) [dB/ms]','', label_fontsize)
    L = legend('Normal speech','Clear speech','Proposed method','Conventional method');
    set(L, 'fontsize', legend_fontsize)
    % set(b,'LineWidth',2)
    % set(b,'EdgeColor','black')
    % set(b(1),'FaceColor','white')
    % set(b(2),'FaceColor','black')
    title('Articulation');
end

