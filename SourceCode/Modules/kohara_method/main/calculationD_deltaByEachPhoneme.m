%"get_Ddelta_phoneme"�ŋ��߂��������Ƃ�D������ɉ��f���Ƃ̃�t���v�Z����
clear all
s_num = 1;
e_num = 50;
setGain = 3;
Fs = 16000;
maxfreq = 500;
T = 16; %�ш敪����


inputDirName = '../voice_data/Ddelta_phoneme/';

load([inputDirName 'phoneme by EachVoice_' num2str(setGain) 'dB_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz']);
%�ϐ�AN_allDcep,AC_allDcep,AE_allDcep��ǂݍ���

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

% phoneme_c_typelist = {'���C','�j�C','�j��','���ꉹ','�@��'};
phoneme_c_typelist = {'Fricative','Affricate','Plosive','Semivowel','Nasal'};

%�v�Z���ʂ��i�[����cell�z����`
AN_phoneme_v = dec_phonemeValueCell(phoneme_v_list);
AN_phoneme_nv = dec_phonemeValueCell(phoneme_nv_list);
AN_phoneme_c = dec_phonemeValueCell(phoneme_c_list);
AN_phoneme_etc = dec_phonemeValueCell(phoneme_etc_list);
% AN_masatsu = dec_phonemeValueCell(masatsu_list);
% AN_hasatsu = dec_phonemeValueCell(hasatsu_list);
% AN_haretsu = dec_phonemeValueCell(haretsu_list);
% AN_hanboin = dec_phonemeValueCell(hanboin_list);
% AN_bion = dec_phonemeValueCell(bion_list_list);

AC_phoneme_v = dec_phonemeValueCell(phoneme_v_list);
AC_phoneme_nv = dec_phonemeValueCell(phoneme_nv_list);
AC_phoneme_c = dec_phonemeValueCell(phoneme_c_list);
AC_phoneme_etc = dec_phonemeValueCell(phoneme_etc_list);

AE_phoneme_v = dec_phonemeValueCell(phoneme_v_list);
AE_phoneme_nv = dec_phonemeValueCell(phoneme_nv_list);
AE_phoneme_c = dec_phonemeValueCell(phoneme_c_list);
AE_phoneme_etc = dec_phonemeValueCell(phoneme_etc_list);

AE0_phoneme_v = dec_phonemeValueCell(phoneme_v_list);
AE0_phoneme_nv = dec_phonemeValueCell(phoneme_nv_list);
AE0_phoneme_c = dec_phonemeValueCell(phoneme_c_list);
AE0_phoneme_etc = dec_phonemeValueCell(phoneme_etc_list);

% AE_masatsu = dec_phonemeValueCell(masatsu_list);
% AE_hasatsu = dec_phonemeValueCell(hasatsu_list);
% AE_haretsu = dec_phonemeValueCell(haretsu_list);
% AE_hanboin = dec_phonemeValueCell(hanboin_list);
% AE_bion = dec_phonemeValueCell(bion_list_list);

AS_phoneme_v = dec_phonemeValueCell(phoneme_v_list);
AS_phoneme_nv = dec_phonemeValueCell(phoneme_nv_list);
AS_phoneme_c = dec_phonemeValueCell(phoneme_c_list);
AS_phoneme_etc = dec_phonemeValueCell(phoneme_etc_list);

for n = s_num:e_num,
    %�ꉹ�p
    for i = 1:length(phoneme_v_list),
        %�ʏ퉹��
        for ii =  1:length(AN_allDcep{n}),
            if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
%             if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1 || strcmp(AN_allDcep{n}(ii).phoneme,[phoneme_v_list{i} ':']) == 1,
                AN_phoneme_v{i}.sum = AN_phoneme_v{i}.sum + AN_allDcep{n}(ii).dcep;
                AN_phoneme_v{i}.num = AN_phoneme_v{i}.num + 1;
            end
        end
        %���ĉ���
        for ii =  1:length(AC_allDcep{n}),
            if strcmp(AC_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
                AC_phoneme_v{i}.sum = AC_phoneme_v{i}.sum + AC_allDcep{n}(ii).dcep;
                AC_phoneme_v{i}.num = AC_phoneme_v{i}.num + 1;
            end
        end
        %��������
        for ii =  1:length(AE_allDcep{n}),
            if strcmp(AE_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
                AE_phoneme_v{i}.sum = AE_phoneme_v{i}.sum + AE_allDcep{n}(ii).dcep;
                AE_phoneme_v{i}.num = AE_phoneme_v{i}.num + 1;
            end
        end
        
        for ii =  1:length(AE0_allDcep{n}),
            if strcmp(AE0_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
                AE0_phoneme_v{i}.sum = AE0_phoneme_v{i}.sum + AE0_allDcep{n}(ii).dcep;
                AE0_phoneme_v{i}.num = AE0_phoneme_v{i}.num + 1;
            end
        end
        %�ēc����
        for ii =  1:length(AS_allDcep{n}),
            if strcmp(AS_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
                AS_phoneme_v{i}.sum = AS_phoneme_v{i}.sum + AS_allDcep{n}(ii).dcep;
                AS_phoneme_v{i}.num = AS_phoneme_v{i}.num + 1;
            end
        end
    end
    
    %�q���p
    for i = 1:length(phoneme_c_list),
        %�ʏ퉹��
        for ii =  1:length(AN_allDcep{n}),
            if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AN_phoneme_c{i}.sum = AN_phoneme_c{i}.sum + AN_allDcep{n}(ii).dcep;
                AN_phoneme_c{i}.num = AN_phoneme_c{i}.num + 1;
            end
        end
%       %���ĉ���
        for ii =  1:length(AC_allDcep{n}),
            if strcmp(AC_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AC_phoneme_c{i}.sum = AC_phoneme_c{i}.sum + AC_allDcep{n}(ii).dcep;
                AC_phoneme_c{i}.num = AC_phoneme_c{i}.num + 1;
            end
        end
        %��������
        for ii =  1:length(AE_allDcep{n}),
            if strcmp(AE_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AE_phoneme_c{i}.sum = AE_phoneme_c{i}.sum + AE_allDcep{n}(ii).dcep;
                AE_phoneme_c{i}.num = AE_phoneme_c{i}.num + 1;
            end
        end
        
        for ii =  1:length(AE0_allDcep{n}),
            if strcmp(AE0_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AE0_phoneme_c{i}.sum = AE0_phoneme_c{i}.sum + AE0_allDcep{n}(ii).dcep;
                AE0_phoneme_c{i}.num = AE0_phoneme_c{i}.num + 1;
            end
        end
        %�ēc����
        for ii =  1:length(AS_allDcep{n}),
            if strcmp(AS_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AS_phoneme_c{i}.sum = AS_phoneme_c{i}.sum + AS_allDcep{n}(ii).dcep;
                AS_phoneme_c{i}.num = AS_phoneme_c{i}.num + 1;
            end
        end
    end
%     %���C��
%     for i = 1:length(masatsu_list),
%     end
end

%%%%%���ς����߂�%%%%%
%�ꉹ
for i  = 1:length(phoneme_v_list);
    %�ʏ퉹��
    if AN_phoneme_v{i}.num ~= 0,
        AN_phoneme_v{i}.ave = AN_phoneme_v{i}.sum/AN_phoneme_v{i}.num;
    end
    %���ĉ���
    if AC_phoneme_v{i}.num ~= 0,
        AC_phoneme_v{i}.ave = AC_phoneme_v{i}.sum/AC_phoneme_v{i}.num;
    end
    %��������
    if AE_phoneme_v{i}.num ~= 0,
        AE_phoneme_v{i}.ave = AE_phoneme_v{i}.sum/AE_phoneme_v{i}.num;
    end
    
    if AE0_phoneme_v{i}.num ~= 0,
        AE0_phoneme_v{i}.ave = AE0_phoneme_v{i}.sum/AE0_phoneme_v{i}.num;
    end
    %�ēc����
    if AS_phoneme_v{i}.num ~= 0,
        AS_phoneme_v{i}.ave = AS_phoneme_v{i}.sum/AS_phoneme_v{i}.num;
    end
end
%�q��
for i  = 1:length(phoneme_c_list);
    %�ʏ퉹��
    if AN_phoneme_c{i}.num ~= 0,
        AN_phoneme_c{i}.ave = AN_phoneme_c{i}.sum/AN_phoneme_c{i}.num;
    end
    %���ĉ���
    if AC_phoneme_c{i}.num ~= 0,
        AC_phoneme_c{i}.ave = AC_phoneme_c{i}.sum/AC_phoneme_c{i}.num;
    end
    %��������
    if AE_phoneme_c{i}.num ~= 0,
        AE_phoneme_c{i}.ave = AE_phoneme_c{i}.sum/AE_phoneme_c{i}.num;
    end
    
    if AE0_phoneme_c{i}.num ~= 0,
        AE0_phoneme_c{i}.ave = AE0_phoneme_c{i}.sum/AE0_phoneme_c{i}.num;
    end
    %�ēc����
    if AS_phoneme_c{i}.num ~= 0,
        AS_phoneme_c{i}.ave = AS_phoneme_c{i}.sum/AS_phoneme_c{i}.num;
    end
end

%%%%%%%%%%%%%%%%%%%%%�����l�����Ƃɕ�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ʏ퉹��
masatsu.ave = 0;
hasatsu.ave = 0;
haretsu.ave = 0;
hanboin.ave = 0;
bion.ave = 0;
masatsu.num = 0;
hasatsu.num = 0;
haretsu.num = 0;
hanboin.num = 0;
bion.num = 0;
for i  = 1:length(phoneme_c_list);
    %���C��
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AN_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %�j�C��
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AN_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %�j��
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AN_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %���ꉹ
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AN_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %�@��
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AN_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AN_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];
% keyboard

%���������𕪂���
masatsu.ave = 0;
hasatsu.ave = 0;
haretsu.ave = 0;
hanboin.ave = 0;
bion.ave = 0;
masatsu.num = 0;
hasatsu.num = 0;
haretsu.num = 0;
hanboin.num = 0;
bion.num = 0;
for i  = 1:length(phoneme_c_list);
    %���C��
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AE_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %�j�C��
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AE_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %�j��
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AE_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %���ꉹ
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AE_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %�@��
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AE_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AE_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];

%���������𕪂���(�n�j���O�Ȃ�)
masatsu.ave = 0;
hasatsu.ave = 0;
haretsu.ave = 0;
hanboin.ave = 0;
bion.ave = 0;
masatsu.num = 0;
hasatsu.num = 0;
haretsu.num = 0;
hanboin.num = 0;
bion.num = 0;
for i  = 1:length(phoneme_c_list);
    %���C��
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AE0_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %�j�C��
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AE0_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %�j��
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AE0_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %���ꉹ
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AE0_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %�@��
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AE0_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AE0_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];

%�ēc�����𕪂���
masatsu.ave = 0;
hasatsu.ave = 0;
haretsu.ave = 0;
hanboin.ave = 0;
bion.ave = 0;
masatsu.num = 0;
hasatsu.num = 0;
haretsu.num = 0;
hanboin.num = 0;
bion.num = 0;
for i  = 1:length(phoneme_c_list);
        %���C��
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AS_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %�j�C��
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AS_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %�j��
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AS_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %���ꉹ
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AS_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %�@��
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AS_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AS_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];

%���ĉ����𕪂���
masatsu.ave = 0;
hasatsu.ave = 0;
haretsu.ave = 0;
hanboin.ave = 0;
bion.ave = 0;
masatsu.num = 0;
hasatsu.num = 0;
haretsu.num = 0;
hanboin.num = 0;
bion.num = 0;
for i  = 1:length(phoneme_c_list);
        %���C��
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AC_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %�j�C��
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AC_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %�j��
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AC_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %���ꉹ
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AC_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %�@��
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AC_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AC_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyboard

%%%%%�v���b�g%%%%%
%�x�N�g���ɕϊ�
%�ꉹ
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

%�q��
AN_phoneme_c_bar = zeros(1,length(phoneme_c_list));
AC_phoneme_c_bar = zeros(1,length(phoneme_c_list));
AE_phoneme_c_bar = zeros(1,length(phoneme_c_list));
AE0_phoneme_c_bar = zeros(1,length(phoneme_c_list));
AS_phoneme_c_bar = zeros(1,length(phoneme_c_list));
AN_phoneme_c_bar_norm = zeros(1,length(phoneme_c_list));
AE_phoneme_c_bar_norm = zeros(1,length(phoneme_c_list));
AS_phoneme_c_bar_norm = zeros(1,length(phoneme_c_list));
for i = 1:length(phoneme_c_list),
    AN_phoneme_c_bar(i) = AN_phoneme_c{i}.ave;
    AC_phoneme_c_bar(i) = AC_phoneme_c{i}.ave;
    AE_phoneme_c_bar(i) = AE_phoneme_c{i}.ave;
    AE0_phoneme_c_bar(i) = AE0_phoneme_c{i}.ave;
    AS_phoneme_c_bar(i) = AS_phoneme_c{i}.ave;
    
    %�ēc�����Ő��K��
    AE_phoneme_c_bar_norm(i) = AE_phoneme_c{i}.ave/AS_phoneme_c{i}.ave;
% %     AE_phoneme_c{i}.ave/AS_phoneme_c{i}.ave
% %     keyboard
    AN_phoneme_c_bar_norm(i) = AN_phoneme_c{i}.ave/AS_phoneme_c{i}.ave;
end

save([inputDirName 'phoneme by EachVoice_'  num2str(setGain) 'dB_'  num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed'],...
    'AN_phoneme_v','AN_phoneme_c','AN_phoneme_shiinbetsu',...
    'AC_phoneme_v','AC_phoneme_c','AC_phoneme_shiinbetsu',...
    'AE_phoneme_v','AE_phoneme_c','AE_phoneme_shiinbetsu',...
    'AE0_phoneme_v','AE0_phoneme_c','AE0_phoneme_shiinbetsu',...
    'AS_phoneme_v','AS_phoneme_c','AS_phoneme_shiinbetsu',...
    'AN_phoneme_v_bar','AN_phoneme_c_bar','AN_phoneme_c_bar_norm',...
    'AC_phoneme_v_bar','AC_phoneme_c_bar',...
    'AE_phoneme_v_bar','AE_phoneme_c_bar','AE_phoneme_c_bar_norm',...
    'AE0_phoneme_v_bar','AE0_phoneme_c_bar',...
    'AS_phoneme_v_bar','AS_phoneme_c_bar')


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
set( gca, 'FontName','MS UI Gothic','FontSize',12);
setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
legend('Normal Speech','Clear Speech','Shibata''s method','Proposed method(0Hz)','Proposed method');


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

