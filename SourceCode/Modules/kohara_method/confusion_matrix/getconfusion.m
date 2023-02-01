function [confusion_matrix_consonant, confusion_matrix_consonant_normalized, consonantseq, ...
    word_num_correct, word_count, vowel_num_correct, vowel_count, ...
    consonant_num_correct, consonant_count, mora_num_correct, mora_count, ...
    confusion_matrix, confusion_matrix_normalized] ...
  = getconfusion(phonelist, subjtestdir, answerfile, confusionfile, person_index, method_index, gender_index, confusionfile_normalized, ...
    confusionfile_phoneme, confusionfile_phoneme_normalized, mora_index)
% function [confusion_matrix_consonant, confusion_matrix_consonant_normalized, consonantseq, ...
%     word_num_correct, word_count, vowel_num_correct, vowel_count, ...
%     consonant_num_correct, consonant_count, mora_num_correct, mora_count, ...
%     confusion_matrix, confusion_matrix_normalized] ...
%   = getconfusion(subjtestdir, answerfile, confusionfile, person_index, method_index, gender_index, confusionfile_normalized, ...
%     confusionfile_phoneme, confusionfile_phoneme_normalized)
%  	gender_index: 0 = all, 1 = male, 2 = female

%subjtestdir = '../work/subjtest031213';
%subjtestdir = '.';

if nargin < 11,
  mora_index = -1;
end

if isempty(strmatch('param_file', who('global'))),
  global param_file;
  param_file = 'Paramfile.txt';
else
  global param_file;
end

if isempty(strmatch('list_file', who('global'))),
  global list_file;
  list_file = 'Test_list.txt';
else
  global list_file;
end

if isempty(strmatch('master_file', who('global'))),
  global master_file;
  master_file = 'Test_master.txt';
else
  global master_file;
end

num_exercise = 10;
num_dummy = 5;
end_times = 200;

[paramlist, valuelist] = readparam([subjtestdir '/' param_file]);
matchindex = min(strmatch('file_format', paramlist, 'exact'));
if isempty(matchindex),
  error('Cannot find file_format field in the parameter file.');
end
file_format = deblank(valuelist(matchindex, :));

sentence_list = parseparamlist(paramlist, valuelist, 'sentences');
person_list = parseparamlist(paramlist, valuelist, 'persons');
method_list = parseparamlist(paramlist, valuelist, 'methods');
woman_list = parseparamlist(paramlist, valuelist, 'woman');

matchindex = min(strmatch('num_exercise', paramlist, 'exact'));
if ~isempty(matchindex),
  num_exercise = sscanf(valuelist(matchindex,:), '%d');
end
matchindex = min(strmatch('num_dummy', paramlist, 'exact'));
if ~isempty(matchindex),
  num_dummy = sscanf(valuelist(matchindex,:), '%d');
end
matchindex = min(strmatch('end_times', paramlist, 'exact'));
if ~isempty(matchindex),
  end_times = sscanf(valuelist(matchindex,:), '%d');
end

% read master file
masterfilefull = [subjtestdir '/' master_file];
master_org = readlist(masterfilefull);
master = removedummy(num_exercise, num_dummy, end_times, master_org);

% read list file
listfilefull = [subjtestdir '/' list_file];
list = readlist(listfilefull);

mastermap = ones(size(master, 1), 1);

% calculate index mapping from list to master
for ii = 1:length(mastermap),
  
  flag = 0;
  for jj = 1:size(list, 1),
    if strcmp(master(ii, :), list(jj, :)),
      mastermap(ii, 1) = jj;
      flag = 1;
    end
  end
  if ~flag,
    error('Wrong master file.');
  end
  
end

methodmap = zeros(size(master, 1), 1);
personmap = zeros(size(master, 1), 1);
gendermap = zeros(size(master, 1), 1);

for ii = 1:max(size(sentence_list, 1), 1),
  for jj = 1:max(size(person_list, 1), 1),
    for kk = 1:max(size(method_list, 1), 1),
      %filename = getformatfilename(file_format, ...
      %  sentence_list(ii,:), person_list(jj,:), method_list(kk,:))
      filename = getformatfilename(file_format, sentence_list, person_list, method_list, ...
                                   ii, jj, kk);
      matchindex = strmatch(filename, master);
      if ~isempty(matchindex),
	if length(matchindex) >= 2,
          %disp('Warning: duplicated entry exists.');
	end
	methodmap(matchindex, 1) = kk;
	personmap(matchindex, 1) = jj;

	gender_flag = 1;
	if ~isempty(woman_list),
	  for ll = 1:size(woman_list, 1),
	    if ~isempty(strmatch(person_list(jj, :), woman_list(ll, :))),
	      gender_flag = 2;
	      break;
	    end
	  end
	end
	gendermap(matchindex, 1) = gender_flag;
	
      end
    end
  end
end

if isempty(phonelist)
    nn_char = char('n', 39)';  % 39:quotation
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
	'za', 'ji', 'zu', 'ze', 'zo', ...
	'da', 'di', 'du', 'de', 'do', ...
	'ba', 'bi', 'bu', 'be', 'bo', ...
	'pa', 'pi', 'pu', 'pe', 'po', ...
	'kya', 'kyu', 'kyo', ...
	'sha', 'shu', 'sho', ...
	'cha', 'chu', 'cho', ...
	'nya', 'nyu', 'nyo', ...
	'hya', 'hyu', 'hyo', ...
	'mya', 'myu', 'myo', ...
	'rya', 'ryu', 'ryo', ...
	'gya', 'gyu', 'gyo', ...
	'ja', 'ju', 'jo', ...
	'bya', 'byu', 'byo', ...
	'pya', 'pyu', 'pyo', 'Q');
else
    nn_char = deblank(phonelist(46,:));
end

consonantlist = char( ...
'.', '.', '.', '.', '.', 'N', ...
'k', 'k', 'k', 'k', 'k', ...
's', 'S', 's', 's', 's', ...
't', 'tS', 'ts', 't', 't', ...
'n', 'nj', 'n', 'n', 'n', ...
'h', 'hj', 'f', 'h', 'h', ...
'm', 'm', 'm', 'm', 'm', ...
'j', 'j', 'j', ...
'r', 'r', 'r', 'r', 'r', ...
'w', 'N', ...
'g', 'g', 'g', 'g', 'g', ...
'dz', 'd3', 'dz', 'dz', 'dz', ...
'd', 'd3', 'dz', 'd', 'd', ...
'b', 'b', 'b', 'b', 'b', ...
'p', 'p', 'p', 'p', 'p', ...
'kj', 'kj', 'kj', ...
'S', 'S', 'S', ...
'tS', 'tS', 'tS', ...
'nj', 'nj', 'nj', ...
'hj', 'hj', 'hj', ...
'mj', 'mj', 'mj', ...
'rj', 'rj', 'rj', ...
'gj', 'gj', 'gj', ...
'd3', 'd3', 'd3', ...
'bj', 'bj', 'bj', ...
'pj', 'pj', 'pj', 'Q');

vowellist = [];
for ii = 1:size(phonelist, 1),
  phone = deblank(phonelist(ii,:));
  if strcmp(phone, 'n') | strcmp(phone, nn_char),
    vowellist = strvcat(vowellist, ' ');
  else
    vowellist = strvcat(vowellist, phone(end));
  end
end

consonantseq = char( ...
'm', ...
'p', ...
'b', ...
't', ...
'd', ...
's', ...
'ts', ...
'dz', ...
'r', ...
'n', ...
'S', ...
'tS', ...
'd3', ...
'k', ...
'g', ...
'h', ...
'hj', ...
'f', ...
'mj', ...
'pj', ...
'bj', ...
'kj', ...
'gj', ...
'rj', ...
'nj', ...
'w', ...
'j', ...
'N', ...
'Q', ...
'.', ...
'a', ...
'i', ...
'u', ...
'e', ...
'o', ...
' ');

consonantlistindex = zeros(size(consonantlist, 1), 1);
for ii = 1:size(consonantlist, 1),
  consonantlistindex(ii, 1) = min(strmatch(consonantlist(ii,:), consonantseq));
end

if isempty(strmatch('correct_master_file', who('global'))),
  global correct_master_file;
  correct_master_file = 'correct_master.txt';
else
  global correct_master_file;
end


maxphonesize = size(phonelist, 2);
%keyboard
correctlist = removedummy(0, num_dummy, end_times, readlist([subjtestdir ...
                    '/' correct_master_file]));
                
answerlist = removedummy(0, num_dummy, end_times, readlist(answerfile));

% keyboard

% confusion_matrix = zeros(size(phonelist, 1), size(phonelist, 1) + 1);
confusion_matrix = zeros(size(phonelist, 1), size(phonelist, 1) + 2);

confusion_matrix_consonant = zeros(size(consonantseq, 1), size(consonantseq, 1) + 2);

mora_count = 0;
mora_num_correct = 0;

word_count = 0;
word_num_correct = 0;

consonant_count = 0;
consonant_num_correct = 0;
vowel_count = 0;
vowel_num_correct = 0;

for ii = 1:size(correctlist, 1),
  
  if (person_index >= 1 & person_index ~= personmap(ii, 1)) ...
      | (method_index >= 1 & method_index ~= methodmap(ii, 1)) ...
      | (gender_index >= 1 & gender_index ~= gendermap(ii, 1)),
    continue;
  end
  
  word_count = word_count + 1;
  
  correct = deblank(correctlist(ii, :));
  answer = deblank(answerlist(ii, :));
  
%  if isempty(answer),
%    continue;
%  end
  
  % if strcmp(correct, answer),
  %   word_num_correct = word_num_correct + 1;
  % end

  no_error = 1;
  correct_offset = 1;
  answer_offset = 1;
  mora_pos = 0;
  
  while 1,
    % if correct_offset > size(correct, 2) | (~isempty(answer) & answer_offset > size(answer, 2)),
    if correct_offset > size(correct, 2),
      break;
    end

    mora_count = mora_count + 1;
    mora_pos = mora_pos + 1;
    
    [correct_phone, correct_phone_index, correct_offset] = findphone(phonelist, correct, correct_offset);
    [correct_consonant, correct_consonant_seqindex, correct_vowel, correct_vowel_seqindex] ...
      = splitphone(phonelist, consonantlist, vowellist, consonantseq, correct_phone);


    if isempty(answer) | (answer_offset > size(answer, 2)),
      if mora_index <= 0 | mora_index == mora_pos,
        confusion_matrix(correct_phone_index, end-1) = confusion_matrix(correct_phone_index, end-1) + 1;
      
        confusion_matrix_consonant(correct_consonant_seqindex, end-1) ...
	  = confusion_matrix_consonant(correct_consonant_seqindex, end-1) + 1;
        confusion_matrix_consonant(correct_vowel_seqindex, end-1) ...
	  = confusion_matrix_consonant(correct_vowel_seqindex, end-1) + 1;
      end
      
      answer_phone_index = -1;
      answer_vowel_seqindex = -1;
      answer_consonant_seqindex = -1;
      
    else
      [answer_phone, answer_phone_index, answer_offset] = findphone(phonelist, answer, answer_offset);
      if correct_phone_index ~= answer_phone_index,
	disp([correct_phone, ' --> ' answer_phone '  ' answer ' / ' correct]);
      end
    
      % correct_phone
      % answer_phone
    
      [answer_consonant, answer_consonant_seqindex, answer_vowel, answer_vowel_seqindex] ...
	= splitphone(phonelist, consonantlist, vowellist, consonantseq, answer_phone);

      if mora_index <= 0 | mora_index == mora_pos,
	confusion_matrix(correct_phone_index, answer_phone_index) ...
	  = confusion_matrix(correct_phone_index, answer_phone_index) + 1;

	confusion_matrix_consonant(correct_consonant_seqindex, answer_consonant_seqindex) ...
	  = confusion_matrix_consonant(correct_consonant_seqindex, answer_consonant_seqindex) + 1;
	confusion_matrix_consonant(correct_vowel_seqindex, answer_vowel_seqindex) ...
	  = confusion_matrix_consonant(correct_vowel_seqindex, answer_vowel_seqindex) + 1;
      end
      
    end
    
    if correct_phone_index == answer_phone_index,
      if mora_index <= 0 | mora_index == mora_pos,
	mora_num_correct = mora_num_correct + 1;
      end
    else
      no_error = 0;
    end
    if mora_index <= 0 | mora_index == mora_pos,
      if ~isspace(correct_vowel),
	vowel_count = vowel_count + 1;
	if correct_vowel_seqindex == answer_vowel_seqindex,
	  vowel_num_correct = vowel_num_correct + 1;
	end
      end
      if ~strncmp(correct_consonant, '.', 1),
	consonant_count = consonant_count + 1;
	if correct_consonant_seqindex == answer_consonant_seqindex,
	  consonant_num_correct = consonant_num_correct + 1;
	end
      end
    end
  end
  
  % mora_count
  
  if no_error,
    word_num_correct = word_num_correct + 1;
  end
  
  % break;
end

% keyboard

correct_count = sum(confusion_matrix')';
correct_count_tmp = correct_count;
correct_count_tmp(correct_count_tmp <= 0) = 1;
confusion_matrix_normalized = confusion_matrix ./ (correct_count_tmp * ones(1, size(confusion_matrix, 2)));
confusion_matrix(1:end, end) = correct_count;
confusion_matrix_normalized(1:end, end) = correct_count;

cmc_count = sum(confusion_matrix_consonant')';
cmc_count_tmp = cmc_count;
cmc_count_tmp(cmc_count_tmp <= 0) = 1;
% keyboard
confusion_matrix_consonant_normalized = confusion_matrix_consonant ...
  ./ (cmc_count_tmp * ones(1, size(confusion_matrix_consonant, 2)));
confusion_matrix_consonant(1:end, end) = cmc_count;
confusion_matrix_consonant_normalized(1:end, end) = cmc_count;

if nargin >= 8,
  writeconfusion(phonelist, confusionfile_phoneme, confusion_matrix);
end
if nargin >= 9,
  writeconfusion(phonelist, confusionfile_phoneme_normalized, confusion_matrix_normalized);
end

% writeconfusion(consonantseq, confusionfile, confusion_matrix_consonant_normalized);
writeconfusion(consonantseq, confusionfile, confusion_matrix_consonant);
if nargin >= 7,
  writeconfusion(consonantseq, confusionfile_normalized, confusion_matrix_consonant_normalized);
end


% keyboard

return;


function [consonant, consonant_seqindex, vowel, vowel_seqindex] = splitphone(phonelist, consonantlist, vowellist, consonantseq, phone)

%keyboard
matchindex = min(strmatch(phone, phonelist, 'exact'));

if ~isempty(matchindex),
  consonant = consonantlist(matchindex, :);
  vowel = vowellist(matchindex, :);

  consonant_seqindex = min(strmatch(consonant, consonantseq, 'exact'));
  vowel_seqindex = min(strmatch(vowel, consonantseq, 'exact'));
  
end

return;


function master = removedummy(num_exercise, num_dummy, end_times, master)

mastertemp = master;

master_numsession = ceil((size(mastertemp, 1) - num_exercise) ./ end_times);
master = [];
for ii = 1:master_numsession,
  st = ((ii-1).*end_times)+num_dummy+1+num_exercise;
  ed = min(ii.*end_times+num_exercise, size(mastertemp, 1));
  
  % remove dummy
  master = strvcat(master, mastertemp(st:ed,:));
end

return;


function name_list = parseparamlist(paramlist, valuelist, name)

% name
matchindex = strmatch(name, paramlist, 'exact');
if isempty(matchindex),
  %disp(['Cannot find ' name ' field in the parameter file.']);
  name_list = '';
  return;
end
matchindex = min(matchindex);

names = valuelist(matchindex, :);
name_list = [];
ii = 1;
remain = names;
while ~isempty(remain),
  [token remain]= strtok(remain);
  name_list = strvcat(name_list, token);
  ii = ii + 1;
end
matchindex = strmatch('\', name_list);
if ~isempty(matchindex),
  for ii = matchindex,
    name_list(ii, :) = strrep(name_list(ii, :), '\', ' ');
  end
end

return;


function filename = getformatfilename(file_format, sentence_list, person_list, method_list, ...
                                      sentence_index, person_index, method_index)

filename = file_format;

if ~isempty(sentence_list)
  sentence = sentence_list(sentence_index, :);
else
  sentence = '';
end
filename = strrep(filename, '%S', deblank(sentence));

if ~isempty(person_list)
  person = person_list(person_index, :);
else
  person = '';
end
filename = strrep(filename, '%P', deblank(person));

if ~isempty(method_list)
  method = method_list(method_index, :);
else
  method = '';
end
filename = strrep(filename, '%M', deblank(method));

return;