function [ phoneme_value ] = dec_phonemeValueCell(phoneme_list )
%DEC_PHONEMEVALUECELL ���͂��ꂽ���f���X�g����A�q�ϕ]���p��cell�z���錾����֐�
%   �ڍא����������ɋL�q

phoneme_value = cell(1,length(phoneme_list));
for ii = 1:length(phoneme_value),
    temp.phoneme = phoneme_list{ii};
    temp.sum = 0;
    temp.num = 0;
    temp.ave =0;
    phoneme_value{ii} = temp;
end

end

