function [gainS_rev, splitgainS ] = getGainSeries(cep,n3sgram,T,coe,sigma,gain_v,marg,flag)
%GETGAINSERIES 2�K���������̌W�����w�肵�āA�Q�C���n������߂邽�߂̌W���s���Ԃ��֐�

LogCep = getLogCep(cep, sigma, marg,flag,coe); %������
LogCep = LogCep * gain_v;
gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'linear'); %�P�v�X�g�����̌W���s������g���̈�ɖ߂�% % 

splitgainS =  cell(T,1);
gainS_rev = cell(T,1);

buf_sgram = gainS;
for k = T:-1:2,
    splitgainS{k} = buf_sgram(ceil( size(buf_sgram,1)/2 ):end, :);
    splitgainS{k-1} = buf_sgram(1:ceil( size(buf_sgram,1)/2 ), :); 
    buf_sgram = splitgainS{k-1};
end
for k = 1:T,
    gainS_rev{k} = splitgainS{T+1-k};
end
end

