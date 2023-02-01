function getcorrect(user_list, gender_index, output_dir, ofile_id, syn_type_list, mora_index)

if nargin < 6,
  mora_index = -1;
end

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

for ii = 1:size(user_list, 1),
  user = deblank(user_list(ii,:));
  
  correct_list_file = [output_dir '/' user gender '_correct' mora_index_str '.csv'];

  fid = fopen(correct_list_file, 'r');
  jj = 1;
  while 1
      tline = fgetl(fid);
      if ~isstr(tline), break, end
      if strcmp(tline(1:4), 'Type')
	  continue;
      end
      
%      A = sscanf(tline, '%s, %d, %d, %d, %d, %d, %d, %d, %d')
      commapos = strfind(tline, ',');
      commapos = [commapos length(tline)+1];
      for n = 1:size(commapos,2)-1,
	  val = str2double(tline(commapos(n)+1:commapos(n+1)-1));
	  if n == 1
	      word_num_correct_matrix(ii, jj) = val;
	  elseif n == 2
	      word_count_matrix(ii, jj) = val;
	  elseif n == 3
	      vowel_num_correct_matrix(ii, jj) = val;
	  elseif n == 4
	      vowel_count_matrix(ii, jj) = val;
	  elseif n == 5
	      consonant_num_correct_matrix(ii, jj) = val;
	  elseif n == 6
	      consonant_count_matrix(ii, jj) = val;
	  elseif n == 7
	      mora_num_correct_matrix(ii, jj) = val;
	  elseif n == 8
	      mora_count_matrix(ii, jj) = val;
	  end
      end

      jj = jj + 1;
  end
  fclose(fid);
end

correct_list_file = [output_dir '/' ofile_id '_correct' mora_index_str '.csv'];
fid = fopen(correct_list_file, 'w');
fprintf(fid, ['Type, Word correct, Word count, Vowel correct, ' ...
	      'Vowel count, Consonant correct, Consonant count, ' ...
	      'Mora correct, Mora count\n']);
for syn_type_index = 1:size(syn_type_list, 1),
    fprintf(fid, '%s, %d, %d, %d, %d, %d, %d, %d, %d\n', ...
      deblank(syn_type_list(syn_type_index, :)), ...
      sum(word_num_correct_matrix(:, syn_type_index)), ...
      sum(word_count_matrix(:, syn_type_index)), ...
      sum(vowel_num_correct_matrix(:, syn_type_index)), ...
      sum(vowel_count_matrix(:, syn_type_index)), ...
      sum(consonant_num_correct_matrix(:, syn_type_index)), ...
      sum(consonant_count_matrix(:, syn_type_index)), ...
      sum(mora_num_correct_matrix(:, syn_type_index)), ...
      sum(mora_count_matrix(:, syn_type_index)));
end

fclose(fid);

correct_list_file = [output_dir '/' ofile_id '_%correct' mora_index_str '.csv'];
fid = fopen(correct_list_file, 'w');
% keyboard
fprintf(fid, ['Type, Word %%correct, Vowel %%correct, ' ...
	      'Consonant %%correct, Mora %%correct\n']);
for syn_type_index = 1:size(syn_type_list, 1),
    fprintf(fid, '%s, %f, %f, %f, %f\n', ...
      deblank(syn_type_list(syn_type_index, :)), ...
      sum(word_num_correct_matrix(:, syn_type_index)) / sum(word_count_matrix(:, syn_type_index)), ...
      sum(vowel_num_correct_matrix(:, syn_type_index)) / sum(vowel_count_matrix(:, syn_type_index)), ...
      sum(consonant_num_correct_matrix(:, syn_type_index)) / sum(consonant_count_matrix(:, syn_type_index)), ...
      sum(mora_num_correct_matrix(:, syn_type_index)) / sum(mora_count_matrix(:, syn_type_index)));
end

fclose(fid);

% keyboard
