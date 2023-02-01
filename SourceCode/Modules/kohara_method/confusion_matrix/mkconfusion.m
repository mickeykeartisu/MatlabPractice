if strcmp(computer, 'PCWIN'),
  workdir = 'e:/work/study';
else
  workdir = [getenv('HOME') '/study/work'];
end

idir = [workdir '/smearing/subjtest031213']
%odir = [workdir '/smearing/confusion_matrix']
%odir = [workdir '/smearing/confusion_matrix040520']
%odir = [workdir '/smearing/confusion_matrix040531']
odir = [workdir '/smearing/confusion_matrix041115']
% odir = '../data/confusion_matrix';

if 1,
  user_list = [];
  user_list = strvcat(user_list, 'chiiko');
  user_list = strvcat(user_list, 'hamuza');
  
  for gender_index = 0:2,
    if gender_index == 1,
      ofile_id = 'nonnative_male';
    elseif gender_index == 2,
      ofile_id = 'nonnative_female';
    else
      ofile_id = 'nonnative';
    end

    for mora_index = 1:4,
      getconfusionstat(idir, user_list, gender_index, odir, ofile_id, mora_index);
    end
    % getconfusionstat(idir, user_list, gender_index, odir, ofile_id);
  end
end

if 1,
  user_list = [];
  user_list = strvcat(user_list, 'kimiko');
  user_list = strvcat(user_list, 'Rie');
  user_list = strvcat(user_list, 'denda');
  user_list = strvcat(user_list, 'susan');
  user_list = strvcat(user_list, 'omae');
  user_list = strvcat(user_list, 'morise');
  
  for gender_index = 0:2,
    if gender_index == 1,
      ofile_id = 'native_male';
    elseif gender_index == 2,
      ofile_id = 'native_female';
    else
      ofile_id = 'native';
    end
    
    for mora_index = 1:4,
      getconfusionstat(idir, user_list, gender_index, odir, ofile_id, mora_index);
    end
    % getconfusionstat(idir, user_list, gender_index, odir, ofile_id);
  end
end