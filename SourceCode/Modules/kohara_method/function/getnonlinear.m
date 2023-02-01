function [ gain_t ] = getnonlinear( cep, prm, th_dB)
%GETNONLINEAR �ēc��rg�y�̔���`�����������s�����߂̃p�����[�^�𓾂�

if nargin < 3,
    th_dB = 0.315;
end

dcep = getDeltaCep(cep,prm);

cep_norm = getDcepNorm(dcep,1);
cep_norm2 = cep_norm;
cep_norm = trunc2(cep_norm, round(prm.msdceptime/2), 2, 'both', 1, 0);

keyboard
%th_dB = 0.315; %臒l�H
t = 10;
gain_t = filtFade(cep_norm, th_dB, t, 0);
end

