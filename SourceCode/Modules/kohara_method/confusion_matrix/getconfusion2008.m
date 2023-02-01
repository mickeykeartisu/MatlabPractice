function [confusion_matrix_consonant, confusion_matrix_consonant_normalized, consonantseq, ...
    word_num_correct, word_count, vowel_num_correct, vowel_count, ...
    consonant_num_correct, consonant_count, mora_num_correct, mora_count, ...
    confusion_matrix, confusion_matrix_normalized] ...
  = getconfusion2008(subjtestdir, answerfile, confusionfile, person_index, method_index, gender_index, confusionfile_normalized, ...
    confusionfile_phoneme, confusionfile_phoneme_normalized, mora_index)
% function [confusion_matrix_consonant, confusion_matrix_consonant_normalized, consonantseq, ...
%     word_num_correct, word_count, vowel_num_correct, vowel_count, ...
%     consonant_num_correct, consonant_count, mora_num_correct, mora_count, ...
%     confusion_matrix, confusion_matrix_normalized] ...
%   = getconfusion(subjtestdir, answerfile, confusionfile, person_index, method_index, gender_index, confusionfile_normalized, ...
%     confusionfile_phoneme, confusionfile_phoneme_normalized)
%  	gender_index: 0 = all, 1 = male, 2 = female

if nargin < 10,
  mora_index = -1;
end

nn_char = char('nn');
phonelist = char( ...
'a', 'i', 'u', 'e', 'o', 'n', ...
'ka', 'ki', 'ku', 'ke', 'ko', ...
'sa', 'shi', 'su', 'se', 'so', ...
'ta', 'chi', 'tsu', 'te', 'to', ...
'na', 'ni', 'nu', 'ne', 'no', ...
'ha', 'hi', 'fu', 'he', 'ho', ...
'ma', 'mi', 'mu', 'me', 'mo', ...
'ya', 'yu', 'yo', ...
'ra', 'ri', 'ru', 're', 'ro', ...
'wa', nn_char, ...
'ga', 'gi', 'gu', 'ge', 'go', ...
'za', 'zi', 'zu', 'ze', 'zo', ...
'da', 'di', 'du', 'de', 'do', ...
'ba', 'bi', 'bu', 'be', 'bo', ...
'pa', 'pi', 'pu', 'pe', 'po', ...
'kya', 'kyu', 'kyo', ...
'sya', 'syu', 'syo', ...
'cha', 'chu', 'cho', ...
'nya', 'nyu', 'nyo', ...
'hya', 'hyu', 'hyo', ...
'mya', 'myu', 'myo', ...
'rya', 'ryu', 'ryo', ...
'gya', 'gyu', 'gyo', ...
'zya', 'zyu', 'zyo', ...
'bya', 'byu', 'byo', ...
'pya', 'pyu', 'pyo', 'Q');

[confusion_matrix_consonant, confusion_matrix_consonant_normalized, consonantseq, ...
 word_num_correct, word_count, vowel_num_correct, vowel_count, ...
 consonant_num_correct, consonant_count, mora_num_correct, mora_count] ...
    = getconfusion(phonelist, subjtestdir, answerfile, confusionfile, person_index, method_index, gender_index, confusionfile_normalized, ...
			      confusionfile_phoneme, confusionfile_phoneme_normalized, mora_index);
