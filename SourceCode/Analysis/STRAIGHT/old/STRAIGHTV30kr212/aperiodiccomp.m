function ap=aperiodiccomp(apv,dpv,ashift,f0,nshift,fftl);

%   modified to add the waitbar on 08/Dec./2002

%[nn,mm]=size(nsgram);
mm=length(f0);
nn=fftl/2+1;
[n2,m2]=size(apv);

x=(0:m2-1)'*ashift;
xi=(0:mm-1)'*nshift;
xi=min(max(x),xi);

hpg=waitbar(0.1,'Interpolating periodicity information');
drawnow;
ap=interp1q(x,(dpv-apv)',xi)';%,'*linear')';
close(hpg);