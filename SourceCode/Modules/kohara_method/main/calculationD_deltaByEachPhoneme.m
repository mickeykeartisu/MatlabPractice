%"get_Ddelta_phoneme"で求めた音声ごとのDΔを基に音素ごとのΔtを計算する
clear all
s_num = 1;
e_num = 50;
setGain = 3;
Fs = 16000;
maxfreq = 500;
T = 16; %帯域分割数


inputDirName = '../voice_data/Ddelta_phoneme/';

load([inputDirName 'phoneme by EachVoice_' num2str(setGain) 'dB_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz']);
%変数AN_allDcep,AC_allDcep,AE_allDcepを読み込む

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

% phoneme_c_typelist = {'摩擦','破擦','破裂','半母音','鼻音'};
phoneme_c_typelist = {'Fricative','Affricate','Plosive','Semivowel','Nasal'};

%計算結果を格納するcell配列を定義
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
    %母音用
    for i = 1:length(phoneme_v_list),
        %通常音声
        for ii =  1:length(AN_allDcep{n}),
            if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
%             if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1 || strcmp(AN_allDcep{n}(ii).phoneme,[phoneme_v_list{i} ':']) == 1,
                AN_phoneme_v{i}.sum = AN_phoneme_v{i}.sum + AN_allDcep{n}(ii).dcep;
                AN_phoneme_v{i}.num = AN_phoneme_v{i}.num + 1;
            end
        end
        %明瞭音声
        for ii =  1:length(AC_allDcep{n}),
            if strcmp(AC_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
                AC_phoneme_v{i}.sum = AC_phoneme_v{i}.sum + AC_allDcep{n}(ii).dcep;
                AC_phoneme_v{i}.num = AC_phoneme_v{i}.num + 1;
            end
        end
        %強調音声
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
        %柴田音声
        for ii =  1:length(AS_allDcep{n}),
            if strcmp(AS_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1,
                AS_phoneme_v{i}.sum = AS_phoneme_v{i}.sum + AS_allDcep{n}(ii).dcep;
                AS_phoneme_v{i}.num = AS_phoneme_v{i}.num + 1;
            end
        end
    end
    
    %子音用
    for i = 1:length(phoneme_c_list),
        %通常音声
        for ii =  1:length(AN_allDcep{n}),
            if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AN_phoneme_c{i}.sum = AN_phoneme_c{i}.sum + AN_allDcep{n}(ii).dcep;
                AN_phoneme_c{i}.num = AN_phoneme_c{i}.num + 1;
            end
        end
%       %明瞭音声
        for ii =  1:length(AC_allDcep{n}),
            if strcmp(AC_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AC_phoneme_c{i}.sum = AC_phoneme_c{i}.sum + AC_allDcep{n}(ii).dcep;
                AC_phoneme_c{i}.num = AC_phoneme_c{i}.num + 1;
            end
        end
        %強調音声
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
        %柴田音声
        for ii =  1:length(AS_allDcep{n}),
            if strcmp(AS_allDcep{n}(ii).phoneme,phoneme_c_list{i}) == 1,
                AS_phoneme_c{i}.sum = AS_phoneme_c{i}.sum + AS_allDcep{n}(ii).dcep;
                AS_phoneme_c{i}.num = AS_phoneme_c{i}.num + 1;
            end
        end
    end
%     %摩擦音
%     for i = 1:length(masatsu_list),
%     end
end

%%%%%平均を求める%%%%%
%母音
for i  = 1:length(phoneme_v_list);
    %通常音声
    if AN_phoneme_v{i}.num ~= 0,
        AN_phoneme_v{i}.ave = AN_phoneme_v{i}.sum/AN_phoneme_v{i}.num;
    end
    %明瞭音声
    if AC_phoneme_v{i}.num ~= 0,
        AC_phoneme_v{i}.ave = AC_phoneme_v{i}.sum/AC_phoneme_v{i}.num;
    end
    %強調音声
    if AE_phoneme_v{i}.num ~= 0,
        AE_phoneme_v{i}.ave = AE_phoneme_v{i}.sum/AE_phoneme_v{i}.num;
    end
    
    if AE0_phoneme_v{i}.num ~= 0,
        AE0_phoneme_v{i}.ave = AE0_phoneme_v{i}.sum/AE0_phoneme_v{i}.num;
    end
    %柴田音声
    if AS_phoneme_v{i}.num ~= 0,
        AS_phoneme_v{i}.ave = AS_phoneme_v{i}.sum/AS_phoneme_v{i}.num;
    end
end
%子音
for i  = 1:length(phoneme_c_list);
    %通常音声
    if AN_phoneme_c{i}.num ~= 0,
        AN_phoneme_c{i}.ave = AN_phoneme_c{i}.sum/AN_phoneme_c{i}.num;
    end
    %明瞭音声
    if AC_phoneme_c{i}.num ~= 0,
        AC_phoneme_c{i}.ave = AC_phoneme_c{i}.sum/AC_phoneme_c{i}.num;
    end
    %強調音声
    if AE_phoneme_c{i}.num ~= 0,
        AE_phoneme_c{i}.ave = AE_phoneme_c{i}.sum/AE_phoneme_c{i}.num;
    end
    
    if AE0_phoneme_c{i}.num ~= 0,
        AE0_phoneme_c{i}.ave = AE0_phoneme_c{i}.sum/AE0_phoneme_c{i}.num;
    end
    %柴田音声
    if AS_phoneme_c{i}.num ~= 0,
        AS_phoneme_c{i}.ave = AS_phoneme_c{i}.sum/AS_phoneme_c{i}.num;
    end
end

%%%%%%%%%%%%%%%%%%%%%調音様式ごとに分ける%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%通常音声
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
    %摩擦音
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AN_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %破擦音
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AN_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %破裂音
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AN_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %半母音
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AN_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %鼻音
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AN_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AN_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];
% keyboard

%強調音声を分ける
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
    %摩擦音
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AE_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %破擦音
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AE_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %破裂音
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AE_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %半母音
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AE_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %鼻音
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AE_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AE_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];

%強調音声を分ける(ハニングなし)
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
    %摩擦音
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AE0_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %破擦音
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AE0_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %破裂音
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AE0_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %半母音
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AE0_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %鼻音
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AE0_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AE0_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];

%柴田音声を分ける
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
        %摩擦音
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AS_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %破擦音
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AS_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %破裂音
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AS_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %半母音
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AS_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %鼻音
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AS_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AS_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];

%明瞭音声を分ける
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
        %摩擦音
    if i >= 1 && i <= 6,
        masatsu.ave = masatsu.ave + AC_phoneme_c{i}.ave;
        masatsu.num = masatsu.num + 1;
    end
    %破擦音
    if i >= 7 && i <= 8,
        hasatsu.ave = hasatsu.ave + AC_phoneme_c{i}.ave;
        hasatsu.num = hasatsu.num + 1;
    end
    %破裂音
    if i >= 9 && i <= 20,
        haretsu.ave = haretsu.ave + AC_phoneme_c{i}.ave;
        haretsu.num = haretsu.num + 1;
    end
    %半母音
    if i >= 21 && i <= 24,
        hanboin.ave = hanboin.ave + AC_phoneme_c{i}.ave;
        hanboin.num = hanboin.num + 1;
    end
    %鼻音
    if i >= 25 && i <= 29,
        bion.ave = bion.ave + AC_phoneme_c{i}.ave;
        bion.num = bion.num + 1;
    end
end

AC_phoneme_shiinbetsu = [masatsu.ave/masatsu.num hasatsu.ave/hasatsu.num ...
    haretsu.ave/haretsu.num hanboin.ave/hanboin.num bion.ave/bion.num];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyboard

%%%%%プロット%%%%%
%ベクトルに変換
%母音
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

%子音
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
    
    %柴田音声で正規化
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

