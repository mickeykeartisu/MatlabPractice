%"get_DdeltaOfEachBand_phoneme"�ŋ��߂��e�����̑ш悲�Ƃ�D������ɉ��f���Ƃ̃�t���v�Z����
clear all
s_num = 1;
e_num = 50;
Fs = 16000;
maxfreq = 500;
T = 16; %�ш敪����
setGain = 3; 

Band_Hz = (Fs/2)/T;
inputDirName = '../voice_data/Ddelta_phoneme/';
outputDirName = '../fig_data/Ddelta_phoneme/';

load([inputDirName 'phoneme by EachVoice_' num2str(setGain) 'dB_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed']);
% %�ϐ�AN_allDcep,AC_allDcep,AE_allDcep��ǂݍ���

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

phoneme_c_typelist = {'���C','�j�C','�j��','���ꉹ','�@��'};
phoneme_c_typelist_r = {'masatsu', 'hasatsu','haretsu','hanboin','bion'};
phoneme_c_typelist_e = {'Fricative','Affricate','Plosive','Semivowel','Nasal'};



% load([inputDirName 'phoneme by EachVoice_BandDivision_' num2str(setGain) 'dB_' num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed'])
% 
% load([inputDirName 'phoneme by EachVoice_AE0' num2str(setGain) 'dB_' num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq0Hz_Processed'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyboard

%%%%%�v���b�g%%%%%
% �x�N�g���ɕϊ�
% �ꉹ
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
% %�q��
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
%         %�ēc�����Ő��K��
%         AE_phoneme_c_bar_norm(t,i) = AE_phoneme_c{t,i}.ave/AS_phoneme_c{t,i}.ave;
%     %     AE_phoneme_c{i}.ave/AS_phoneme_c{i}.ave
%     %     keyboard
%         AN_phoneme_c_bar_norm(t,i) = AN_phoneme_c{t,i}.ave/AS_phoneme_c{t,i}.ave;
%     end
% end

%%�v���b�gX���p
%�ш��r�p
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

% �ʏ퉹���A�ēc�����A���������̉��f���Ƃ̔�r�i�ꉹ�j
% figure
% bar([AN_phoneme_v_bar;AS_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% % �ʏ퉹���A�ēc�����A���������̉��f���Ƃ̔�r�i�q���j
% figure
% bar([AN_phoneme_c_bar;AS_phoneme_c_bar;AE_phoneme_c_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% % �ʏ퉹���A���ĉ����A���������̉��f���Ƃ̔�r�i�ꉹ�j
% figure
% bar([AN_phoneme_v_bar;AC_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% �ʏ퉹���A���ĉ����A���������̉��f���Ƃ̔�r�i�ꉹ�j
% figure
% bar([AN_phoneme_v_bar;AC_phoneme_v_bar;AE_phoneme_v_bar;AS_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1],'YLim',[0,1.0]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% legend('Normal Speech','Clear Speech','Kohara method','Shibata method');

% 
% % �ʏ퉹���A���ĉ����A���������̉��f���Ƃ̔�r�i�q���j
% figure
% bar([AN_phoneme_c_bar;AC_phoneme_c_bar;AE_phoneme_c_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% �ēc�����A���������̒����l�����Ƃ̔�r�i�ʏ퉹���Ő��K���j
% figure
% bar([AS_phoneme_shiinbetsu./AN_phoneme_shiinbetsu;AE_phoneme_shiinbetsu./AN_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Normarized dynamic feature [dB/msec]','', 14)

% �ʏ퉹���A�ēc�����A���������̒����l�����Ƃ̔�r
% figure
% bar([AN_phoneme_shiinbetsu;AS_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
% 
% % �ʏ퉹���A���ĉ����A���������̒����l�����Ƃ̔�r
% figure
% bar([AN_phoneme_shiinbetsu;AC_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)

% �ʏ퉹���A���ĉ����A���������A�ēc�����̒����l�����Ƃ̔�r
% figure
% bar([AN_phoneme_shiinbetsu;AC_phoneme_shiinbetsu;AS_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1],'YLim',[0.2,0.8]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
% legend('Normal Speech','Clear Speech','Shibata''s method','Proposed method');

% �ʏ퉹���A���ĉ����A���������A���������i�n�j���O�Ȃ��j�A�ēc�����̒����l�����Ƃ̔�r
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
lgd = legend('�ʏ퉹��','���ǑO��������','���ǌ㋭������','�ēc��@��������');
lgd.FontSize = 24;

% �ʏ퉹���A���ĉ����A���������̉��f���Ƃ̔�r�i�ꉹ�j
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

