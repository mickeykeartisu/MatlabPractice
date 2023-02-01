function [f] = getNormalDistribution(x, sigma, mu)
% ���K���z�̍쐬
% [f] = getNormalDistribution(x, sigma, mu)


if nargin<3, 
    mu = 0;
end

f = 1/(sqrt(2*pi)*sigma) * exp(-(x-mu).^2/(2*sigma^2));