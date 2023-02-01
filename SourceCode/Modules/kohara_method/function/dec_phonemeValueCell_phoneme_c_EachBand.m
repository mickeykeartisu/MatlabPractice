function [ A ] = dec_phonemeValueCell_phoneme_c_EachBand( phoneme_c_typelist, T )
%DEC_PHONEMEVALUECELL_MANNER_OF_ARTICULATION 各調音様式の動的特徴の帯域による違いを確認するための配列を宣言
%   詳細説明をここに記述
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

