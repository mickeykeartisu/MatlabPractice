function getconfusionstat_kohara(data_dir, user_list, syn_type_list, gender_index, output_dir, ofile_id, mora_index)

if nargin < 7,
  mora_index = -1;
end

% syn_type_list = char( ...
%     '1set', ...
%     '2set', ...
%     '3set', ...
%     '4set', ...
%     '5set', ...
%     '6set');

%%Žg‚¤‰¹Œ¹‚É‚æ‚Á‚Ä•ÏX‚·‚é
% syn_type_list = char( ...
%     'normalization', ...
%     '0dB_16band_hanning0Hz_normalization',...
%     '3dB_16band_hanning0Hz_normalization',...
%     '6dB_16band_hanning0Hz_normalization');

% syn_type_list = char( ...
%     'normalization', ...
%     '3dB_16band_hanning0Hz_normalization',...
%     '3dB_16band_hanning3000Hz_normalization',...
%     'PeakHz16_lin_3');

% syn_type_list = char( ...
%     '3dB_16band_hanning500Hz_nolimit_normalization30dB', ...
%     '3dB_16band_hanning500Hz_Gainlimit9dB_normalization30dB',...
%     '6dB_16band_hanning500Hz_nolimit_normalization30dB',...
%     '6dB_16band_hanning500Hz_Gainlimit9dB_normalization30dB');

   

if mora_index > 0,
  mora_index_str = ['_mora' num2str(mora_index)];
else
  mora_index_str = '';
end

if gender_index == 1,
  gender = '_male';
elseif gender_index == 2,
  gender = '_female';
else
  gender = '';
end;
    
word_num_correct_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));
word_count_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));
vowel_num_correct_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));
vowel_count_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));
consonant_num_correct_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));
consonant_count_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));

mora_num_correct_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));
mora_count_matrix = zeros(size(user_list, 1), size(syn_type_list, 1));

for syn_type_index = 1:size(syn_type_list, 1),
  
  for ii = 1:size(user_list, 1),
    user = deblank(user_list(ii,:));
    
    words_file = [data_dir '/' user '_words.txt']
    confusion_file = [output_dir '/' user gender mora_index_str '_confusion_' deblank(syn_type_list(syn_type_index, :)) '.csv']
    confusion_file_normalized = [output_dir '/' user gender mora_index_str '_confusion_' deblank(syn_type_list(syn_type_index, :)) '_normalized.csv']

    confusion_file_phoneme = [output_dir '/' user gender mora_index_str '_confusion_phoneme_' deblank(syn_type_list(syn_type_index, :)) '.csv']
    confusion_file_phoneme_normalized = [output_dir '/' user gender mora_index_str '_confusion_phoneme_' deblank(syn_type_list(syn_type_index, :)) '_normalized.csv']
    
    [confusion_matrix, confusion_matrix_normalized, phonelist, ...
	word_num_correct, word_count, vowel_num_correct, vowel_count, ...
	consonant_num_correct, consonant_count, mora_num_correct, mora_count] ...
      = getconfusion([], data_dir, words_file, ...
          confusion_file, 0, syn_type_index, gender_index, ...
          confusion_file_normalized, confusion_file_phoneme, ...
	  confusion_file_phoneme_normalized, mora_index);

    word_num_correct_matrix(ii, syn_type_index) = word_num_correct;
    word_count_matrix(ii, syn_type_index) = word_count;
    vowel_num_correct_matrix(ii, syn_type_index) = vowel_num_correct;
    vowel_count_matrix(ii, syn_type_index) = vowel_count;
    consonant_num_correct_matrix(ii, syn_type_index) = consonant_num_correct;
    consonant_count_matrix(ii, syn_type_index) = consonant_count;
    mora_num_correct_matrix(ii, syn_type_index) = mora_num_correct;
    mora_count_matrix(ii, syn_type_index) = mora_count;
	
    if ii == 1,
      confusion_matrix_mean = 0 .* confusion_matrix;
      confusion_matrix_std = 0 .* confusion_matrix;
    end
    
    confusion_matrix_mean = confusion_matrix_mean + confusion_matrix;
    confusion_matrix_std  = confusion_matrix_std + confusion_matrix.^2;

  end

  confusion_matrix_mean = confusion_matrix_mean ./ size(user_list, 1);
  cmm_count = confusion_matrix_mean(:,end);
  cmm_count(cmm_count <= 0) = 1;
  confusion_matrix_mean_normalized = confusion_matrix_mean ...
    ./ (cmm_count * ones(1, size(confusion_matrix_mean, 2)));
  confusion_matrix_mean_normalized(:,end) = confusion_matrix_mean(:,end);

  confusion_matrix_std  = sqrt(confusion_matrix_std ./ size(user_list, 1) - confusion_matrix_mean.^2);

  writeconfusion(phonelist, [output_dir '/' ofile_id mora_index_str '_confusion_' deblank(syn_type_list(syn_type_index,:)) '_mean.csv'], confusion_matrix_mean);
  writeconfusion(phonelist, [output_dir '/' ofile_id mora_index_str '_confusion_' deblank(syn_type_list(syn_type_index,:)) '_mean_normalized.csv'], confusion_matrix_mean_normalized);
  writeconfusion(phonelist, [output_dir '/' ofile_id mora_index_str '_confusion_' deblank(syn_type_list(syn_type_index,:)) '_std.csv'], confusion_matrix_std);

end


for ii = 1:size(user_list, 1),
  user = deblank(user_list(ii,:));
  
  correct_list_file = [output_dir '/' user gender '_correct' mora_index_str '.csv'];
    
  fid = fopen(correct_list_file, 'w');
    
  for syn_type_index = 1:size(syn_type_list, 1),
    
    fprintf(fid, '%s, %d, %d, %d, %d, %d, %d, %d, %d\n', ...
      deblank(syn_type_list(syn_type_index, :)), ...
      word_num_correct_matrix(ii, syn_type_index), ...
      word_count_matrix(ii, syn_type_index), ...
      vowel_num_correct_matrix(ii, syn_type_index), ...
      vowel_count_matrix(ii, syn_type_index), ...
      consonant_num_correct_matrix(ii, syn_type_index), ...
      consonant_count_matrix(ii, syn_type_index), ...
      mora_num_correct_matrix(ii, syn_type_index), ...
      mora_count_matrix(ii, syn_type_index));
    
  end
  
  fclose(fid);
end

max_N = 4.0 * (vowel_count_matrix + consonant_count_matrix) ./ mora_count_matrix;
max_N_file = [output_dir '/' 'max_N' gender mora_index_str '.csv'];
fid = fopen(max_N_file, 'w');

ii = 1;
for jj = 1:size(vowel_count_matrix, 2),
  fprintf(fid, '%d %d %d %f\n', ...
    vowel_count_matrix(ii, jj), consonant_count_matrix(ii, jj), ...
    mora_count_matrix(ii, jj), max_N(ii, jj));
end

fclose(fid);
% keyboard
getcorrect(user_list, 0, output_dir, ofile_id, syn_type_list, mora_index);
