function [pcorr,pecorr]=BcorrMap(xold,fs,f0raw,shiftm);
%    [pcorr,pecorr]=BcorrMap(xold,fs,f0raw,shiftm);
%    xold        % input signal
%    fs          % sampling frequency (Hz)
%    f0raw       % raw F0 estimate (Hz)
%    shiftm      % frame shift (ms)

%    Check correlation 
%    for Each band
%    Designed and Coded by Hideki Kawahara
%    Copyright (c) ATR/Wakayama Univerisity/CREST 1997
%    23/Nov./1997
%	 25/Nov./1977 bug fix

%t0im=12000.0./f0raw;
t0im=round(fs./f0raw);
lx=length(xold);
wdur=0.05;  % minimum window duration in second
mpvstep=sqrt(2);  % ratio between adjucent channels
lf0=40; % center frequency of the lowest channel
fshiftl=shiftm/1000*fs;

nff=2^ceil(log(fs*wdur)/log(2));
tb=zeros(1,nff);
tf=zeros(1,nff);
vwf=zeros(1,nff);
vwb=zeros(1,nff);
nch=floor(log(fs/2/lf0)/log(mpvstep));

pcorr=zeros(nch,length(f0raw));
pecorr=zeros(nch,length(f0raw));
lcorr=zeros(1,length(f0raw));
lecorr=zeros(1,length(f0raw));
gent=((1:nff)-nff/2)/fs;
mpv=1;
mu=1.3;
tpw=1/lf0;

for jj=1:nch
  t=gent*mpv;
  wd=exp(-pi*(t/tpw).^2).*exp(2*pi*i*(t/tpw));
  xbl=fftfilt(wd,[diff(xold),zeros(1,nff)]);
  xbl=xbl((1:length(xold))+nff/2);
for ii=1:length(f0raw)
  nww=length(0:t0im(ii));
%  ww=hanning(nww)';
  vwf(1:nww)=xbl(round(min(lx,max(1,ii*fshiftl+(-t0im(ii):0)))));
  vwb(1:nww)=xbl(round(max(1,min(lx,ii*fshiftl+(0:t0im(ii))))));
%  vwf(1:nww)=(vwf(1:nww)-mean(vwf(1:nww)));
%  vwb(1:nww)=(vwb(1:nww)-mean(vwb(1:nww)));
%  tb=tb*0;tf=tf*0;
%  tb(1:nww)=vwb;tf(1:nww)=vwf;
%  lcorr(ii)=abs(sum(tb.*tf))/sqrt(sum(abs(tb).^2)*sum(abs(tf).^2));
  lcorr(ii)=abs(sum(vwb(1:nww).*conj(vwf(1:nww))))/ ...
       sqrt(sum(abs(vwb(1:nww)).^2)*sum(abs(vwf(1:nww)).^2));
  vwf(1:nww)=(abs(vwf(1:nww))-mean(abs(vwf(1:nww))));
  vwb(1:nww)=(abs(vwb(1:nww))-mean(abs(vwb(1:nww))));
  lecorr(ii)=sum(vwb(1:nww).*vwf(1:nww))/ ...
       sqrt(sum((vwb(1:nww)).^2)*sum((vwf(1:nww)).^2));
end;
  pcorr(jj,:)=lcorr;
  pecorr(jj,:)=lecorr;
  mpv=mpv*mpvstep;
end;
