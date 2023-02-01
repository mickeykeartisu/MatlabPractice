if strcmp(computer, 'PCWIN'),
  workdir = 'c:/work/study';
else
  workdir = [getenv('HOME') '/study/work'];
end

idir = [workdir '/yoshida/mostest080214']
%odir = [workdir '/smearing/confusion_matrix']
%odir = [workdir '/smearing/confusion_matrix040520']
%odir = [workdir '/smearing/confusion_matrix040531']
odir = [workdir '/yoshida/confusion_matrix080214']
% odir = '../data/confusion_matrix';

if 1,
  gender_index = 0;
  user_list = [];
  user_list = strvcat(user_list, 'answer_KA');
  user_list = strvcat(user_list, 'answer_YO');
  user_list = strvcat(user_list, 'answer_IT');
  user_list = strvcat(user_list, 'answer_KI');
  %user_list = strvcat(user_list, 'omae');
  %user_list = strvcat(user_list, 'morise');
  
  ofile_id = 'all';
  
  for mora_index = 1:4,
      getconfusionstat2008(idir, user_list, gender_index, odir, ofile_id, mora_index);
  end
  % getconfusionstat2008(idir, user_list, gender_index, odir, ofile_id);
end