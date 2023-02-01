%"get_DdeltaOfEachBand_phoneme"‚Å‹‚ß‚½Še‰¹º‚Ì‘Ñˆæ‚²‚Æ‚ÌDƒ¢‚ðŠî‚É‰¹‘f‚²‚Æ‚Ìƒ¢t‚ðŒvŽZ‚·‚é
%‚±‚±‚Åì¬‚µ‚½matƒtƒ@ƒCƒ‹‚ðŠî‚É"fig_D_deltaByEachPhoneme_EachBand"‚Å•\Ž¦‚·‚éD
clear all
s_num = 1;
e_num = 5;
setGain = 6;
Fs = 16000;
maxfreq = 500;
T = 80; %‘Ñˆæ•ªŠ„”

%’ñˆÄŽè–@‚Ìƒpƒ‰ƒƒ^
threshold_dB =[9];
ratio = Inf;
kneeWidth_dB = 6;
T_2 = 16;

inputDirName = '../voice_data/Ddelta_phoneme/';

inputName_AN = ['AN_DynamicFeature_BandDivision_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'];
inputName_AC = ['AC_DynamicFeature_BandDivision_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'];
inputName_AE = ['AE_DynamicFeature_BandDivision_' num2str(setGain) 'dB_' num2str(T_2) 'band_hanning' num2str(maxfreq) 'Hz_kneeWidth' num2str(kneeWidth_dB, '%02d') 'dB_Gainlimit' num2str(threshold_dB) 'dB_' num2str(s_num)...
    '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'];
inputName_AS = ['AS_DynamicFeature_BandDivision_'  num2str(setGain) 'dB_'  num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'];

load([inputDirName inputName_AN]);
load([inputDirName inputName_AC]);
load([inputDirName inputName_AE]);
load([inputDirName inputName_AS]);
% load([inputDirName 'phoneme by EachVoice_BandDivision_' num2str(setGain) 'dB_' num2str(s_num) '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz']);
%•Ï”AN_allDcep,AC_allDcep,AE_allDcep‚ð“Ç‚Ýž‚Þ

% keyboard

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
% phoneme_c_list = {'s', 'sh','f','z','h',...
%     'ts','ch',...
%     'k', 't','g', 'd', 'b', 'p',...
%     'w','r','j',...
%     'm','n'};
phoneme_etc_list = {'sp', 'cl', 'q'};


masatsu_list = {'s', 'sh','f','z','h','hy'};
hasatsu_list = {'ts','ch'};
haretsu_list = {'k', 't','g', 'd', 'b', 'p', 'ky','gy', 'by', 'py', 'dy'};
hanboin_list = {'w','r','j','ry'};
bion_list = {'m','n','my','ny','N'};

% masatsu_list = {'s', 'sh','f','z','h'};
% hasatsu_list = {'ts','ch'};
% haretsu_list = {'k', 't','g', 'd', 'b', 'p'};
% hanboin_list = {'w','r','j'};
% bion_list = {'m','n'};


phoneme_c_typelist = {'–€ŽC','”jŽC','”j—ô','”¼•ê‰¹','•@‰¹'};
phoneme_c_typelist_r = {'masatsu', 'hasatsu','haretsu','hanboin','bion'};
phoneme_c_typelist_e = {'Fricative','Affricate','Plosive','Semivowel','Nasal'};

%ŒvŽZŒ‹‰Ê‚ðŠi”[‚·‚écell”z—ñ‚ð’è‹`
AN_phoneme_v = dec_phonemeValueCell_BandDivisionVer(phoneme_v_list,T);
AN_phoneme_c = dec_phonemeValueCell_BandDivisionVer(phoneme_c_list,T);
% AN_phoneme_nv = dec_phonemeValueCell_BandDivisionVer(phoneme_nv_list,T);
% AN_phoneme_etc = dec_phonemeValueCell_BandDivisionVer(phoneme_etc_list,T);
AN.c_articulation = dec_phonemeValueCell_phoneme_c_EachBand(phoneme_c_typelist,T);

AC_phoneme_v = dec_phonemeValueCell_BandDivisionVer(phoneme_v_list,T);
AC_phoneme_c = dec_phonemeValueCell_BandDivisionVer(phoneme_c_list,T);
% AC_phoneme_nv = dec_phonemeValueCell_BandDivisionVer(phoneme_nv_list,T);
% AC_phoneme_etc = dec_phonemeValueCell_BandDivisionVer(phoneme_etc_list,T);
AC.c_articulation = dec_phonemeValueCell_phoneme_c_EachBand(phoneme_c_typelist,T);

AE_phoneme_v = dec_phonemeValueCell_BandDivisionVer(phoneme_v_list,T);
AE_phoneme_c = dec_phonemeValueCell_BandDivisionVer(phoneme_c_list,T);
% AE_phoneme_nv = dec_phonemeValueCell_BandDivisionVer(phoneme_nv_list,T);
% AE_phoneme_etc = dec_phonemeValueCell_BandDivisionVer(phoneme_etc_list,T);
AE.c_articulation = dec_phonemeValueCell_phoneme_c_EachBand(phoneme_c_typelist,T);

AS_phoneme_v = dec_phonemeValueCell_BandDivisionVer(phoneme_v_list,T);
AS_phoneme_c = dec_phonemeValueCell_BandDivisionVer(phoneme_c_list,T);
% AS_phoneme_nv = dec_phonemeValueCell_BandDivisionVer(phoneme_nv_list,T);
% AS_phoneme_etc = dec_phonemeValueCell_BandDivisionVer(phoneme_etc_list,T);
AS.c_articulation = dec_phonemeValueCell_phoneme_c_EachBand(phoneme_c_typelist,T);

for n = s_num:e_num,
    %•ê‰¹—p
    for t = 1:T,%‘Ñˆæ   
        for i = 1:length(phoneme_v_list),
            %’Êí‰¹º
            for ii =  1:length(AN_allDcep{t,n}),
                if strcmp(AN_allDcep{t,n}(ii).phoneme,phoneme_v_list{i}) == 1,
    %             if strcmp(AN_allDcep{n}(ii).phoneme,phoneme_v_list{i}) == 1 || strcmp(AN_allDcep{n}(ii).phoneme,[phoneme_v_list{i} ':']) == 1,
                    AN_phoneme_v{t,i}.sum = AN_phoneme_v{t,i}.sum + AN_allDcep{t,n}(ii).dcep;
                    AN_phoneme_v{t,i}.num = AN_phoneme_v{t,i}.num + 1;
                end
            end
            %–¾—Ä‰¹º
            for ii =  1:length(AC_allDcep{t,n}),
                if strcmp(AC_allDcep{t,n}(ii).phoneme,phoneme_v_list{i}) == 1,
                    AC_phoneme_v{t,i}.sum = AC_phoneme_v{t,i}.sum + AC_allDcep{t,n}(ii).dcep;
                    AC_phoneme_v{t,i}.num = AC_phoneme_v{t,i}.num + 1;
                end
            end
            %‹­’²‰¹º
            for ii =  1:length(AE_allDcep{t,n}),
                if strcmp(AE_allDcep{t,n}(ii).phoneme,phoneme_v_list{i}) == 1,
                    AE_phoneme_v{t,i}.sum = AE_phoneme_v{t,i}.sum + AE_allDcep{t,n}(ii).dcep;
                    AE_phoneme_v{t,i}.num = AE_phoneme_v{t,i}.num + 1;
                end
            end
            %ŽÄ“c‰¹º
            for ii =  1:length(AS_allDcep{t,n}),
                if strcmp(AS_allDcep{t,n}(ii).phoneme,phoneme_v_list{i}) == 1,
                    AS_phoneme_v{t,i}.sum = AS_phoneme_v{t,i}.sum + AS_allDcep{t,n}(ii).dcep;
                    AS_phoneme_v{t,i}.num = AS_phoneme_v{t,i}.num + 1;
                end
            end
        end

        %Žq‰¹—p
        for i = 1:length(phoneme_c_list),
            %’Êí‰¹º
            for ii =  1:length(AN_allDcep{t,n}),
                if strcmp(AN_allDcep{t,n}(ii).phoneme,phoneme_c_list{i}) == 1,
                    AN_phoneme_c{t,i}.sum = AN_phoneme_c{t,i}.sum + AN_allDcep{t,n}(ii).dcep;
                    AN_phoneme_c{t,i}.num = AN_phoneme_c{t,i}.num + 1;
                end
            end
    %       %–¾—Ä‰¹º
            for ii =  1:length(AC_allDcep{t,n}),
                if strcmp(AC_allDcep{t,n}(ii).phoneme,phoneme_c_list{i}) == 1,
                    AC_phoneme_c{t,i}.sum = AC_phoneme_c{t,i}.sum + AC_allDcep{t,n}(ii).dcep;
                    AC_phoneme_c{t,i}.num = AC_phoneme_c{t,i}.num + 1;
                end
            end
            %‹­’²‰¹º
            for ii =  1:length(AE_allDcep{t,n}),
                if strcmp(AE_allDcep{t,n}(ii).phoneme,phoneme_c_list{i}) == 1,
                    AE_phoneme_c{t,i}.sum = AE_phoneme_c{t,i}.sum + AE_allDcep{t,n}(ii).dcep;
                    AE_phoneme_c{t,i}.num = AE_phoneme_c{t,i}.num + 1;
                end
            end
            %ŽÄ“c‰¹º
            for ii =  1:length(AS_allDcep{t,n}),
                if strcmp(AS_allDcep{t,n}(ii).phoneme,phoneme_c_list{i}) == 1,
                    AS_phoneme_c{t,i}.sum = AS_phoneme_c{t,i}.sum + AS_allDcep{t,n}(ii).dcep;
                    AS_phoneme_c{t,i}.num = AS_phoneme_c{t,i}.num + 1;
                end
            end
        end
%     %–€ŽC‰¹
%     for i = 1:length(masatsu_list),
%     end
    end
end

%%%%%•½‹Ï‚ð‹‚ß‚é%%%%%
%•ê‰¹
for i  = 1:length(phoneme_v_list);
    for t = 1:T,
        %’Êí‰¹º
        if AN_phoneme_v{t,i}.num ~= 0,
            AN_phoneme_v{t,i}.ave = AN_phoneme_v{t,i}.sum/AN_phoneme_v{t,i}.num;
        end
        %–¾—Ä‰¹º
        if AC_phoneme_v{t,i}.num ~= 0,
            AC_phoneme_v{t,i}.ave = AC_phoneme_v{t,i}.sum/AC_phoneme_v{t,i}.num;
        end
        %‹­’²‰¹º
        if AE_phoneme_v{t,i}.num ~= 0,
            AE_phoneme_v{t,i}.ave = AE_phoneme_v{t,i}.sum/AE_phoneme_v{t,i}.num;
        end
        %ŽÄ“c‰¹º
        if AS_phoneme_v{t,i}.num ~= 0,
            AS_phoneme_v{t,i}.ave = AS_phoneme_v{t,i}.sum/AS_phoneme_v{t,i}.num;
        end
    end
end
%Žq‰¹
for i  = 1:length(phoneme_c_list);
    for t = 1:T,
        %’Êí‰¹º
        if AN_phoneme_c{t,i}.num ~= 0,
            AN_phoneme_c{t,i}.ave = AN_phoneme_c{t,i}.sum/AN_phoneme_c{t,i}.num;
        end
        %–¾—Ä‰¹º
        if AC_phoneme_c{t,i}.num ~= 0,
            AC_phoneme_c{t,i}.ave = AC_phoneme_c{t,i}.sum/AC_phoneme_c{t,i}.num;
        end
        %‹­’²‰¹º
        if AE_phoneme_c{t,i}.num ~= 0,
            AE_phoneme_c{t,i}.ave = AE_phoneme_c{t,i}.sum/AE_phoneme_c{t,i}.num;
        end
        %ŽÄ“c‰¹º
        if AS_phoneme_c{t,i}.num ~= 0,
            AS_phoneme_c{t,i}.ave = AS_phoneme_c{t,i}.sum/AS_phoneme_c{t,i}.num;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%’²‰¹—lŽ®‚²‚Æ‚É•ª‚¯‚é%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AN_phoneme_shiinbetsu = cell(1,T);
AC_phoneme_shiinbetsu = cell(1,T);
AE_phoneme_shiinbetsu = cell(1,T);
AS_phoneme_shiinbetsu = cell(1,T);
masatsu = cell(T,1);
hasatsu = cell(T,1);
haretsu = cell(T,1);
hanboin = cell(T,1);
bion = cell(T,1);
%%’Êí‰¹º
for t=1:T,
    masatsu{t}.ave = 0;
    hasatsu{t}.ave = 0;
    haretsu{t}.ave = 0;
    hanboin{t}.ave = 0;
    bion{t}.ave = 0;
    masatsu{t}.num = 0;
    hasatsu{t}.num = 0;
    haretsu{t}.num = 0;
    hanboin{t}.num = 0;
    bion{t}.num = 0;
    
    for i  = 1:length(phoneme_c_list);
        %–€ŽC‰¹
        if i >= 1 && i <= 6,
            masatsu{t}.ave = masatsu{t}.ave + AN_phoneme_c{t,i}.ave;
            masatsu{t}.num = masatsu{t}.num + 1;
        end
        %”jŽC‰¹
        if i >= 7 && i <= 8,
            hasatsu{t}.ave = hasatsu{t}.ave + AN_phoneme_c{t,i}.ave;
            hasatsu{t}.num = hasatsu{t}.num + 1;
        end
        %”j—ô‰¹
        if i >= 9 && i <= 20,
            haretsu{t}.ave = haretsu{t}.ave + AN_phoneme_c{t,i}.ave;
            haretsu{t}.num = haretsu{t}.num + 1;
        end
        %”¼•ê‰¹
        if i >= 21 && i <= 24,
            hanboin{t}.ave = hanboin{t}.ave + AN_phoneme_c{t,i}.ave;
            hanboin{t}.num = hanboin{t}.num + 1;
        end
        %•@‰¹
        if i >= 25 && i <= 29,
            bion{t}.ave = bion{t}.ave + AN_phoneme_c{t,i}.ave;
            bion{t}.num = bion{t}.num + 1;
        end
    end
    AN_phoneme_shiinbetsu{t} = [masatsu{t}.ave/masatsu{t}.num hasatsu{t}.ave/hasatsu{t}.num ...
    haretsu{t}.ave/haretsu{t}.num hanboin{t}.ave/hanboin{t}.num bion{t}.ave/bion{t}.num];
    
    for i = 1:length(phoneme_c_typelist),
        AN.c_articulation{i}(t) = AN_phoneme_shiinbetsu{t}(i);
    end

%     AN.masatsu(1,t) =  AN_phoneme_shiinbetsu{t}(1);
%     AN.hasatsu(1,t) =  AN_phoneme_shiinbetsu{t}(2);
%     AN.haretsu(1,t) =  AN_phoneme_shiinbetsu{t}(3);
%     AN.hanboin(1,t) =  AN_phoneme_shiinbetsu{t}(4);
%     AN.bion(1,t) =  AN_phoneme_shiinbetsu{t}(5);
end

% keyboard

%‹­’²‰¹º‚ð•ª‚¯‚é
for t=1:T,
    masatsu{t}.ave = 0;
    hasatsu{t}.ave = 0;
    haretsu{t}.ave = 0;
    hanboin{t}.ave = 0;
    bion{t}.ave = 0;
    masatsu{t}.num = 0;
    hasatsu{t}.num = 0;
    haretsu{t}.num = 0;
    hanboin{t}.num = 0;
    bion{t}.num = 0;
    for i  = 1:length(phoneme_c_list);
        %–€ŽC‰¹
        if i >= 1 && i <= 6,
            masatsu{t}.ave = masatsu{t}.ave + AE_phoneme_c{t,i}.ave;
            masatsu{t}.num = masatsu{t}.num + 1;
        end
        %”jŽC‰¹
        if i >= 7 && i <= 8,
            hasatsu{t}.ave = hasatsu{t}.ave + AE_phoneme_c{t,i}.ave;
            hasatsu{t}.num = hasatsu{t}.num + 1;
        end
        %”j—ô‰¹
        if i >= 9 && i <= 20,
            haretsu{t}.ave = haretsu{t}.ave + AE_phoneme_c{t,i}.ave;
            haretsu{t}.num = haretsu{t}.num + 1;
        end
        %”¼•ê‰¹
        if i >= 21 && i <= 24,
            hanboin{t}.ave = hanboin{t}.ave + AE_phoneme_c{t,i}.ave;
            hanboin{t}.num = hanboin{t}.num + 1;
        end
        %•@‰¹
        if i >= 25 && i <= 29,
            bion{t}.ave = bion{t}.ave + AE_phoneme_c{t,i}.ave;
            bion{t}.num = bion{t}.num + 1;
        end
    end
    AE_phoneme_shiinbetsu{t} = [masatsu{t}.ave/masatsu{t}.num hasatsu{t}.ave/hasatsu{t}.num ...
    haretsu{t}.ave/haretsu{t}.num hanboin{t}.ave/hanboin{t}.num bion{t}.ave/bion{t}.num];
    
    for i = 1:length(phoneme_c_typelist),
        AE.c_articulation{i}(t) = AE_phoneme_shiinbetsu{t}(i);
    end

end



%ŽÄ“c‰¹º‚ð•ª‚¯‚é
for t=1:T,
    masatsu{t}.ave = 0;
    hasatsu{t}.ave = 0;
    haretsu{t}.ave = 0;
    hanboin{t}.ave = 0;
    bion{t}.ave = 0;
    masatsu{t}.num = 0;
    hasatsu{t}.num = 0;
    haretsu{t}.num = 0;
    hanboin{t}.num = 0;
    bion{t}.num = 0;
    for i  = 1:length(phoneme_c_list);
        %–€ŽC‰¹
        if i >= 1 && i <= 6,
            masatsu{t}.ave = masatsu{t}.ave + AS_phoneme_c{t,i}.ave;
            masatsu{t}.num = masatsu{t}.num + 1;
        end
        %”jŽC‰¹
        if i >= 7 && i <= 8,
            hasatsu{t}.ave = hasatsu{t}.ave + AS_phoneme_c{t,i}.ave;
            hasatsu{t}.num = hasatsu{t}.num + 1;
        end
        %”j—ô‰¹
        if i >= 9 && i <= 20,
            haretsu{t}.ave = haretsu{t}.ave + AS_phoneme_c{t,i}.ave;
            haretsu{t}.num = haretsu{t}.num + 1;
        end
        %”¼•ê‰¹
        if i >= 21 && i <= 24,
            hanboin{t}.ave = hanboin{t}.ave + AS_phoneme_c{t,i}.ave;
            hanboin{t}.num = hanboin{t}.num + 1;
        end
        %•@‰¹
        if i >= 25 && i <= 29,
            bion{t}.ave = bion{t}.ave + AS_phoneme_c{t,i}.ave;
            bion{t}.num = bion{t}.num + 1;
        end      
    end
    AS_phoneme_shiinbetsu{t} = [masatsu{t}.ave/masatsu{t}.num hasatsu{t}.ave/hasatsu{t}.num ...
        haretsu{t}.ave/haretsu{t}.num hanboin{t}.ave/hanboin{t}.num bion{t}.ave/bion{t}.num];

    for i = 1:length(phoneme_c_typelist),
        AS.c_articulation{i}(t) = AS_phoneme_shiinbetsu{t}(i);
    end
end

%–¾—Ä‰¹º‚ð•ª‚¯‚é
for t=1:T,
    masatsu{t}.ave = 0;
    hasatsu{t}.ave = 0;
    haretsu{t}.ave = 0;
    hanboin{t}.ave = 0;
    bion{t}.ave = 0;
    masatsu{t}.num = 0;
    hasatsu{t}.num = 0;
    haretsu{t}.num = 0;
    hanboin{t}.num = 0;
    bion{t}.num = 0;
    for i  = 1:length(phoneme_c_list);
            %–€ŽC‰¹
        if i >= 1 && i <= 6,
            masatsu{t}.ave = masatsu{t}.ave + AC_phoneme_c{t,i}.ave;
            masatsu{t}.num = masatsu{t}.num + 1;
        end
        %”jŽC‰¹
        if i >= 7 && i <= 8,
            hasatsu{t}.ave = hasatsu{t}.ave + AC_phoneme_c{t,i}.ave;
            hasatsu{t}.num = hasatsu{t}.num + 1;
        end
        %”j—ô‰¹
        if i >= 9 && i <= 20,
            haretsu{t}.ave = haretsu{t}.ave + AC_phoneme_c{t,i}.ave;
            haretsu{t}.num = haretsu{t}.num + 1;
        end
        %”¼•ê‰¹
        if i >= 21 && i <= 24,
            hanboin{t}.ave = hanboin{t}.ave + AC_phoneme_c{t,i}.ave;
            hanboin{t}.num = hanboin{t}.num + 1;
        end
        %•@‰¹
        if i >= 25 && i <= 29,
            bion{t}.ave = bion{t}.ave + AC_phoneme_c{t,i}.ave;
            bion{t}.num = bion{t}.num + 1;
        end
    end
    AC_phoneme_shiinbetsu{t} = [masatsu{t}.ave/masatsu{t}.num hasatsu{t}.ave/hasatsu{t}.num ...
    haretsu{t}.ave/haretsu{t}.num hanboin{t}.ave/hanboin{t}.num bion{t}.ave/bion{t}.num];

    for i = 1:length(phoneme_c_typelist),
        AC.c_articulation{i}(t) = AC_phoneme_shiinbetsu{t}(i);
    end
end

% save([inputDirName 'phoneme by EachVoice_BandDivision_'  num2str(setGain) 'dB_'  num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed'],...
%     'AN_phoneme_v','AN_phoneme_c','AN','AN_phoneme_shiinbetsu',...
%     'AC_phoneme_v','AC_phoneme_c','AC','AC_phoneme_shiinbetsu',...
%     'AE_phoneme_v','AE_phoneme_c','AE','AE_phoneme_shiinbetsu',...
%     'AS_phoneme_v','AS_phoneme_c','AS','AS_phoneme_shiinbetsu')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyboard

%%%%%ƒvƒƒbƒg%%%%%
%ƒxƒNƒgƒ‹‚É•ÏŠ·
%•ê‰¹
AN_phoneme_v_bar = zeros(T,length(phoneme_v_list));
AC_phoneme_v_bar = zeros(T,length(phoneme_v_list));
AE_phoneme_v_bar = zeros(T,length(phoneme_v_list));
AS_phoneme_v_bar = zeros(T,length(phoneme_v_list));
for t = 1:T,
    for i = 1:length(phoneme_v_list),
        AN_phoneme_v_bar(t,i) = AN_phoneme_v{t,i}.ave;
        AC_phoneme_v_bar(t,i) = AC_phoneme_v{t,i}.ave;
        AE_phoneme_v_bar(t,i) = AE_phoneme_v{t,i}.ave;
        AS_phoneme_v_bar(t,i) = AS_phoneme_v{t,i}.ave;
    end
end

%Žq‰¹
AN_phoneme_c_bar = zeros(T,length(phoneme_c_list));
AC_phoneme_c_bar = zeros(T,length(phoneme_c_list));
AE_phoneme_c_bar = zeros(T,length(phoneme_c_list));
AS_phoneme_c_bar = zeros(T,length(phoneme_c_list));
% AN_phoneme_c_bar_norm = zeros(T,length(phoneme_c_list));
% AE_phoneme_c_bar_norm = zeros(T,length(phoneme_c_list));
% AS_phoneme_c_bar_norm = zeros(T,length(phoneme_c_list));
for t = 1:T,
    for i = 1:length(phoneme_c_list),
        AN_phoneme_c_bar(t,i) = AN_phoneme_c{t,i}.ave;
        AC_phoneme_c_bar(t,i) = AC_phoneme_c{t,i}.ave;
        AE_phoneme_c_bar(t,i) = AE_phoneme_c{t,i}.ave;
        AS_phoneme_c_bar(t,i) = AS_phoneme_c{t,i}.ave;
    end
end

%%‘Ñˆæ‚²‚Æ‚Ì•ê‰¹EŽq‰¹‚Ì“®“I“Á’¥‚ðŽZo
AN.allV = mean(AN_phoneme_v_bar,2)';
AC.allV = mean(AC_phoneme_v_bar,2)';
AE.allV = mean(AE_phoneme_v_bar,2)';
AS.allV = mean(AS_phoneme_v_bar,2)';
% AE0.allV = mean(AE0_phoneme_v_bar,2)';

AN.allC = zeros(1,T);
AC.allC= zeros(1,T);
AE.allC= zeros(1,T);
AS.allC= zeros(1,T);
AE0.allC= zeros(1,T);
for i = 1:length(phoneme_c_typelist),
    AN.allC = AN.allC+AN.c_articulation{i};
    AC.allC = AC.allC+AC.c_articulation{i};
    AE.allC = AE.allC+AE.c_articulation{i};
    AS.allC = AS.allC+AS.c_articulation{i};
%     AE0.allC = AE0.allC+AE0.c{i};
end
% keyboard
AN.allC = AN.allC/length(phoneme_c_typelist);
AC.allC = AC.allC/length(phoneme_c_typelist);
AE.allC = AE.allC/length(phoneme_c_typelist);
AS.allC = AS.allC/length(phoneme_c_typelist);
% AE0.allC = AE0.allC/length(phoneme_c_typelist);


%%‘Ñˆæ‚²‚Æ‚Ì“®“I“Á’¥‚©‚ç‰¹º‘S‘Ì‚Ì’²‰¹—pŽ®‚²‚Æ‚Ì“®“I“Á’¥—Ê‚ðŽZo
AN.c_articulation_allBand = zeros(1,length(phoneme_c_typelist));
AC.c_articulation_allBand = zeros(1,length(phoneme_c_typelist));
AE.c_articulation_allBand = zeros(1,length(phoneme_c_typelist));
AS.c_articulation_allBand = zeros(1,length(phoneme_c_typelist));
for i = 1:length(phoneme_c_typelist),
    AN.c_articulation_allBand(i) = mean(AN.c_articulation{i});
    AC.c_articulation_allBand(i) = mean(AC.c_articulation{i});
    AE.c_articulation_allBand(i) = mean(AE.c_articulation{i});
    AS.c_articulation_allBand(i) = mean(AS.c_articulation{i});
%     AE0.allC = AE0.allC+AE0.c{i};
end


% outputName = {'AN','AC','AE','AS'};


save([inputDirName inputName_AN '_Phoneme'],...
    'AN_phoneme_v','AN_phoneme_c','AN','AN_phoneme_shiinbetsu',...
    'AN_phoneme_v_bar','AN_phoneme_c_bar')

save([inputDirName inputName_AC '_Phoneme'],...
    'AC_phoneme_v','AC_phoneme_c','AC','AC_phoneme_shiinbetsu',...
    'AC_phoneme_v_bar','AC_phoneme_c_bar')

save([inputDirName inputName_AE '_Phoneme'],...
    'AE_phoneme_v','AE_phoneme_c','AE','AE_phoneme_shiinbetsu',...
    'AE_phoneme_v_bar','AE_phoneme_c_bar')

save([inputDirName inputName_AS '_Phoneme'],...
    'AS_phoneme_v','AS_phoneme_c','AS','AS_phoneme_shiinbetsu',...
    'AS_phoneme_v_bar','AS_phoneme_c_bar')


% save([inputDirName 'phoneme by EachVoice_BandDivision_'  num2str(setGain) 'dB_'  num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz_Processed'],...
%     'AN_phoneme_v','AN_phoneme_c','AN','AN_phoneme_shiinbetsu',...
%     'AC_phoneme_v','AC_phoneme_c','AC','AC_phoneme_shiinbetsu',...
%     'AE_phoneme_v','AE_phoneme_c','AE','AE_phoneme_shiinbetsu',...
%     'AS_phoneme_v','AS_phoneme_c','AS','AS_phoneme_shiinbetsu',...
%     'AN_phoneme_v_bar','AN_phoneme_c_bar','AN_phoneme_c_bar_norm',...
%     'AC_phoneme_v_bar','AC_phoneme_c_bar',...
%     'AE_phoneme_v_bar','AE_phoneme_c_bar','AE_phoneme_c_bar_norm',...
%     'AS_phoneme_v_bar','AS_phoneme_c_bar')



% AE0_phoneme_v = AE_phoneme_v;
% AE0_phoneme_c = AE_phoneme_c;
% AE0 = AE;
% AE0_phoneme_shiinbetsu = AE_phoneme_shiinbetsu;
% AE0_phoneme_v_bar = AE_phoneme_v_bar;
% AE0_phoneme_c_bar = AE_phoneme_c_bar;
% AE0_phoneme_c_bar_norm = AE_phoneme_c_bar_norm;
% 
% save([inputDirName 'AE_ori_DynamicFeature_BandDivision_'  num2str(setGain) 'dB_'  num2str(s_num)...
%     '-' num2str(e_num) '_' num2str(T) 'Band_maxfreq' num2str(maxfreq) 'Hz'],...
%     'AE0_phoneme_v','AE0_phoneme_c','AE0','AE0_phoneme_shiinbetsu',...
%     'AE0_phoneme_v_bar','AE0_phoneme_c_bar','AE0_phoneme_c_bar_norm')


%%ƒvƒƒbƒgXŽ²—p
%‘Ñˆæ”äŠr—p
% Band_bar = zeros(1,T);
% for t = 1:T,
%     Band_bar(t) = {[num2str(Band_Hz * t) 'Hz']};
% end

% scrsz = get(0,'ScreenSize');

% ’Êí‰¹ºAŽÄ“c‰¹ºA‹­’²‰¹º‚Ì‰¹‘f‚²‚Æ‚Ì”äŠri•ê‰¹j
% figure
% bar([AN_phoneme_v_bar;AS_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% % ’Êí‰¹ºAŽÄ“c‰¹ºA‹­’²‰¹º‚Ì‰¹‘f‚²‚Æ‚Ì”äŠriŽq‰¹j
% figure
% bar([AN_phoneme_c_bar;AS_phoneme_c_bar;AE_phoneme_c_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% % ’Êí‰¹ºA–¾—Ä‰¹ºA‹­’²‰¹º‚Ì‰¹‘f‚²‚Æ‚Ì”äŠri•ê‰¹j
% figure
% bar([AN_phoneme_v_bar;AC_phoneme_v_bar;AE_phoneme_v_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_v_list, 'XTick',1:length(AN_phoneme_v_bar), 'XLim',[0,length(AN_phoneme_v_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)
% 
% % ’Êí‰¹ºA–¾—Ä‰¹ºA‹­’²‰¹º‚Ì‰¹‘f‚²‚Æ‚Ì”äŠriŽq‰¹j
% figure
% bar([AN_phoneme_c_bar;AC_phoneme_c_bar;AE_phoneme_c_bar]','grouped')
% set(gca, 'XTickLabel',phoneme_c_list, 'XTick',1:length(AN_phoneme_c_bar), 'XLim',[0,length(AN_phoneme_c_bar)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Phoneme','D \Delta (t) [dB/msec]','', 14)

% ŽÄ“c‰¹ºA‹­’²‰¹º‚Ì’²‰¹—lŽ®‚²‚Æ‚Ì”äŠri’Êí‰¹º‚Å³‹K‰»j
% figure
% bar([AS_phoneme_shiinbetsu./AN_phoneme_shiinbetsu;AE_phoneme_shiinbetsu./AN_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Normarized dynamic feature [dB/msec]','', 14)

% ’Êí‰¹ºAŽÄ“c‰¹ºA‹­’²‰¹º‚Ì’²‰¹—lŽ®‚²‚Æ‚Ì”äŠr

% figure
% bar([AN_phoneme_shiinbetsu;AS_phoneme_shiinbetsu;AE_phoneme_shiinbetsu]','grouped')
% set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(AS_phoneme_shiinbetsu), 'XLim',[0,length(AS_phoneme_shiinbetsu)+1]);
% set( gca, 'FontName','MS UI Gothic','FontSize',12);
% setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
% title([])

% for t = 1:T,
% % ’Êí‰¹ºA–¾—Ä‰¹ºA‹­’²‰¹º‚Ì’²‰¹—lŽ®‚²‚Æ‚Ì”äŠr
%     figure('Name',[num2str(t)],'NumberTitle','off', 'Position',[0.1 0.1 3*scrsz(3)/5 scrsz(4)/2])
%     bar([AN_phoneme_shiinbetsu{t};AC_phoneme_shiinbetsu{t};AE_phoneme_shiinbetsu{t};AS_phoneme_shiinbetsu{t}]','grouped')
%     set(gca, 'XTickLabel',phoneme_c_typelist, 'XTick',1:length(phoneme_c_typelist), 'XLim',[0,length(phoneme_c_typelist)+1],'YLim',[0,1.0]);
%     set( gca, 'FontName','MS UI Gothic','FontSize',12);
%     setLabel('Manner of articulation','Dynamic feature [dB/msec]','', 14)
%     if t == 1,
%         title(['Band of 1Hz - ' num2str(t*Band_Hz) 'Hz']);
%     else
%         title(['Band of ' num2str((t-1)*Band_Hz) 'Hz - ' num2str(t*Band_Hz) 'Hz']);
%     end
%     legend('Normal Speech','Clear Speech','Kohara method','Shibata method');
%     outputName = ['ANACAEAS_' 'Band of ' num2str((t-1)*Band_Hz) 'Hz - ' num2str(t*Band_Hz) 'Hz_' num2str(s_num) '-' num2str(e_num) '_maxfreq' num2str(maxfreq) 'Hz'];
%     saveas(gcf,[outputDirName 'By EachBand/' outputName '.emf']);
% end

% for i = 1:length(phoneme_c_typelist), 
%     figure('Name',[phoneme_c_typelist_r{i}],'NumberTitle','off', 'Position',[0.1 0.1 3.7*scrsz(3)/5 scrsz(4)/2])
%     bar([AN.c{i};AC.c{i};AE.c{i};AS.c{i}]','grouped')
%     set(gca, 'XTickLabel',Band_bar, 'XTick',1:length(Band_bar), 'XLim',[0,length(Band_bar)+1],'YLim',[0,1.0]);
%     set( gca, 'FontName','MS UI Gothic','FontSize',12);
%     setLabel('Band','Dynamic feature [dB/msec]','', 14)
%     legend('Normal Speech','Clear Speech','Kohara method','Shibata method');
%     title(phoneme_c_typelist(i));
%     outputName = ['ANACAEAS_' phoneme_c_typelist_r{i} '_' num2str(s_num) '-' num2str(e_num) '_maxfreq' num2str(maxfreq) 'Hz'];
%     saveas(gcf,[outputDirName 'By manner of articulation/' outputName '.emf']);
% end

% for i = 1:length(phoneme_v_list), 
%     figure('Name',['/ ' phoneme_v_list{i} ' /'],'NumberTitle','off', 'Position',[0.1 0.1 3.7*scrsz(3)/5 scrsz(4)/2])
%     bar([AN_phoneme_v_bar(:,i)';AC_phoneme_v_bar(:,i)';AE_phoneme_v_bar(:,i)';AS_phoneme_v_bar(:,i)']','grouped')
%     set(gca, 'XTickLabel',Band_bar, 'XTick',1:length(Band_bar), 'XLim',[0,length(Band_bar)+1],'YLim',[0,1.0]);
%     set( gca, 'FontName','MS UI Gothic','FontSize',12);
%     setLabel('Band','Dynamic feature [dB/msec]','', 14)
%     legend('Normal Speech','Clear Speech','Kohara method','Shibata method');
%     title(['/ ' phoneme_v_list{i} ' /']);
%     outputName = ['ANACAEAS_' phoneme_v_list{i} '_' num2str(s_num) '-' num2str(e_num) '_maxfreq' num2str(maxfreq) 'Hz'];
%     saveas(gcf,[outputDirName 'By phoneme_v/' outputName '.emf']);
% end


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

