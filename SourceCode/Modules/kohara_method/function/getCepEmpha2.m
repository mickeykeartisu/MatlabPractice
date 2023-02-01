function [ gainS, cep ] = getCepEmpha2( n3sgram, sigma, marg, flag, gain_v, lifter ,m)
%GETCEPEMPHA2 ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q
%�쐬�ҁF����
%LogCep:�ϓ����M���@cep_nd�F�������P�v�X�g���� lifter:���t�^�����O�|�C���g(���߂��������̒l+1�̒l��0����matlab�ł�1���ł��邽��)
%m:n3sgram���ш敪�����s�������̂̏ꍇ(0:���̃X�y�N�g���O����,1:����̃X�y�N�g���O����)

%-----straight�X�y�N�g������P�v�X�g���������߂�-----%
%%���t�^�����O�|�C���g���^�����ĂȂ���
if m ==1, %���`�ɖ߂��Ă��畽��
    cep = getSt2Cep(n3sgram,lifter); %�֐�getSt2Cep�Ăяo��
    LogCep = getLogCep(cep, sigma, marg); %������
    LogCep = LogCep * gain_v;
    gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'linear'); %�P�v�X�g�����̌n������g���̈�ɖ߂�
    gainS = mean(gainS);
end

if m == 2, %m=1�̕��ς��s��Ȃ�ver
    cep = getSt2Cep(n3sgram,lifter); %�֐�getSt2Cep�Ăяo��
    LogCep = getLogCep(cep, sigma, marg); %������
    LogCep = LogCep * gain_v;
    gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'linear'); %�P�v�X�g�����̌n������g���̈�ɖ߂�
end

if m == 3, %���`�ɖ߂��Ă��畽��
    cep = getSt2Cep(n3sgram, lifter); %�֐�getSt2Cep�Ăяo��
    LogCep = getLogCep(cep, sigma, marg); %������
    LogCep = LogCep * gain_v;
    cep_emp = cep + LogCep;
    n3sgram_emp = getCep2spec(cep_emp, 2*(size(n3sgram,1)-1), 'linear'); %%�������ꂽ�X�y�N�g���𓾂�
    gainS = n3sgram_emp ./ n3sgram;
    gainS = mean(gainS);
end

% if m == 4,
%     LogCep = getCepEmpha(n3sgram, sigma, marg, flag,2);
%     LogCep = LogCep * gain_v;
%     gainS = LogCep;
%     gainS = exp(gainS);
% end
% 
% if m == 5,
%     LogCep = getCepEmpha(n3sgram, sigma, marg, flag,2);
%     LogCep = LogCep * gain_v;
%     gainS = LogCep;
%     gainS = exp(gainS);
% end

% figure
% plot(gainS);
%    
%------����ꂽ�P�v�X�g�����ƃЂƃ}�[�W����A�ϓ����M���ƕ������M���𓾂�-----%
% [LogCep, cep_nd] = getLogCep(cep, sigma, marg, flag);
end



% if m == 4, %���ς��Ă�����`�ɖ߂�
%     cep = getSt2Cep(n3sgram, lifter); %�֐�getSt2Cep�Ăяo��
%     LogCep = getLogCep(cep, sigma, marg); %������
%     LogCep = LogCep * gain_v;
%     cep_emp = cep + LogCep;
%     n3sgram_emp = getCep2spec(cep_emp, 2*(size(n3sgram,1)-1)); %%�������ꂽ�X�y�N�g���𓾂�
%     gainS = n3sgram_emp ./ n3sgram;
%     gainS = mean(gainS,2);
% end



% 
% if m == 2, %���ς��Ă�����`�ɖ߂�
%     cep = getSt2Cep(n3sgram,lifter); %�֐�getSt2Cep�Ăяo��
%     LogCep = getLogCep(cep, sigma, marg); %������
%     LogCep = LogCep * gain_v;
%     gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1)); %�P�v�X�g�����̌n������g���̈�ɖ߂�
%     gainS = mean(gainS);
%     gainS = exp(gainS);
% end
