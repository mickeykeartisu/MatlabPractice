%  test for interaction
%	30/April/2005 modification for Matlab v7.0 compatibility
		

%fftl=1024;
%fs=22050;
%shiftm=1;
winf=300;  % freaquency spread for manipulation
wint=20;   % temporal spread for manipulation

%nii=256;
%njj=200;
%nsg=zeros(nii,njj);
nsg=n2sgram;

mxn=max(max(20*log10(nsg)));
%imagesc(max(20*log10(nsg),mxn-50));axis('xy');colormap(1-gray);
%keyboard;
hold on

np=0;
bb=0;
xp=[];yp=[];
while ~(bb == 13)
  [xx,yy,bb]=ginput(1);
  if (bb == 8) & (length(xp)>0)
    xp=xp(1:max(length(xp)-1,1));
    yp=yp(1:max(length(yp)-1,1));
  else
    xp=[xp;xx];
    yp=[yp;yy];
  end;
end;

plot(xp,yp,'r',xp,yp,'or')
hold off;

nsg=nsg*0;
nn=length(xp);
for ii=1:nn-1
  dx=xp(ii+1)-xp(ii);
  dy=yp(ii+1)-yp(ii);
  if abs(dx)>= abs(dy)
    deltay=dy/dx;
    for jj=xp(ii):dx/abs(dx):xp(ii+1)
	  nsg(yp(ii)+deltay*(jj-xp(ii)),jj)=nsg(yp(ii)+deltay*(jj-xp(ii)),jj)+1;
	end;
  else
    deltax=dx/dy;
    for jj=yp(ii):dy/abs(dy):yp(ii+1)
	  nsg(jj,xp(ii)+deltax*(jj-yp(ii)))=nsg(jj,xp(ii)+deltax*(jj-yp(ii)))+1;
	end;
  end;
end;

nsgm=zeros(nii,njj);
%nmth=18;
%nmfh=26;
nmth=winf/fs*fftl;
nmfh=wint/shiftm;
wmt=hanning(nmth*2+1);
wmf=hanning(nmfh*2+1);
wmt=wmt/max(wmt);
wmf=wmf/sum(wmf);

for ii=1:nii
  hh=conv(wmt,nsg(ii,:));
  nsgm(ii,:)=hh((1:njj)+nmth);
end;

for jj=1:njj
  vv=conv(wmf,nsgm(:,jj));
  nsgm(:,jj)=vv((1:nii)+nmfh);
end;



