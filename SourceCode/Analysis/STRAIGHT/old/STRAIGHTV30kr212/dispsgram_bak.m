function dispsgram(sgram, fs, shiftm, titlestr)
%DISPSGRAM  Display spectrogram
%	DISPSGRAM(SGRAM, FS);
%	DISPSGRAM(SGRAM, FS, SHIFTM);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR);
%	SGRAM:		specgrogram
%	FS:		sampling frequency
%	SHIFTM:		frame shift in msec
%	TITLESTR:	title string of figure

if nargin < 3,
  shiftm=1.0;
end
mxil=max(max(20*log10(sgram+0.001)));
[nsy,nsx]=size(sgram);

figure;
imagesc((0:nsx-1)*shiftm,(0:nsy-1)/nsy*fs/2,...
	max(real(20*log10(sgram+0.001)),mxil-50));
axis('xy'); colormap(1-gray);

if nargin >= 4,
  title(titlestr);
end
xlabel('time (ms)');
ylabel('frequency (Hz)');
