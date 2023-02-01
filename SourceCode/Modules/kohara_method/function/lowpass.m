function [filt] = lowpass(lp_cutoff, sidelobe, trans, gain)
%LOWPASS  Lowpass filtering
%
%	[FILT] = LOWPASS(LP_CUTOFF)
%	[FILT] = LOWPASS(LP_CUTOFF, SIDELOBE)
%	[FILT] = LOWPASS(LP_CUTOFF, SIDELOBE, TRANS)
%	[FILT] = LOWPASS(LP_CUTOFF, SIDELOBE, TRANS, GAIN)
%
%	LP_CUTOFF: normalized cutoff frequency  (nyquist = 1)
%	SIDELOBE[60]: hight of sidelobe of lowpass filter
%	TRANS[0.05]: normalized transition width 
%	GAIN[1.0]: gain

if nargin < 2
  sidelobe = 60.0;
end
if nargin < 3
  trans = 0.05;
end
if nargin < 4
  gain = 1.0;
end

filt = lowhighpass(-1.0, lp_cutoff, 0, sidelobe, trans, gain);
