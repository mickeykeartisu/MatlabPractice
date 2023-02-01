function [LogCep, cep_nd, cep] = getCepEmpha(n3sgram, sigma, marg, flag, lifter)
%�쐬�ҁF����
%LogCep:�ϓ����M���@cep_nd�F�������P�v�X�g���� lifter:���t�^�����O�|�C���g(���߂��������̒l+1�̒l��0����matlab�ł�1���ł��邽��)
%m:n3sgram���ш敪�����s�������̂̏ꍇ(0:���̃X�y�N�g���O����,1:����̃X�y�N�g���O����)

%-----straight�X�y�N�g������P�v�X�g���������߂�-----%
%%���t�^�����O�|�C���g���^�����ĂȂ���
if nargin ==4,
    lifter = 0;
    cep = getSt2Cep(n3sgram);
    cep(1,:) = []; %0�����폜
    cep = mean(cep); %�P�v�X�g�����̑S�������畽�ς����߂�
end

if nargin == 5,
    cep = getSt2Cep(n3sgram, lifter);
    cep(1:lifter-1,:) = []; %���߂��������ȉ��̃P�v�X�g�����̏����폜
end

% if nargin == 6,
%     cep = getSt2Cep(n3sgram,lifter);
%     cep(1:lifter-1,:) = []; %���߂��������ȉ��̃P�v�X�g�����̏����폜
% end

%------����ꂽ�P�v�X�g�����ƃЂƃ}�[�W����A�ϓ����M���ƕ������M���𓾂�-----%
[LogCep, cep_nd] = getLogCep(cep, sigma, marg, flag);
