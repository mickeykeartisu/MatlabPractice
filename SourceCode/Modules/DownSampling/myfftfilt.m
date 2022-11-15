function [y] = myfftfilt(b, x, fftl)

if nargin < 3
  fftl = 512;
end

if length(x) < length(b)
  baselen = length(x) + length(b) - 1;
else
  baselen = length(b);
end
fftl = 2 .^ nextpow2(max(2 * baselen, fftl));

block = fftl - length(b) + 1;
nloop = max(floor((length(x) + block - 1) / block), 1);
olength = length(x) + length(b) - 1;

% FFT of filter
b_f = fft(b, fftl);

pos = 0;
y = zeros(olength, 1);
x2 = zeros(size(b_f));

% main loop
for ii = 1:nloop,
  len = min(block, length(x) - pos);
  x2(1:len) = x(pos+1:pos+len);
  x2(len+1:end) = 0;
  
  x_f = fft(x2, fftl);
  
  xc_f = x_f .* b_f;
  xc = real(ifft(xc_f, fftl));
  
  olen = min(length(xc), olength - pos);
  idx = (pos+1):(pos+olen);
  y(idx) = y(idx) + xc(1:olen);
  
  pos = pos + block;
end
