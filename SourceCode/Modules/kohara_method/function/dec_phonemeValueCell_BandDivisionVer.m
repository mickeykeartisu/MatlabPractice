function [ phoneme_value ] = dec_phonemeValueCell_BandDivisionVer(phoneme_list,T)
%DEC_PHONEMEVALUECELL ���͂��ꂽ���f���X�g����A�q�ϕ]���p��cell�z���錾����֐�(�ш悲�Ƃ̓��I�����ʂ����߂�Ver)
%   �ڍא����������ɋL�q

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

