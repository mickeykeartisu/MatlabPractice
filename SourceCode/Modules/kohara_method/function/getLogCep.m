function [LogCep, cep_nd] = getLogCep(cep, sigma, marg, c0_flag,filter)
% [LogCep] = getLogCep(cep, sigma, marg)
% ケプストラムを入力，LoGフィルタ後のケプストラムを出力
% c_0 は0の値を格納

if nargin < 4,
    c0_flag = 0;
end
if nargin < 5,
    filter = [-1,2,-1];
end

x = -marg:marg;
f_nd = getNormalDistribution(x, sigma);
% figure
% plot(f_nd)

cep_nd = filter2(f_nd, cep, 'same');
LogCep = getEdge(cep_nd, c0_flag,filter);
