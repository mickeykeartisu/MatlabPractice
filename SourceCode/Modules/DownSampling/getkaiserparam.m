function [beta, length] = getkaiserparam(sidelobe, trans, max_length)
% Get Kaiser window Parameters
% 	[BETA, LENGTH] = GETKAISERPARAM(SIDELOBE, TRANS)
% 	[BETA, LENGTH] = GETKAISERPARAM(SIDELOBE, TRANS, MAX_LENGTH)

if nargin < 3
  max_length = 0;
end

value = (2.285 * pi * trans);
length = floor((sidelobe - 8.0) / value);

if max_length > 0 & length > max_length
  sidelobe = 8.0 + max_length * value;
  length = max_length;
end


if sidelobe < 21
  beta = 0;
elseif sidelobe > 50
  beta = 0.1102 * (sidelobe - 8.7);
else
  value = sidelobe - 21.0;
  beta = 0.5842 * (value .^ 0.4) + 0.07886 * value;
end

