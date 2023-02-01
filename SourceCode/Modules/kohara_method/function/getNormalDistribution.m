function [f] = getNormalDistribution(x, sigma, mu)
% 正規分布の作成
% [f] = getNormalDistribution(x, sigma, mu)


if nargin<3, 
    mu = 0;
end

f = 1/(sqrt(2*pi)*sigma) * exp(-(x-mu).^2/(2*sigma^2));