function imap=makeimap(orgpos,synthpos,opts)
%	Piece-wise time axis mapping 
%	*** WARNING *** Prior to run this routine you have to
%		perform GUI STRAIGHT analysis. This routine shares
%		global variables
%	imap=makeimap(orgpos,synthpos,opts)
% input parameters
%	orgpos		: list of anchor points of the original speech (ms)
%	synthpos	: list of anchor points of the manipulated speech (ms)
%	opts		: 0: calculates imap only
%				: 1: calculates imap and re-synthesis
%					This updates re-synthesized speech "sy".
% output parameters
%	imap		: mapping table from re-synth time (sample) to the
%					original time (frame number)

%	23/Dec./2000 by Hideki Kawahara
%	30/April/2005 modification for Matlab v7.0 compatibility

global fs f0shiftm f0raw n3sgram pcnv fcnv sconv 
global gdbw delfrac delsp cornf delfracind 
global apv dpv fconv shiftm sy fftl

imap=[];
if size(orgpos)~=size(synthpos)
	disp('number of the anchor points must be the same!');
	return;
end;
if length(orgpos)<1
	disp('table must have at least one anchor point.');
	return
end;
orgpos=orgpos(:);
synthpos=synthpos(:);
stpf0=0;
edpf0=(length(f0raw)-1)*f0shiftm;
if (orgpos<stpf0)|(orgpos>edpf0)
	disp('anchor points must be within the original duration');
	return
end;
if (length(orgpos)>1)&((diff(orgpos)<=0)|(diff(synthpos)<=0))
	disp('anchor points must be monotonic')
	return
end;
if max(orgpos)<edpf0
	orgpos=[orgpos;edpf0];
	if length(synthpos)==1
		synthpos=[synthpos;max(max(synthpos)+1,edpf0)];
	else
		synthpos=[synthpos;max(synthpos)+1];
	end;
end;
if min(orgpos)>stpf0
	orgpos=[stpf0;orgpos];
	synthpos=[stpf0;synthpos];
end;
otm=0:1000/fs:max(synthpos);
imap=interp1(synthpos,orgpos,otm);
imap=imap/f0shiftm+1;

switch length(opts)
case 1
	if opts(1)==1
		sy=straightSynthTB06ca(n3sgram,f0raw,f0shiftm,fs, ...
			pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind, ...
			aperiodiccomp(apv,dpv,5,f0raw,f0shiftm,fftl),imap); 
		dBsy=powerchk(sy,fs,15);
		cf=(20*log10(32768)-22)-dBsy;
		sy=sy*(10.0.^(cf/20));
	end;
end;





