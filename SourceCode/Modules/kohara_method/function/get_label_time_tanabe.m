function [label_time] = get_label_time_tanabe(label,num)
%{
get_label_time�Ɋւ���L�q
�󂯎�����ԍ��ɂ�����,���x���̎�����Ԃ��֐�

%   �ڍא����������ɋL�q
num �c ���x���̒l(���l)
label �c �g�p���郉�x��(struct�^)

%}

labelst = struct2cell(label(1,num));           %�\���̂��Z���z��ɂ���
labelst_time = cell2mat(labelst(1,1));          %�Z���z������̃f�[�^�ɖ߂�
label_time = round((labelst_time) * 1000);      %ms�ɕϊ�

end