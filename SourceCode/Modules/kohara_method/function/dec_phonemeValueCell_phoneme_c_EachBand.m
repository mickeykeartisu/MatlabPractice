function [ A ] = dec_phonemeValueCell_phoneme_c_EachBand( phoneme_c_typelist, T )
%DEC_PHONEMEVALUECELL_MANNER_OF_ARTICULATION �e�����l���̓��I�����̑ш�ɂ��Ⴂ���m�F���邽�߂̔z���錾
%   �ڍא����������ɋL�q
A = cell(1,length(phoneme_c_typelist));

for i = 1:length(phoneme_c_typelist),
    A{i} = zeros(1,T);
end

% A.masatsu = zeros(1,T);
% A.hasatsu = zeros(1,T);
% A.haretsu = zeros(1,T);
% A.hanboin = zeros(1,T);
% A.bion = zeros(1,T);
end

