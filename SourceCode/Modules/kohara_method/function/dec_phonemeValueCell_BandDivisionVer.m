function [ phoneme_value ] = dec_phonemeValueCell_BandDivisionVer(phoneme_list,T)
%DEC_PHONEMEVALUECELL 入力された音素リストから、客観評価用のcell配列を宣言する関数(帯域ごとの動的特徴量を求めるVer)
%   詳細説明をここに記述

phoneme_value = cell(T,length(phoneme_list));
for i = 1:T,
    for ii = 1:length(phoneme_list),
        temp.phoneme = phoneme_list{ii};
        temp.sum = 0;
        temp.num = 0;
        temp.ave =0;
        phoneme_value{i,ii} = temp;
    end
end
end

