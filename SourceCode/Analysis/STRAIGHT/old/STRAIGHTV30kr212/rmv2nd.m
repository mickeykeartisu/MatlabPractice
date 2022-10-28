function n3sgram=rmv2nd(n2sgram,f0raw,fs);
%    n2sgram        : STRAIGHT-core smoothed spectrum
%    f0raw          : F0 data (Hz)
%    fs             : sampling frequency (Hz)

%    Remove second-order structure from the STRAIGHT-core spectrum
%    codec and designed by Hideki Kawahara
%    copyright (c) 1997 by ATR, Wakayama Universit and CREST
%    15/Nov./1997

[mm,nn]=size(n2sgram);
ttl=([1:mm,mm-1:-1:2]-1)'/fs;
ffl=0*ttl;
n3sgram=n2sgram;

for ii=1:nn
  t0v=1/f0raw(ii);
  wl=1-0.9*(((1-cos(ttl/t0v*2*pi))/2).^20);
  ffl=exp(real(ifft(wl.*fft(log([n2sgram(:,ii);n2sgram(mm-1:-1:2,ii)])))));
  n3sgram(:,ii)=ffl(1:mm);
end;
