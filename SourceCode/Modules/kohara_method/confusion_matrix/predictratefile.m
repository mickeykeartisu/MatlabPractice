function [N, dist, predicted_rate_list, ...
  word_rate_list, vowel_rate_list, consonant_rate_list, vc_ratio_list, mora_rate_list, max_N_list,...
  word_count, vowel_count, consonant_count, mora_count] ...
= predictratefile(file_dir, user, gender_index, cv_fixed_ratio, mora_prediction)

if gender_index == 1,
  gender = '_male';
  gender_str = 'Male';
elseif gender_index == 2,
  gender = '_female';
  gender_str = 'Female';
else
  gender = '';
  gender_str = 'Male & Female';
end

if nargin <= 3,
  cv_fixed_ratio = 0;
end
if nargin <= 4,
  mora_prediction = 0;
end

correct_list_basename = [user gender '_correct' '.csv'];
correct_list_file = [file_dir '/' correct_list_basename];

if 1,
  [syn_type_list, word_num_correct, word_count, ...
      vowel_num_correct, vowel_count, consonant_num_correct, consonant_count, mora_num_correct, mora_count] ...
    = textread(correct_list_file, '%s%d%d%d%d%d%d%d%d', 'delimiter', ',');
else
  [syn_type_list, word_num_correct, word_count, ...
      vowel_num_correct, vowel_count, consonant_num_correct, consonant_count] ...
    = textread(correct_list_file, '%s%d%d%d%d%d%d', 'delimiter', ',');
  mora_count = consonant_count;
end

word_rate_list = word_num_correct ./ word_count;
vowel_rate_list = vowel_num_correct ./ vowel_count;
consonant_rate_list = consonant_num_correct ./ consonant_count;
mora_rate_list = mora_num_correct ./ mora_count;

if cv_fixed_ratio,
  vc_ratio_list = 0.5*ones(size(vowel_count));
else
  vc_ratio_list = vowel_count ./ (vowel_count + consonant_count);
end

max_N_list = 4.0 * (vowel_count + consonant_count) ./ mora_count;

if mora_prediction,
  [N, dist, predicted_rate_list] = predictrate_mora(word_rate_list, mora_rate_list);
else
  [N, dist, predicted_rate_list] ...
    = predictrate(word_rate_list, vowel_rate_list, consonant_rate_list, vc_ratio_list);
end

% keyboard