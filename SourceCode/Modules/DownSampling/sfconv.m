function [osig, ofs, filt, up, down] = sfconv(isig, ifs, ofs, cutoff, sidelobe, transition, tolerance)
%SFCONV  Sampling frequency conversion
%
%	[OSIG, OFS] = SFCONV(ISIG, IFS, OFS)
%	[OSIG, OFS, FILT, UP, DOWN] = SFCONV(ISIG, IFS, OFS)
%	[OSIG, OFS, FILT, UP, DOWN] = SFCONV(ISIG, IFS, OFS, CUTOFF)
%	[OSIG, OFS, FILT, UP, DOWN] = SFCONV(ISIG, IFS, OFS, CUTOFF, SIDELOBE)
%	[OSIG, OFS, FILT, UP, DOWN] = SFCONV(ISIG, IFS, OFS, CUTOFF, SIDELOBE, TRANSITION)
%	[OSIG, OFS, FILT, UP, DOWN] = SFCONV(ISIG, IFS, OFS, CUTOFF, SIDELOBE, TRANSITION, TOLERANCE)
%
%	ISIG, OSIG: input/output signal
%	IFS, OFS: input/output sampling frequency
%	CUTOFF[0.95]: normalized cutoff frequency of lowpass filter (nyquist = 1)
%	SIDELOBE[60]: hight of sidelobe of lowpass filter
%	TRANSITION[0.05]: normalized transition width 
%	TOLERANCE[2.0]: tolerance in percentage

if nargin < 4
  cutoff = 0.95;
end
if nargin < 5
  sidelobe = 60.0;
end
if nargin < 6
  transition = 0.05;
end
if nargin < 7
  tolerance = 2.0;
end

need_transpose = 0;
nch = min(size(isig));
if nch <= 2 && size(isig, 1) == nch
    isig = isig';
end

[up, down, ofs] = getsfcratio(ifs, ofs, tolerance / 100.0);

ratio = max(up, down);
cutoff = cutoff / ratio;
transition = transition / ratio;

filt = lowpass(cutoff, sidelobe, transition, up);

for ch = 1:nch ,
  upsig = myupsample(isig(:, ch), up);

  filsig = myfftfilt(filt, upsig);

  osig(:, ch) = mydownsample(filsig, down, floor(length(filt) / 2), floor(length(isig) * up / down));
end

if need_transpose 
    osig = osig';
end

return;

function [up, down, new_fs] = getsfcratio(ifs, ofs, tolerance)

up =  round(ofs .* 100.0);
down = round(ifs .* 100.0);
div = gcd(up, down);
up = up ./ div;
down = down ./ div;
tolerance = tolerance .* up;

if tolerance == 0.0 | (up < 10 & down < 10)
  flag = 0;
else
  flag = 1;
end

ii = 1;
while ii <= up & flag == 1 , 
  jj = 1;
  while jj <= down & flag == 1 , 
    x = abs(down * ii - up * jj);
    
    if x <= tolerance
      up = ii;
      down = jj;
      flag = 0;
    end
  
    jj = jj + 1;
  end

  ii = ii + 1;
end

new_fs = ifs * up / down;

return;

function osig = myupsample(sig, upratio)

osig = zeros(length(sig) * upratio, 1);

for ii = 1:length(sig) ,
  osig(1 + (ii - 1) * upratio) = sig(ii);
end

return;

function osig = mydownsample(sig, downratio, offset, length)

if nargin < 4 | length <= 0
  length = floor((size(sig, 1) - offset) / downratio);
end
osig = zeros(length, 1);

for ii = 1:length ,
  pos = (ii - 1) * downratio + offset;
  if pos < size(sig, 1) & pos >= 0
    osig(ii) = sig(pos + 1);
  else
    osig(ii) = 0.0;
  end
end  
  
return;
