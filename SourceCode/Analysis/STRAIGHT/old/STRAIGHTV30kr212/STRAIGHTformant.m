%   Test program for formant extraction based on STRAIGHT
%   Designed and coded by Hideki Kawahara
%   31/Jan./2003
%	30/April/2005 modification for Matlab v7.0 compatibility
		
global n3sgram f0raw fs shiftm f0shiftm fname

fsn=10000;  % hypothetical sampling frequency (Hz)
[n,m]=size(n3sgram);
fx=[0:n-1]/(n-1)/2*fs;
fnx=[0:512]/1024*fsn;
p=16;  % analysis order (tentative)

%--- make the normalized spectrogram for fsn

spg=interp1(fx,n3sgram,fnx);
ct=cos([0:1023]'/1024*2*pi);
cf=sum(ct.*ct);

ii=150;

bwm=zeros(p,m);
frmm=zeros(p,m);

for ii=1:m
ff=[spg(:,ii);spg(end-1:-1:2,ii)];
c0=sum(20*log10(ff).*ct)/cf;
nff=10.0.^((20*log10(ff)-ct*c0)/20);
v=real(ifft(nff));
r=zeros(p,p);
for kk=1:p;for jj=1:kk;r(kk,jj)=v(kk-jj+1);r(jj,kk)=r(kk,jj);end;end;
ar=inv(r)*v(2:p+1);
rt=roots([1;-ar]);
frm=angle(rt)/2/pi*fsn;
bw=-log(abs(rt))/pi*fsn;
frmm(:,ii)=frm;
bwm(:,ii)=bw;
end;

figure;
plot((1:m)*shiftm,frmm,'c.');grid on;hold on;
plot((1:m)*shiftm,frmm.*((bwm<1000)),'r+');
plot((1:m)*shiftm,frmm.*((bwm<500)),'k*');

axis([0 m 0 fsn/2]);
title(['formant candidates for: ' fname ' with p=' num2str(p) '  ' date])
xlabel('time (ms)');
ylabel('frequency');
