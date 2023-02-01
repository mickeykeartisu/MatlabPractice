function [filt] = highpass(hp_cutoff, sidelobe, trans, gain)

if nargin < 2
  sidelobe = 60.0;
end
if nargin < 3
  trans = 0.05;
end
if nargin < 4
  gain = 1.0;
end

filt = lowhighpass(hp_cutoff, -1.0, 0, sidelobe, trans, gain);
