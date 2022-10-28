function [xn,idx]=fixf0conv(xold,f0raw,fs,f0shiftm,f0tgt)
%	convert signal into a constant F0 signal
%	with f0tgt as the constant
%	[xn,idx]=fixf0conv(xold,f0raw,fs,f0shiftm,f0tgt)
% Input paramters
%	xold	: input signal
%	f0raw	: extracted F0 (Hz) 
%	fs		: sampling frequency (Hz)
%	f0shiftm	: frame shift period (ms)
%	f0tgt	: target F0 (Hz)
% Output paramters
%	xn		: converted speech with constant F0
%	idx		: reference position on new time axis
%			  that corresponds to the original frame
%			  position at every 'f0shiftm' interval.
%	desiged and coded by Hideki Kawahara
%	05/Jan./2001

f0=f0raw;
f0(f0raw==0)=f0(f0raw==0)+mean(f0raw(f0raw>0));
phi=cumsum(2*pi*f0/(1000/f0shiftm));
phi=phi-phi(1);
tx=(0:length(xold)-1)/fs;
txf=(0:length(f0)-1)/1000*f0shiftm;
if tx(end)>txf(end)
	txf=[txf tx(end)];
	phi=[phi phi(end)+2*pi*f0tgt/fs];
end;
phit=interp1(txf,phi,tx);
phnew=0:2*pi*f0tgt/fs:phit(end);
xn=interp1(phit,xold,phnew);
idx=interp1(phnew,1:length(phnew),phi);
