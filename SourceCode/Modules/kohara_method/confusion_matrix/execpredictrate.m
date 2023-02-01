if strcmp(computer, 'PCWIN'),
  workdir = 'e:/work/study';
else
  workdir = [getenv('HOME') '/study/work'];
end

printdir = 'fig';
d = dir(printdir);
if isempty(d)
  mkdir(printdir);
end
%printformat = 'meta';
printformat = 'png';

mora_prediction = 1;
include_nonjapanese = 1;
cv_fixed_ratio = 0;

if 0,
  fontsize = 16;
  smallfontsize=8;
  linewidth = 1.0;
else
  fontsize = 18;
  smallfontsize=6;
  linewidth = 1.5; % for PPT
end

close all

%file_dir = [workdir '/smearing/confusion_matrix_test']
%file_dir = [workdir '/smearing/confusion_matrix040531']
file_dir = [workdir '/smearing/confusion_matrix041115']

user_list = [];
user_list = strvcat(user_list, 'denda');
user_list = strvcat(user_list, 'omae');
user_list = strvcat(user_list, 'morise');
user_list = strvcat(user_list, 'kimiko');
user_list = strvcat(user_list, 'Rie');
user_list = strvcat(user_list, 'susan');

if include_nonjapanese,
  user_list = strvcat(user_list, 'hamuza');
  user_list = strvcat(user_list, 'chiiko');
end

user_str_list = [];
num_japanese = 6;
for ii = 1:size(user_list,1),
  if ii <= 3 | ii == 7,
    gender_flag = 'M';
  else
    gender_flag = 'F';
  end
  if ii <= num_japanese,
    user_str_list = strvcat(user_str_list, ['J' num2str(ii) gender_flag]);
  else
    user_str_list = strvcat(user_str_list, ['NJ' num2str(ii - num_japanese) gender_flag]);
  end
end

%colplot = 3;
%rawplot = 3;
colplot = 2;
rawplot = ceil(size(user_list,1) / 2);

plotseq = [2:9 1];
syn_type_axis_str = strvcat(int2str([0; 1; 3; 4; 5; 7; 10;]),'AnaSyn','  Orig');

N_matrix = zeros(3, size(user_list, 1));
dist_matrix = zeros(3, size(user_list, 1));

word_count_total = zeros(3, length(plotseq));
vowel_count_total = zeros(3, length(plotseq));
consonant_count_total = zeros(3, length(plotseq));
mora_count_total = zeros(3, length(plotseq));
mean_word_rate = zeros(3, length(plotseq));
mean_vowel_rate = zeros(3, length(plotseq));
mean_consonant_rate = zeros(3, length(plotseq));
mean_mora_rate = zeros(3, length(plotseq));
mean_predicted_rate = zeros(3, length(plotseq));

word_num_correct_matrix = zeros(2*length(plotseq), size(user_list, 1));

for gender_index = 0:2,
  figure;
  set(gca, 'FontSize', smallfontsize);

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
    
  for ii = 1:size(user_list, 1),
    user = deblank(user_list(ii,:))
    user_str = deblank(user_str_list(ii,:));
    
    subplot(rawplot, colplot, ii);
    
    [N, dist, predicted_rate_list, ...
	word_rate_list, vowel_rate_list, consonant_rate_list, vc_ratio_list, mora_rate_list, max_N_list, ...
	word_count, vowel_count, consonant_count, mora_count] ...
      = predictratefile(file_dir, user, gender_index, cv_fixed_ratio, mora_prediction);
    % N
    % dist
    
    N_matrix(gender_index+1, ii) = N;
    dist_matrix(gender_index+1, ii) = dist;
    % keyboard
    word_count_total(gender_index+1,:) = word_count_total(gender_index+1,:) + word_count';
    vowel_count_total(gender_index+1,:) = vowel_count_total(gender_index+1,:) + vowel_count';
    consonant_count_total(gender_index+1,:) = consonant_count_total(gender_index+1,:) + consonant_count';
    mora_count_total(gender_index+1,:) = mora_count_total(gender_index+1,:) + mora_count';
    word_num_correct = (word_count .* word_rate_list)';
    mean_word_rate(gender_index+1,:) =  word_num_correct + mean_word_rate(gender_index+1,:);
    mean_vowel_rate(gender_index+1,:) =  (vowel_count .* vowel_rate_list)' + mean_vowel_rate(gender_index+1,:);
    mean_consonant_rate(gender_index+1,:) =  (consonant_count .* consonant_rate_list)' + mean_consonant_rate(gender_index+1,:);
    mean_mora_rate(gender_index+1,:) =  (mora_count .* mora_rate_list)' + mean_mora_rate(gender_index+1,:);
    mean_predicted_rate(gender_index+1,:) =  predicted_rate_list' + mean_predicted_rate(gender_index+1,:);
    
    if gender_index == 1,
      word_num_correct_matrix(1:length(plotseq), ii) = word_num_correct(plotseq)';
    elseif gender_index == 2,
      word_num_correct_matrix(length(plotseq)+1:2*length(plotseq), ii) = word_num_correct(plotseq)';
    end
    
    set(gca, 'FontSize', smallfontsize)

    if mora_prediction,
      plot(1:9, 100*word_rate_list(plotseq), 'o-', ...
	1:9, 100*mora_rate_list(plotseq), 's:', ...
	1:9, 100*predicted_rate_list(plotseq), '+:', 'LineWidth', linewidth);
    elseif cv_fixed_ratio,
      plot(1:9, 100*word_rate_list(plotseq), 'o-', ...
	1:9, 50*(consonant_rate_list(plotseq) + vowel_rate_list(plotseq)), '^-.', ...
	1:9, 100*predicted_rate_list(plotseq), '+:', 'LineWidth', linewidth);
    else
      plot(1:9, 100*word_rate_list(plotseq), 'o-', ...
	1:9, 100*consonant_rate_list(plotseq), '^-.', ...
	1:9, 100*vowel_rate_list(plotseq), 'x--', ...
	1:9, 100*predicted_rate_list(plotseq), '+:', ...
	1:9, 100*vc_ratio_list(plotseq), '-.', 'LineWidth', linewidth);
    end
    % legend('Word', 'Consonant', 'Vowel', 'Predicted', 2);

    if 1,
      title([user_str ', ' gender_str ', N = ' num2str(N), ...
	  ', dist = ' num2str(100*dist) '%' ], 'FontSize', smallfontsize)
    else
      title(['N = ' num2str(N), ', dist = ' num2str(100*dist) '%' ], 'FontSize', smallfontsize)
    end
    % xlabel('Warped-DCT condition', 'FontSize', smallfontsize);
    % xlabel('WDCT condition', 'FontSize', smallfontsize);
    ylabel('Percentage Correct', 'FontSize', smallfontsize);
    axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
    set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', smallfontsize)
    set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', smallfontsize);
    set(gca, 'LineWidth', linewidth)
    
  end

  % keyboard
  
  if mora_prediction,
    str =['print -d' printformat ' ' printdir '/' 'correct_mora' gender ]; disp(str); eval(str);
  else
    str =['print -d' printformat ' ' printdir '/' 'correct' gender ]; disp(str); eval(str);
  end
end

% return
% keyboard


mean_word_rate = mean_word_rate ./ word_count_total
mean_vowel_rate = mean_vowel_rate ./ vowel_count_total
mean_consonant_rate = mean_consonant_rate ./ consonant_count_total
mean_mora_rate = mean_mora_rate ./ mora_count_total
mean_predicted_rate = mean_predicted_rate ./ (size(user_list, 1) .* ones(3, length(plotseq)));


%predicted_rate_list2 = ((mean_vowel_rate + mean_consonant_rate) / 2) .^(mean(N_matrix(1,:)));
predicted_rate_list2 = mean_predicted_rate;

%keyboard
csvindex = [0 1 3 4 5 7 10 1000 10000];
csvwrite('correct_word.csv', [csvindex; mean_word_rate(1,plotseq); mean_word_rate(2,plotseq); mean_word_rate(3,plotseq)]');
csvwrite('correct_vowel.csv', [csvindex; mean_vowel_rate(1,plotseq); mean_vowel_rate(2,plotseq); mean_vowel_rate(3,plotseq)]');
csvwrite('correct_consonant.csv', [csvindex; mean_consonant_rate(1,plotseq); mean_consonant_rate(2,plotseq); mean_consonant_rate(3,plotseq)]');
csvwrite('correct_mora.csv', [csvindex; mean_mora_rate(1,plotseq); mean_mora_rate(2,plotseq); mean_mora_rate(3,plotseq)]');
csvwrite('correct_predicted.csv', [csvindex; mean_predicted_rate(1,plotseq); mean_predicted_rate(2,plotseq); mean_predicted_rate(3,plotseq)]');


figure
set(gca, 'FontSize', fontsize)
plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
  1:9, 100*mean_word_rate(2,plotseq), '^-.', ...
  1:9, 100*mean_word_rate(3,plotseq), 'x--', 'LineWidth', linewidth);
%xlabel('Warped-DCT condition', 'FontSize', fontsize);
xlabel('WDCT condition', 'FontSize', fontsize);
ylabel('Percentage Correct (%)', 'FontSize', fontsize);
axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', fontsize);
set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', fontsize);
set(gca, 'LineWidth', linewidth)
legend('Average', 'Male', 'Female', 2);
str =['print -d' printformat ' ' printdir '/' 'correct_male_female']; disp(str); eval(str);

figure
set(gca, 'FontSize', fontsize)
plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
  1:9, 100*mean_consonant_rate(1,plotseq), '^-.', ...
  1:9, 100*mean_vowel_rate(1,plotseq), 'x--', 'LineWidth', linewidth);
%xlabel('Warped-DCT condition', 'FontSize', fontsize);
xlabel('WDCT condition', 'FontSize', fontsize);
ylabel('Percentage Correct (%)', 'FontSize', fontsize);
axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', fontsize);
set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', fontsize);
set(gca, 'LineWidth', linewidth)
legend('Word', 'Consonant', 'Vowel', 2);
str =['print -d' printformat ' ' printdir '/' 'correct_consonant_vowel']; disp(str); eval(str);

figure
set(gca, 'FontSize', fontsize)
plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
  1:9, 100*mean_mora_rate(1,plotseq), 's:', ...
  1:9, 100*mean_consonant_rate(1,plotseq), '^-.', ...
  1:9, 100*mean_vowel_rate(1,plotseq), 'x--', 'LineWidth', linewidth);
%xlabel('Warped-DCT condition', 'FontSize', fontsize);
xlabel('WDCT condition', 'FontSize', fontsize);
ylabel('Percentage Correct (%)', 'FontSize', fontsize);
axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', fontsize);
set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', fontsize);
set(gca, 'LineWidth', linewidth)
legend('Word', 'Mora', 'Consonant', 'Vowel', 2);
str =['print -d' printformat ' ' printdir '/' 'correct_mora_consonant_vowel']; disp(str); eval(str);


figure
set(gca, 'FontSize', fontsize)
if mora_prediction,
  plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
    1:9, 100*mean_mora_rate(1,plotseq), 's:', ...
    1:9, 100*predicted_rate_list2(1,plotseq), '+:', 'LineWidth', linewidth);
else
  plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
    1:9, 50*(mean_consonant_rate(1,plotseq)+mean_vowel_rate(1,plotseq)), '^-.', ...
    1:9, 100*predicted_rate_list2(1,plotseq), '+:', 'LineWidth', linewidth);
end
%xlabel('Warped-DCT condition', 'FontSize', fontsize);
xlabel('WDCT condition', 'FontSize', fontsize);
ylabel('Percentage Correct (%)', 'FontSize', fontsize);
axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', fontsize);
set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', fontsize);
set(gca, 'LineWidth', linewidth)
if mora_prediction,
  legend('Word', 'Mora', 'Predicted', 2);
  str =['print -d' printformat ' ' printdir '/' 'correct_mora_predicted']; disp(str); eval(str);
else
  legend('Word', 'Phoneme', 'Predicted', 2);
  str =['print -d' printformat ' ' printdir '/' 'correct_predicted']; disp(str); eval(str);
end


figure
set(gca, 'FontSize', fontsize)
plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
  1:9, 100*mean_mora_rate(1,plotseq), 's:', ...
  1:9, 100*mean_consonant_rate(1,plotseq), '^-.', ...
  1:9, 100*mean_vowel_rate(1,plotseq), 'x--', ...
  1:9, 100*predicted_rate_list2(1,plotseq), '+:', 'LineWidth', linewidth);
%xlabel('Warped-DCT condition', 'FontSize', fontsize);
xlabel('WDCT condition', 'FontSize', fontsize);
ylabel('Percentage Correct (%)', 'FontSize', fontsize);
axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', fontsize);
set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', fontsize);
set(gca, 'LineWidth', linewidth)
legend('Word', 'Mora', 'Consonant', 'Vowel', 'Predicted', 2);
str =['print -d' printformat ' ' printdir '/' 'correct_mora_all']; disp(str); eval(str);


figure
set(gca, 'FontSize', fontsize);
plot(1:size(user_list,1), N_matrix(1,:), 'o-', ...
  1:size(user_list,1), N_matrix(2,:), '^-.', ...
  1:size(user_list,1), N_matrix(3,:), 'x--', 'LineWidth', linewidth);
xlabel('User ID', 'FontSize', fontsize);
ylabel('Predicted N', 'FontSize', fontsize);
axis([0.5, size(user_str_list, 1)+0.5, 1, 8]);
set(gca, 'XTick', [1:size(user_str_list, 1)], 'FontSize', fontsize)
set(gca, 'XTickLabel', user_str_list), 'FontSize', fontsize;
set(gca, 'LineWidth', linewidth)
legend('Male & Female', 'Male', 'Female', 0);
if mora_prediction,
  str =['print -d' printformat ' ' printdir '/' 'predicted_N_mora']; disp(str); eval(str);
else
  str =['print -d' printformat ' ' printdir '/' 'predicted_N']; disp(str); eval(str);
end


figure
set(gca, 'FontSize', fontsize);
plot(1:size(user_list,1), 100*dist_matrix(1,:), 'o-', ...
  1:size(user_list,1), 100*dist_matrix(2,:), '^-.', ...
  1:size(user_list,1), 100*dist_matrix(3,:), 'x--', 'LineWidth', linewidth);
xlabel('User ID', 'FontSize', fontsize);
ylabel('Distance (%)', 'FontSize', fontsize);
axis([0.5, size(user_str_list, 1)+0.5, 0, 10]);
set(gca, 'XTick', [1:size(user_str_list, 1)], 'FontSize', fontsize)
set(gca, 'XTickLabel', user_str_list), 'FontSize', fontsize;
set(gca, 'LineWidth', linewidth)
legend('Male & Female', 'Male', 'Female', 0);
if mora_prediction,
  str =['print -d' printformat ' ' printdir '/' 'predicted_dist_mora']; disp(str); eval(str);
else
  str =['print -d' printformat ' ' printdir '/' 'predicted_dist']; disp(str); eval(str);
end


if 1,
  figure
  [syn_type_list, word_num_correct, word_count, ...
      vowel_num_correct, vowel_count, consonant_num_correct, consonant_count, ...
      mora_num_correct, mora_count] ...
    = textread([file_dir '/' 'hamuza_correct.csv'], '%s%d%d%d%d%d%d%d%d', 'delimiter', ',');
  hamuza_word_rate = word_num_correct ./ word_count;
  % keyboard
  [syn_type_list, word_num_correct, word_count, ...
      vowel_num_correct, vowel_count, consonant_num_correct, consonant_count,...
      mora_num_correct, mora_count] ...
    = textread([file_dir '/' 'chiiko_correct.csv'], '%s%d%d%d%d%d%d%d%d', 'delimiter', ',');
  chiiko_word_rate = word_num_correct ./ word_count;
  % keyboard
  set(gca, 'FontSize', fontsize);
  plot(1:9, 100*mean_word_rate(1,plotseq), 'o-', ...
    1:9, 100*chiiko_word_rate(plotseq), '^-.', ...
    1:9, 100*hamuza_word_rate(plotseq), 'x--', 'LineWidth', linewidth);
  %xlabel('Warped-DCT condition', 'FontSize', fontsize);
  xlabel('WDCT condition', 'FontSize', fontsize);
  ylabel('Percentage Correct (%)', 'FontSize', fontsize);
  axis([0.5, size(syn_type_axis_str, 1)+0.5, 0, 100]);
  set(gca, 'XTick', [1:size(syn_type_axis_str, 1)], 'FontSize', fontsize);
  set(gca, 'XTickLabel', syn_type_axis_str, 'FontSize', fontsize);
  set(gca, 'LineWidth', linewidth)
  legend('Japanese (Ave)', 'Non-Japanese #1', 'Non-Japanese #2', 2);
  str =['print -d' printformat ' ' printdir '/' 'correct_japanese_nonjapanese']; disp(str); eval(str);
end

csvwrite('NumCorrect.csv', word_num_correct_matrix);

disp(['Mean N = ' num2str(mean(N_matrix(1,:))) ', Mean distortion = ' num2str(100*mean(dist_matrix(1,:))) '%']);

