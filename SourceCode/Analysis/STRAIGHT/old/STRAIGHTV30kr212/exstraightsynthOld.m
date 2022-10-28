function sy = exstraightsynth(f0raw,n3sgram,ap,fs,pconv,fconv,sconv)
%   Synthesis using STRAIGHT parameters with linear modifications
%   sy = exstraightsynth(f0raw,n2sram,ap,fs,pconv,fconv,sconv)
%   Input parameters
%   f0raw   : fundamental frequency (Hz) 
%   n3sgram : STRAIGHT spectrogram (in absolute value)
%   ap      : aperiodic component (dB re. to total power)
%   fs      : sampling frequency (Hz)
%   pconv   : F0 conversion ratio
%   fconv   : frequency axis conversion ratio
%   sconv   : time axis conversion ratio
%   (default frame rate is 1ms)
%   Output parameters
%   sy      : synthesized speech
%
%   This routine is coded only for providing an example for how to use
%   STRAIGHT functions. More flexible scheme should be introduced soon.

%   Designed and coded by Hideki Kawahara
%   15/January/2005
%	30/April/2005 modification for Matlab v7.0 compatibility

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

%---- initialize default synthesis parameters
delsp=0.5; 	%  standard deviation of random group delay in ms 26/June/2002
gdbw=70; 	% smoothing window length of random group delay (in Hz)
%	  cornf=3000;  	% corner frequency for random phase (Hz)
cornf=4000;  	% corner frequency for random phase (Hz) 26/June 2002
delfrac=0.2;  % This parameter should be revised.
delfracind=0;

sy=straightSynthTB07ca(n3sgram,f0raw,shiftm,fs, ...
    pconv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind,ap,1); % 8/April/2002
dBsy=powerchk(sy,fs,15); % 23/Sept./1999
cf=(20*log10(32768)-22)-dBsy;
sy=sy*(10.0.^(cf/20));
