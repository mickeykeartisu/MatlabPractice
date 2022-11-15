function [filt] = bandlimit(hp_cutoff, lp_cutoff, sidelobe, trans, gain)

if nargin < 3
  sidelobe = 60.0;
end
if nargin < 4
  trans = 0.05;
end
if nargin < 5
  gain = 1.0;
end

filt = lowhighpass(hp_cutoff, lp_cutoff, 1, sidelobe, trans, gain);
