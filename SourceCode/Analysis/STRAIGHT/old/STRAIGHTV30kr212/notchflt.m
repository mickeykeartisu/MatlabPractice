function y=notchflt(x,fc,bw,fs)
%	Notch filtering for AC noise
%	y=notchflt(x,fc,bw,fs);
%		x	: input signal
%		fc	: AC frequency (Hz) 50 or 60 in Japan
%		bw	: 3dB band width (Hz) 5 maybe recommended
%		fs	: sampling frequency (Hz)
%
%	Example usage to cancel 50 Hz AC interference 
%
%	(After reading file input the following commands.)
%
%	global xold fs
%	xold=notchflt(xold,50,5,fs);
%
%	(Then you can start source analysis (again).)

%	01/August/1999

a1=-2*cos(2*pi*fc/fs);
a2=1;
aa1=-2*cos(2*pi*fc/fs)*exp(-pi*bw/fs);
aa2=exp(-2*pi*bw/fs);

y=filter([1 a1 a2],[1 aa1 aa2],x);
