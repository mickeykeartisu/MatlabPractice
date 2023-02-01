if strcmp(computer, 'PCWIN'),
  workdir = 'c:/work/study';
else
  workdir = [getenv('HOME') '/study/work'];
end

odir = [workdir '/yoshida/confusion_matrix080214']

user_list = [];
user_list = strvcat(user_list, 'answer_KA');
user_list = strvcat(user_list, 'answer_YO');
user_list = strvcat(user_list, 'answer_IT');
user_list = strvcat(user_list, 'answer_KI');

ofile_id = 'all';

syn_type_list = char( ...
    '50dB', '50dBSN0dBfin', '50dBSN-5dBfin', '50dBSN-10dBfin', ...
    '60dB', '60dBSN0dBfin', '60dBSN-5dBfin', '60dBSN-10dBfin', ...
    '70dB', '70dBSN0dBfin', '70dBSN-5dBfin', '70dBSN-10dBfin');

getcorrect(user_list, 0, odir, ofile_id, syn_type_list);

for mora_index = 1:4,
    getcorrect(user_list, 0, odir, ofile_id, syn_type_list, mora_index);
end
