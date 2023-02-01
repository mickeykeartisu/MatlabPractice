function [ gain_t ] = getnonlinear( cep, prm, th_dB)
%GETNONLINEAR 柴田先rg輩の非線形処理強調を行うためのパラメータを得る

if nargin < 3,
    th_dB = 0.315;
end

dcep = getDeltaCep(cep,prm);

cep_norm = getDcepNorm(dcep,1);
cep_norm2 = cep_norm;
cep_norm = trunc2(cep_norm, round(prm.msdceptime/2), 2, 'both', 1, 0);

keyboard
%th_dB = 0.315; %閾値？
t = 10;
gain_t = filtFade(cep_norm, th_dB, t, 0);
end

