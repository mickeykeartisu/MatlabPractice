function [n2sgram,nsgram,nwsgram]= ...
    straightBodyB04(x,fs,shiftm,fftl,f0raw,eta,pc);

%	[n2sgram,nsgram,nwsgram]= ...
%		   straightBodyB04(x,fs,shiftm,fftl,f0raw,eta,pc);
%	n2sgram		: smoothed spectrogram
%	nsgram		: isometric spectrogram
%	nwsgram		: wide-band spectrogram
%	x		: input waveform
%	fs		: sampling frequency (Hz)
%	shiftm		: frame shift (ms)
%	fftl		: length of FFT
%	f0raw		: Pitch information to gude analysis (TEMPO) assumed
%	pcorr		: complex fundamental correlation in subbands
%	f0varL		: envelope fundamental correlation in subbands
%	eta		: temporal stretching constant from isotropy
%	pc		: exponent for nonlinearity

%	STRAIGHT body:  Interporation using adaptive gaussian weighting
%	and 2-dimensional Bartlett window
%	by Hideki Kawahara
%	02/July/1996
%	07/July/1996
%	07/Sep./1996 
%	09/Sep./1996 guiding F0 information can be coarse
%	14/Oct./1996 correction for over smoothing
%	19/Oct./1996 Alternating Gaussian Correction
%	01/Nov./1996 Temporal integration using Fluency theory (didn't work)
%	03/Nov./1996 Temporal integration using Fluency theory
%	25/Dec./1996 Quasi optimum smooting
%	01/Feb./1997 Minimum variance analysis
%	03/Feb./1997 Clean up
%	08/Feb./1997 Fine tuning for onset enhancement
%	13/Feb./1997 another fine temporal structure
%	16/Feb./1997 better alternating Gaussian
%	21/Feb./1997 no need for temporal interpolation!
%	19/June/1997 Control of Analysis Paramters
%	21/July/1997 Discard of optimum comp. and introduction TD compensation
%	11/Aug./1997 Re-installation of temporal smooting
%	24/Nov./1997 Simplified version to be worked with new source info

f0l=f0raw;
framem=40;
fx=((1:fftl)-fftl/2-1)/fftl*fs;
framel=round(framem*fs/1000);
if fftl<framel
  disp('Warning! fftl is too small.');
  fftl=2^ceil(log(framel)/log(2) );
  disp(['New length:' num2str(fftl) ' is used.']);
end;
x=x(:)';
smoothingind=1;
if shiftm >1.5
  disp('Frame shift has to be small enough. (Less than 1 ms is recommended.)');
  disp('Temporal smoothing is disabled');
  smoothingind=0;
end;
shiftl=shiftm*fs/1000;

[b,a]=butter(6,70/fs*2,'high');
xh=filter(b,a,x);
rmsp=std(xh);

%tx=[zeros(1,framel/2),xh];
tx=[randn(1,framel/2)*rmsp/4000,xh,randn(1,framel)*rmsp/4000];
txs=tx;

%datalength=length(tx);
%nframe=floor((datalength-framel)/shiftl);
nframe=min(length(f0l),round(length(x)/shiftl));

nsgram=zeros(fftl/2+1,nframe);  % adaptive spectrogram
n2sgram=zeros(fftl/2+1,nframe);

t=([1:framel]-framel/2)/framel*2;
wx=(exp(-(4*t).^2/2));
tt=([1:framel]-framel/2)/fs;
refw=sum(wx);

bbase=1:fftl/2+1;

zerobase=zeros(1,fftl);
ist=1; ii=1;
f0x=f0l*0;

% Optimum blending table for interference free spec.
cfv=[1.03 0.83 0.67 0.54 0.43 0.343 0.2695];
muv=[1    1.1  1.2  1.3  1.4  1.5   1.6];

bcf=spline(muv,cfv,eta);

% Calculate the optimum smoothing function coefficients

ovc=optimumsmoothing(eta,pc);

% Design windows for unvoiced

fc= 300;  % default frequency resolution for unvoiced signal
c0=4*exp(-pi/2);
t0=1/fc;
wxec=exp(-pi*(tt*fc).^2);
cfc=sqrt(sum(wxec.^2));
wxec=wxec/cfc;  
wxdc=bcf*wxec.*sin(pi*tt/t0); 

ttm=[0.00001 1:fftl/2 -fftl/2+1:-1]/fs;
bfq=fftl:-1:2;
ffq=2:fftl;

%while (ist+framel<datalength) & (ii<=min(length(f0l),nframe))
for ii=1:nframe
  if rem(ii,10)==0
    fprintf('o')
    if rem(ii,200)==0
       fprintf('\n')
    end;
  end;
  idf0=max(1,ii);
  f0=f0l(idf0);
  f0x(ii)=f0;
  t0=1/f0;

  wxe=exp(-pi*(tt/t0/eta).^2);

  cf=sqrt(sum(wxe.^2));
  wxe=wxe/cf;
  wxd=bcf*wxe.*sin(pi*tt/t0);

%  tma=fft((tx(round(ist:ist+framel-1))-mean(tx(round(ist:ist+framel-1)))).*wxe,fftl);
%  tmb=fft((tx(round(ist:ist+framel-1))-mean(tx(round(ist:ist+framel-1)))).*wxd,fftl);
%  pw=sqrt(abs(tma).^2+abs(tmb).^2).^pc;
  iix=round(ist:ist+framel-1);
  pw=sqrt(abs(fft((tx(iix)-mean(tx(iix))).*wxe,fftl)).^2+ ...
          abs(fft((tx(iix)-mean(tx(iix))).*wxd,fftl)).^2).^pc;

  nsgram(:,ii)=pw(bbase)';

%  local level equalization

  ww2=max(0,1-abs(fx/f0/3));
  spw2=real(ifft(fft(fftshift(ww2/sum(ww2))).*fft(pw)));

%	Optimum weighting

%  ww=ovc(1)*max(0,1-abs(fx/f0)) ...
%     + ovc(2)*(max(0,1-abs((fx-f0)/f0))+max(0,1-abs((fx+f0)/f0))) ...
%     + ovc(3)*(max(0,1-abs((fx-2*f0)/f0))+max(0,1-abs((fx+2*f0)/f0)));% ...

%  spw=real(ifft(fft(fftshift(ww/sum(ww))).*fft(pw./spw2)));

  wwt=(sin(ttm/t0*pi)./(ttm/t0*pi)).^2.*(ovc(1)+ovc(2)*2*cos(ttm/t0*2*pi) ...
     +ovc(3)*2*cos(ttm/(t0/2)*2*pi));
  spw=real(ifft(wwt.*fft(pw./spw2)))/wwt(1);

%  ****** TRY! ROEX ******* with scaling
%  This has to be replaced by log(2*cosh(x))

%  spw=0.25*(log(2*cosh(spw*4/1.4))*1.4+spw*4)/2;

%  spw=spw.*spw2;
%  n2sgram(:,ii)=spw(bbase)';

  n2sgram(:,ii) = (spw2(bbase).*(0.25*(log(2*cosh(spw(bbase)*4/1.4))*1.4+spw(bbase)*4)/2))';

%  ii=ii+1;
  ist=ist+shiftl;
end;
f0x(ii:length(f0l))=f0+f0x(ii:length(f0l))*0;
fprintf('\n')

nsgram=nsgram.^(1/pc);
n2sgram=n2sgram.^(2/pc);

[snn,smm]=size(n2sgram);
[nii,njj]=size(n2sgram);
nwsgram=0*n2sgram;

%lamb=0.25./(f0var+0.25);
%lambL=0.25./(f0varL+0.25);

fqx=(0:snn-1)/snn*fs/2;
chigh=1.0./(1+exp(-(fqx-600)/100))';
clow=1.0-chigh;

tx=txs;
for ii=1:njj
  if rem(ii,10)==0
    fprintf('*')
    if rem(ii,200)==0
       fprintf('\n')
    end;
  end;
  idf0=max(1,ii);
%  ist=min((ii-1)*fs*shiftm/1000+1,datalength-framel-1);
  ist=(ii-1)*fs*shiftm/1000+1;
%  tma=fft((tx(round(ist:ist+framel-1))-mean(tx(round(ist:ist+framel-1)))).*wxec,fftl);
%  tmb=fft((tx(round(ist:ist+framel-1))-mean(tx(round(ist:ist+framel-1)))).*wxdc,fftl);
%  pw=abs(tma).^2+abs(tmb).^2;
  iix=round(ist:ist+framel-1);
  pw=(abs(fft((tx(iix)-mean(tx(iix))).*wxec,fftl)).^2+ ...
          abs(fft((tx(iix)-mean(tx(iix))).*wxdc,fftl)).^2);
%  n2sgram(:,ii)=chigh.*(lamb(ii)*n2sgram(:,ii)+(1-lamb(ii))*pw(bbase)') ...
%               +clow.*(lambL(ii)*n2sgram(:,ii)+(1-lambL(ii))*pw(bbase)');
%  f0x(ii)=lambL(ii)*f0x(ii)+(1-lambL(ii))*300;
  nwsgram(:,ii)=pw(bbase)';
end;

if smoothingind
  nssgram=n2sgram;

  lowestf0=40;

  tunitw=ceil(1.1*(1000/shiftm)/lowestf0);
  tx=(-tunitw:tunitw)';
  cumfreq=cumsum(f0x)/(1000/shiftm);
  t0x=(1000/shiftm)./f0x;

  bb=(1:length(tx))';
  for jj=1:min(length(f0l),njj)
    txx=cumfreq(min(njj,max(1,jj+tx)))-cumfreq(jj);
    txt=(tx+jj>0).*(tx+jj<=njj);
    idx=(abs(txx)<=1.1).*bb.*txt;
    idx=idx(idx>0);
    txx=txx(idx);
    wt=max(0,1-abs(txx));
    wt=wt.*f0x(min(njj,max(1,jj+tx(idx)+1)));
    wt=wt.*(abs(f0x(jj)-f0x(jj+tx(idx)))/f0x(jj)<0.25);
    n2sgram(:,jj)=nssgram(:,min(njj,max(1,jj+tx(idx))))*wt/sum(wt);
  end;
end;
n2sgram=abs(n2sgram);
n2sgram=sqrt(n2sgram);
nwsgram=sqrt(abs(nwsgram));
fprintf('\n')
