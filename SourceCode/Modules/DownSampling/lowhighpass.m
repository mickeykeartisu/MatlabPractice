function [filt] = lowhighpass(hp_cutoff, lp_cutoff, bandlimit, sidelobe, trans, gain)
%LOWHIGHPASS  lowpass and highpass filtering 
%
%	[FILT] = LOWHIGHPASS(HP_CUTOFF, LP_CUTOFF)
%	[FILT] = LOWHIGHPASS(HP_CUTOFF, LP_CUTOFF, BANDLIMIT)
%	[FILT] = LOWHIGHPASS(HP_CUTOFF, LP_CUTOFF, BANDLIMIT, SIDELOBE)
%	[FILT] = LOWHIGHPASS(HP_CUTOFF, LP_CUTOFF, BANDLIMIT, SIDELOBE, TRANS)
%	[FILT] = LOWHIGHPASS(HP_CUTOFF, LP_CUTOFF, BANDLIMIT, SIDELOBE, TRANS, GAIN)
%
%	HP_CUTOFF: normalized cutoff frequency of highpass filter (nyquist = 1)
%	LP_CUTOFF: normalized cutoff frequency of lowpass filter (nyquist = 1)
%	BANDLIMIT[0]: flag if bandlimit filter is generated
%	SIDELOBE[60]: hight of sidelobe of lowpass filter
%	TRANS[0.05]: normalized transition width 
%	GAIN[1.0]: gain

if nargin < 3
  bandlimit = 0;
end
if nargin < 4
  sidelobe = 60.0;
end
if nargin < 5
  trans = 0.05;
end
if nargin < 6
  gain = 1.0;
end

% get kaiser parameter 
[beta, filtlen] = getkaiserparam(sidelobe, trans);

% make sure length is odd 
filtlen = floor(filtlen / 2) * 2 + 1;
hfiltlen = (filtlen - 1) / 2;

% create kaiser window
filt = mykaiser(filtlen, beta);


if hp_cutoff >= 0.0
  
  for ii = 1:filtlen ,
    % calculate highpass filter 
    if (bandlimit | lp_cutoff < 0.0) & ii - 1 == hfiltlen 
      hp_value = 1.0 - hp_cutoff;
    else
      hp_value = -mysincc(pi * hp_cutoff * (ii - 1 - hfiltlen), hp_cutoff);
    end
    
    if lp_cutoff < 0.0
      lp_value = 0.0;
    else
      % calculate lowpass filter 
      lp_value = mysincc(pi * lp_cutoff * (ii - 1 - hfiltlen), lp_cutoff);
    end
    filt(ii, 1) = filt(ii, 1) .* (hp_value + lp_value) * gain;
  end
  
else
  
  % calculate lowpass filter 
  for ii = 1:filtlen ,
    lp_value = mysincc(pi * lp_cutoff * (ii - 1 - hfiltlen), lp_cutoff);
    filt(ii, 1) = filt(ii, 1) .* lp_value .* gain;
  end
  
end

return;

function a = mysincc(x, c)

if x == 0.0
  a = c;
else
  a = (c * sin(x)) / x;
end

return;