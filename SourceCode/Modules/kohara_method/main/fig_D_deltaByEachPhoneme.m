%"get_DdeltaOfEachBand_phoneme"で求めた各音声の帯域ごとのDΔを基に音素ごとのΔtを計算する
clear all
s_num = 1;
e_num = 50;
Fs = 16000;
maxfreq = 500;
T = 16; %帯域分割数
setGain = 3; 

Band_Hz = (Fs/2)/T;
inputDirName = '../voice_data/Ddelta_phoneme/';
outputDirName = '../fig_data/Ddelta_phoneme/';

load([inputDirName 'phoneme by EachVoice_' num2str(setGain) 'dB_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed']);
% %変数AN_allDcep,AC_allDcep,AE_allDcepを読み込む

phoneme_v_list = {'a', 'i', 'u', 'e', 'o'};
phoneme_nv_list = upper(phoneme_v_list);
% phoneme_c_list = {'N', 'k', 's', 'sh', 't', 'ch', 'ts', 'n', 'h', 'f',...
%     'm', 'y', 'r', 'w', 'g', 'z', 'j', 'd', 'b', 'p', 'ky', 'ny',...
%     'hy', 'my', 'ry', 'gy', 'by', 'py', 'dy'};
phoneme_c_list = {'s', 'sh','f','z','h','hy',...
    'ts','ch',...
    'k', 's', 't','g', 'd', 'b', 'p', 'ky','gy', 'by', 'py', 'dy',...
    'w','r','j','ry',...
    'm','n','my','ny','N'};
phoneme_etc_list = {'sp', 'cl', 'q'};


masatsu_list = {'s', 'sh','f','z','h','hy'};
hasatsu_list = {'ts','ch'};
haretsu_list = {'k', 's', 't','g', 'd', 'b', 'p', 'ky','gy', 'by', 'py', 'dy'};
hanboin_list = {'w','r','j','ry'};
bion_list = {'m','n','my','ny','N'};

phoneme_c_typelist = {'摩擦','破擦','破裂','半母音','鼻音'};
phoneme_c_typelist_r = {'masatsu', 'hasatsu','haretsu','hanboin','bion'};
phoneme_c_typelist_e = {'Fricative','Affricate','Plosive','Semivowel','Nasal'};



% load([inputDirName 'phoneme by EachVoice_BandDivision_' num2str(setGain) 'dB_' num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed'])
% 
% load([inputDirName 'phoneme by EachVoice_AE0' num2str(setGain) 'dB_' num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq0Hz_Processed'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyboard

%%%%%プロット%%%%%
% ベクトルに変換
% 母音
AN_phoneme_v_bar = zeros(1,length(phoneme_v_list));
AC_phoneme_v_bar = zeros(1,length(phoneme_v_list));
AE_phoneme_v_bar = zeros(1,length(phoneme_v_list));
AE0_phoneme_v_bar = zeros(1,length(phoneme_v_list));
AS_phoneme_v_bar = zeros(1,length(phoneme_v_list));
for i = 1:length(phoneme_v_list),
    AN_phoneme_v_bar(i) = AN_phoneme_v{i}.ave;
    AC_phoneme_v_bar(i) = AC_phoneme_v{i}.ave;
    AE_phoneme_v_bar(i) = AE_phoneme_v{i}.ave;
    AE0_phoneme_v_bar(i) = AE0_phoneme_v{i}.ave;
    AS_phoneme_v_bar(i) = AS_phoneme_v{i}.ave;
end
% 
% %子音
% AN_phoneme_c_bar = zeros(T,length(phoneme_c_list));
% AC_phoneme_c_bar = zeros(T,length(phoneme_c_list));
% AE_phoneme_c_bar = zeros(T,length(phoneme_c_list));
% AS_phoneme_c_bar = zeros(T,length(phoneme_c_list));
% AN_phoneme_c_bar_norm = zeros(T,length(phoneme_c_list));
% AE_phoneme_c_bar_norm = zeros(T,length(phoneme_c_list));
% AS_phoneme_c_bar_norm = zeros(T,length(phoneme_c_list));
% for t = 1:T,
%     for i = 1:length(phoneme_c_list),
%         AN_phoneme_c_bar(t,i) = AN_phoneme_c{t,i}.ave;
%         AC_phoneme_c_bar(t,i) = AC_phoneme_c{t,i}.ave;
%         AE_phoneme_c_bar(t,i) = AE_phoneme_c{t,i}.ave;
%         AS_phoneme_c_bar(t,i) = AS_phoneme_c{t,i}.ave;
% 
%         %柴田音声で正規化
%         AE_phoneme_c_bar_norm(t,i) = AE_phoneme_c{t,i}.ave/AS_phoneme_c{t,i}.ave;
%     %     AE_phoneme_c{i}.ave/AS_phoneme_c{i}.ave
%     %     keyboard
%         AN_phoneme_c_bar_norm(t,i) = AN_phoneme_c{t,i}.ave/AS_phoneme_c{t,i}.ave;
%     end
% end

%%プロットX軸用
%帯域比較用
% Band_bar = zeros(1,T);
% for t = 1:T,
%     Band_bar(t) = {[num2str(Band_Hz * t) 'Hz']};
% end

% for t = 1:T,
%     Band_bar(t) = {[num2str(Band_Hz * (t-1)) 'Hz-' num2str(Band_Hz * t) 'Hz']};
% %     Band_bar(2,t) = {[num2str(Band_Hz * (t-1)) 'Hz to ' num2str(Band_Hz * t) 'Hz']};
% end
% 
% for t = 1:T,
%     Band_bar(t) = {[num2str(Band_Hz * t - 50) 'Hz']};
% %     Band_bar(2,t) = {[num2str(Band_Hz * (t-1)) 'Hz to ' num2str(Band_Hz * t) 'Hz']};
% end


% AN.allC = zeros(1,T);
% AC.allC= zeros(1,T);
% AE.allC= zeros(1,T);
% AE0.allC= zeros(1,T);
% for i = 1:length(phoneme_c_typelist),
%     AN.allC = AN.allC+AN.c{i};
%     AC.allC = AC.allC+AC.c{i};
%     AE.allC = AE.allC+AE.c{i};
%     AE0.allC = AE0.allC+AE0.c{i};
% end
% % keyboard
% AN.allC = AN.allC/length(phoneme_c_typelist);
% AC.allC = AC.allC/length(phoneme_c_typelist);
% AE.allC = AE.allC/length(phoneme_c_typelist);
% AE0.allC = AE0.allC/length(phoneme_c_typelist);
% 
% % AN.allV = zeros(1,T);
% % AC.allV= zeros(1,T);
% % AE.allV= zeros(1,T);
% 
% AN.allV = mean(AN_phoneme_v_bar,2)';
% AC.allV = mean(AC_phoneme_v_bar,2)';
% AE.allV = mean(AE_phoneme_v_bar,2)';
% AE0.allV = mean(AE0_phoneme_v_bar,2)';

% keyboard


scrsz = get(0,'ScreenSize');

% 通常音声、柴田音声、強調音声の音素ごとの比較（母音）
% figure
% bar([AN_phoneme_v_bar;AS_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% % 通常音声、柴田音声、強調音声の音素ごとの比較（子音）
% figure
% bar([AN_phoneme_c_bar;AS_phoneme_c_bar;AE_phoneme_c_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% % 通常音声、明瞭音声、強調音声の音素ごとの比較（母音）
% figure
% bar([AN_phoneme_v_bar;AC_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% 通常音声、明瞭音声、強調音声の音素ごとの比較（母音）
% figure
% bar([AN_phoneme_v_bar;AC_phoneme_v_bar;AE_phoneme_v_bar;AS_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1],'YLim',[0,1.0]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% legend('Normal Speech','Clear Speech','Kohara method','Shibata method');

% 
% % 通常音声、明瞭音声、強調音声の音素ごとの比較（子音）
% figure
% bar([AN_phoneme_c_bar;AC_phoneme_c_bar;AE_phoneme_c_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% 柴田音声、強調音声の調音様式ごとの比較（通常音声で正規化）
% figure
% bar([AS_phoneme_shiinbetsu./AN_phoneme_shiinbetsu;AE_phoneme_shiinbetsu./AN_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Normarized dynamic feature [dB/msec]','', 14)

% 通常音声、柴田音声、強調音声の調音様式ごとの比較
% figure
% bar([AN_phoneme_shiinbetsu;AS_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
% 
% % 通常音声、明瞭音声、強調音声の調音様式ごとの比較
% figure
% bar([AN_phoneme_shiinbetsu;AC_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)

% 通常音声、明瞭音声、強調音声、柴田音声の調音様式ごとの比較
% figure
% bar([AN_phoneme_shiinbetsu;AC_phoneme_shiinbetsu;AS_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1],'YLim',[0.2,0.8]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
% legend('Normal Speech','Clear Speech','Shibata''s method','Proposed method');

% 通常音声、明瞭音声、強調音声、強調音声（ハニングなし）、柴田音声の調音様式ごとの比較
figure
bar([AN_phoneme_shiinbetsu;AC_phoneme_shiinbetsu;AS_phoneme_shiinbetsu;AE0_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1],'YLim',[0.2,0.8]);
set( gca, 'FontName','MS UI Gothic','FontSize',24);
setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 24)
lgd = legend('Normal Speech','Clear Speech','Shibata''s method','Previous proposed method','Improved proposed method');
lgd.FontSize = 24;

figure
bar([AN_phoneme_shiinbetsu;AE0_phoneme_shiinbetsu;AE_phoneme_shiinbetsu;AS_phoneme_shiinbetsu]','grouped')
set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1],'YLim',[0.2,0.8]);
set( gca, 'FontName','MS UI Gothic','FontSize',24);
setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 24)
lgd = legend('通常音声','改良前強調音声','改良後強調音声','柴田手法強調音声');
lgd.FontSize = 24;

% 通常音声、明瞭音声、強調音声の音素ごとの比較（母音）
figure
bar([AN_phoneme_v_bar;AC_phoneme_v_bar;AS_phoneme_v_bar;AE0_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1],'YLim',[0,0.8]);
set( gca, 'FontName','MS UI Gothic','FontSize',24);
setLabel('Vowel','Dynamic feature [dB/msec]','', 24)
lgd = legend('Normal Speech','Clear Speech','Shibata''s method','Previous proposed method','Improved proposed method');
lgd.FontSize = 24;


% figure
% bar([AN_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% figure
% bar([AN_phoneme_c_bar_norm;AE_phoneme_c_bar_norm]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

