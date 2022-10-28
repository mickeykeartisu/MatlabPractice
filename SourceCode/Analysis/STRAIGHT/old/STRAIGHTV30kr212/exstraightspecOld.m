function n3sgram=exstraightspec(x,f0raw,fs)
%   Spectral information extraction for STRAIGHT
%   [n3sgram,ap]=exstraightspec(x,f0raw,fs)
%   Input parameters
%   x   : input signal. only the first channel is analyzed
%   f0raw   : fundamental frequency (Hz) in 1 ms temporal resolution
%           : set 0 for aperiodic part
%   fs  : sampling freuency (Hz)
%   Output parameters
%   n3sgram : Smoothed time frequency representation (spectrogram)
%   This routine is coded only for providing an example for how to use
%   STRAIGHT functions. More flexible scheme should be introduced soon.

%   Designed and coded by Hideki Kawahara
%   15/January/2005

%   Initialize parameters
%f0floor=40;
%f0ceil=800;
%fs=22050;	% sampling frequency (Hz)
framem=40;	% default frame length for pitch extraction (ms)
shiftm=1;       % default frame shift (ms) for spectrogram
%f0shiftm=1;     % default frame shift (ms) for F0 information
fftl=1024;	% default FFT length
eta=1.4;        % time window stretch factor
pc=0.6;         % exponent for nonlinearity
mag=0.2;      % This parameter should be revised.
framel=framem*fs/1000;

if fftl < framel
    fftl=2^ceil(log(framel)/log(2));
end;
fftl2=fftl/2;

[nr,nc]=size(x);
if nr>nc
    xold=x(:,1);
else
    xold=x(1,:)';
end;
imageOn=0; % Display indicator. 0: No graphics, 1: Show graphics

%---- Spectral estimation

xamp=std(xold);
scaleconst=2200; % magic number for compatibility 15/Jan./2005
xold=xold/xamp*scaleconst;
f0var=1; f0varL=1; % These are obsolate dummy variables. meaningless
[n2sgrambk,nsgram]=straightBodyC03ma(xold,fs,shiftm,fftl,f0raw,f0var,f0varL,eta,pc);
if mag>0
    n3sgram=specreshape(fs,n2sgrambk,eta,pc,mag,f0raw);
else
    n3sgram=n2sgrambk;
end;
n3sgram=n3sgram/scaleconst*xamp;


