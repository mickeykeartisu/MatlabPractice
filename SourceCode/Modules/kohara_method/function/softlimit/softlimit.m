% 
% Reference: Giannoulis, Dimitrios, Michael Massberg, and Joshua D. Reiss. 
%            "Digital Dynamic Range Compressor Design -- A Tutorial and Analysis." 
%            Journal of Audio Engineering Society. Vol. 60, Issue 6, 2012, pp. 399-408.

function [y, gain, y_dB] = softlimit(x, threshold_dB, ratio, kneeWidth_dB)

if nargin < 2
    threshold_dB = 0;
end
if nargin < 3
    ratio = Inf;
end
if nargin < 4
    kneeWidth_dB = 0;
else
    if kneeWidth_dB < 0
        error('kneeWidth_dB >= 0 is required.');
    end
end

y = zeros(size(x));
if nargout >= 2
    gain = zeros(size(x));
end
if nargout >= 3
    y_dB = zeros(size(x));
end

for ii = 1:length(x)
    x_G = 20 * log10(abs(x(ii)));
    y_G = GiannoulisGainFunc(x_G, threshold_dB, ratio, kneeWidth_dB);
    diff_dB = y_G - x_G;
    weight = 10 .^ (diff_dB / 20);
    y(ii) = x(ii) * weight;
    if nargout >= 2
        gain(ii) = weight;
    end
    if nargout >= 3
        y_dB(ii) = y_G;
    end
end

function y_G = GiannoulisGainFunc(x_G, T, R, W)

if 2 * (x_G - T) < -W
    y_G = x_G;
elseif 2 * (x_G - T) > W
    y_G = T + (x_G - T) / R;
else
    y_G = x_G + (1 / R - 1) * (x_G - T + W / 2) .^ 2 / (2 * W);
end
