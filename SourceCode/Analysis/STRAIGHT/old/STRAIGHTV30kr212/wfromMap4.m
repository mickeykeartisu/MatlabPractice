function wvm3=wfromMap4(pcorr,pecorr,n2sgram,fs)
%	weighting matrix from map


emap=max(pcorr,pecorr);
[nii,njj]=size(emap);
lf0=40; 
[nfq,nll]=size(n2sgram);
fqv=((1:nfq)-1)*fs/(nfq*2-2);
mpvstep=sqrt(2);  % ratio between adjucent channels

mpv=1;
nch=floor(log(fs/2/lf0)/log(mpvstep));
wvm3=zeros(nch,nfq);
fqv(1)=0.01;

for jj=1:nch
  lfqv=log(fqv/(1.253*lf0*mpv))/log(sqrt(3)); % 1.3 is an emphilical magic number
  if jj==nch
	  lfqv=min(lfqv,0);
  end;
  if jj==1
	  lfqv=max(lfqv,0);
  end;
  wvm3(jj,:)=((1+cos(pi*lfqv.*(abs(lfqv)<1)))/2-(abs(lfqv)>=1));
%  semilogx(fqv,wv);title(num2str(mpv*lf0,10));drawnow;pause
  mpv=mpv*mpvstep;
end;

cfv=1.0./sum(wvm3+0.01);
for jj=1:nch
	wvm3(jj,:)=wvm3(jj,:).*cfv;
end;

