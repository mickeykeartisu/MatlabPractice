function [label] = get_label_tanabe(num)
%�t�@�C���ԍ�����͂��邱�ƂŁC���x�����擾����v���O����

if num < 10
    label = sploadlabel(['YSB_60dB_000' num2str(num) '_label.txt'], 'sec'); %���͂��鉹���f�[�^�̎����i���׃����O�́j���Z�o����
elseif num > 9 && num <100
    label = sploadlabel(['YSB_60dB_00' num2str(num) '_label.txt'], 'sec');
else
    label = sploadlabel(['YSB_60dB_0' num2str(num) '_label.txt'], 'sec');
end
%���x���쐬����,"�b"�ŕۑ������̂�,�t�H�[�}�b�g��sec�ɂ��Ă���