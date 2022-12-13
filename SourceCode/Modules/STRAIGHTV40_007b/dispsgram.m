function dispsgram(sgram, fs, shiftm, titlestr, fontsize, rangedb, maxdb)
%DISPSGRAM  Display spectrogram
%	DISPSGRAM(SGRAM, FS);
%	DISPSGRAM(SGRAM, FS, SHIFTM);
%	DISPSGRAM(SGRAM, FS, SHIFTM, FONTSIZE);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR, FONTSIZE);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR, FONTSIZE, RANGEDB, MAXDB);
%	SGRAM:		amplitude specgrogram
%	FS:		sampling frequency
%	SHIFTM:		frame shift in msec
%	TITLESTR:	title string of figure
%	FONTSIZE:	font size of figure

if nargin < 4
  titlestr = '';
end

if nargin <= 4 && ischar(titlestr) == 0,
  fontsize = titlestr;
  titlestr = '';
elseif nargin < 5,
  fontsize = 12;
end
if fontsize <= 0,
  fontsize = 12;
end

if nargin < 3,
  shiftm=1.0;
end

if nargin < 6,
  rangedb=50.0;
end

dbsgram=real(20*log10(sgram+0.001));
if nargin < 7,
  mxil=max(max(dbsgram));
else
  dbsgram = min(dbsgram, maxdb);
  mxil = maxdb;
end
[nsy,nsx]=size(sgram);

imagesc((0:nsx-1)*shiftm, (0:nsy-1)/nsy*fs/2, max(dbsgram, mxil-rangedb));
set(gca, 'FontSize', fontsize);
axis('xy'); colormap(1-gray);

if nargin >= 4 && ischar(titlestr),
  title(titlestr);
end
xlabel('Time [ms]', 'FontSize', fontsize);
ylabel('Frequency [Hz]', 'FontSize', fontsize);
