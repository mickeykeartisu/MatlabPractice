function [ phoneme_value ] = dec_phonemeValueCell(phoneme_list )
%DEC_PHONEMEVALUECELL 入力された音素リストから、客観評価用のcell配列を宣言する関数
%   詳細説明をここに記述

phoneme_value = cell(1,length(phoneme_list));
for ii = 1:length(phoneme_value),
    temp.phoneme = phoneme_list{ii};
    temp.sum = 0;
    temp.num = 0;
    temp.ave =0;
    phoneme_value{ii} = temp;
end

end

