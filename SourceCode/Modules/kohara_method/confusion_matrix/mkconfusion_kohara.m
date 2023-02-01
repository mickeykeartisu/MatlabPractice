if strcmp(computer, 'PCWIN') || strcmp(computer, 'PCWIN64'),
    workdir = 'C:/Users/share/Documents/Subjective evaluation tools/Subjective_evaluation_data';
else
%   workdir = [getenv('HOME') '/study/work'];
    workdir = 'C:/Users/share/Documents/Subjective evaluation tools/Subjective_evaluation_data';
end
%workdir���̃t�H���_�����w��
% folderName = '/��@�Ⴂ�pfile 201-400(�ʏ�,0Hz,3000Hz,�ēc)';
% folderName = '/��@�Ⴂ�pfile 1-200(�ʏ�,0Hz,500Hz,�ēc)';
% folderName = '/�Q�C���Ⴂ�A�Q�C�����~�b�g�Ⴂ��r';
% folderName = '/�Q�C���Ⴂ�A�Q�C�����~�b�g�Ⴂ��r�i�m�C�Y����j';
folderName = '/���Đ�����]��';
% folderName = '/���Đ�����]���i�m�C�Y����j/70dB-70dB';
% folderName = '/���Đ�����]���i�m�C�Y����j/70dB-70dB_���~�b�g�Ȃ�';
% folderName = '/���Đ�����]���i�m�C�Y����j/70dB-65dB';
% folderName = '/���Đ�����]���i�m�C�Y����j/70dB-67dB';

idir = [workdir '/input' folderName];
odir = [workdir '/output' folderName];%�o�͐�ɂ��̃t�@�C��������Ă���
mkdir(odir);

global param_file list_file master_file;

param_file = 'Paramfile.txt';
list_file = 'Test_list.txt';
master_file = 'Test_master.txt';


gender_index = 0;



%%�@�팱�҂��Ƃɓ���
user_list = [];
user_list = strvcat(user_list, 'Test_answer0');
user_list = strvcat(user_list, 'Test_answer1');
user_list = strvcat(user_list, 'Test_answer2');
user_list = strvcat(user_list, 'Test_answer3');
user_list = strvcat(user_list, 'Test_answer4');
% user_list = strvcat(user_list, 'Test_answer5');
% user_list = strvcat(user_list, 'Test_answerSample');

if size(user_list,1) == 1,
    odir = [workdir '/output' folderName '/' user_list];
    mkdir(odir);%�o�͐�ɂ��̃t�H���_���쐬
end


% %�Q�C����r�p
if strcmp(folderName, '/�Q�C���Ⴂ�A�Q�C�����~�b�g�Ⴂ��r') == 1,
    syn_type_list = char( ...
        '3dB_16band_hanning500Hz_nolimit_normalization30dB', ...
        '3dB_16band_hanning500Hz_Gainlimit9dB_normalization30dB',...
        '6dB_16band_hanning500Hz_nolimit_normalization30dB',...
        '6dB_16band_hanning500Hz_Gainlimit9dB_normalization30dB');
end

if strcmp(folderName, '/�Q�C���Ⴂ�A�Q�C�����~�b�g�Ⴂ��r�i�m�C�Y����j') == 1,
    syn_type_list = char( ...
        '3dB_16band_hanning500Hz_nolimit_add_noise_speech70dB_noise70dB', ...
        '6dB_16band_hanning500Hz_nolimit_add_noise_speech70dB_noise70dB',...
        '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise70dB');
end

% ���Đ��]��
if strcmp(folderName, '/���Đ�����]��') == 1,
    syn_type_list = char( ...
        'normalization30dB', ...
        '6dB_16band_hanning500Hz_Gainlimit9dB_normalization30dB',...
        'PeakHz16_lin_6');
end

% %���Đ��]��(�m�C�Y����70dB-70dB)
if strcmp(folderName, '/���Đ�����]���i�m�C�Y����j/70dB-70dB') == 1,
%     syn_type_list = char( ...
%         'add_noise_speech70dB_noise70dB', ...
%         '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise70dB',...
%         'PeakHz16_lin_6_add_noise_speech70dB_noise70dB');
    
    syn_type_list = char( ...
    '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise70dB', ...
    'add_noise_speech70dB_noise70dB',...
    'PeakHz16_lin_6_add_noise_speech70dB_noise70dB');
end

if strcmp(folderName, '/���Đ�����]���i�m�C�Y����j/70dB-70dB_���~�b�g�Ȃ�') == 1,
%     syn_type_list = char( ...
%         'add_noise_speech70dB_noise70dB', ...
%         '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise70dB',...
%         'PeakHz16_lin_6_add_noise_speech70dB_noise70dB');
    
    syn_type_list = char( ...
    '6dB_16band_hanning500Hz_nolimit_add_noise_speech70dB_noise70dB', ...
    'add_noise_speech70dB_noise70dB',...
    'PeakHz16_lin_6_add_noise_speech70dB_noise70dB');
end

% %���Đ��]��(�m�C�Y����70dB-65dB)
if strcmp(folderName, '/���Đ�����]���i�m�C�Y����j/70dB-65dB') == 1,
%     syn_type_list = char( ...
%         'add_noise_speech70dB_noise65dB', ...
%         '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise65dB',...
%         'PeakHz16_lin_6_add_noise_speech70dB_noise65dB');
    
    syn_type_list = char( ...
        '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise65dB',...
        'add_noise_speech70dB_noise65dB', ...
        'PeakHz16_lin_6_add_noise_speech70dB_noise65dB');
end

% %���Đ��]��(�m�C�Y����70dB-65dB)
if strcmp(folderName, '/���Đ�����]���i�m�C�Y����j/70dB-67dB') == 1,
%     syn_type_list = char( ...
%         'add_noise_speech70dB_noise65dB', ...
%         '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise65dB',...
%         'PeakHz16_lin_6_add_noise_speech70dB_noise65dB');
    
%     syn_type_list = char( ...
%         '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise67dB',...
%         'add_noise_speech70dB_noise67dB', ...
%         'PeakHz16_lin_6_add_noise_speech70dB_noise67dB');
    syn_type_list = char( ...
        'add_noise_speech70dB_noise67dB', ...
        'PeakHz16_lin_6_add_noise_speech70dB_noise67dB',...
        '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise67dB');
end

ofile_id = 'all';

% keyboard

for mora_index = 1:4,
  getconfusionstat_kohara(idir, user_list, syn_type_list, gender_index, odir, ofile_id, mora_index);
end
getconfusionstat_kohara(idir, user_list, syn_type_list, gender_index, odir, ofile_id);

if size(user_list,1) ~= 1,
    for u = 1:size(user_list,1)
        odir = [workdir '/output' folderName '/' user_list(u,:)];
        mkdir(odir);%�o�͐�ɂ��̃t�H���_���쐬
        for mora_index = 1:4,
            getconfusionstat_kohara(idir, user_list(u,:), syn_type_list, gender_index, odir, ofile_id, mora_index);
        end
        getconfusionstat_kohara(idir, user_list(u,:), syn_type_list, gender_index, odir, ofile_id);
    end
end