function dispsgram_color(sgram, fs, shiftm, titlestr, fontsize, freqinterbal, timeinterbal, fre_range, rangedb, maxdb)
%DISPSGRAM  Display spectrogram
%	DISPSGRAM(SGRAM, FS);
%	DISPSGRAM(SGRAM, FS, SHIFTM);
%	DISPSGRAM(SGRAM, FS, SHIFTM, FONTSIZE);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR, FONTSIZE);
%	DISPSGRAM(SGRAM, FS, SHIFTM, TITLESTR, FONTSIZE, RANGEDB, MAXDB);
%	SGRAM:		specgrogram
%	FS:		sampling frequency
%	SHIFTM:		frame shift in msec
%	TITLESTR:	title string of figure
%	FONTSIZE:	font size of figure

if nargin < 3,
  shiftm=1.0;
end

if nargin < 4
  titlestr = '';
end

if nargin <= 4 & ischar(titlestr) == 0,
  fontsize = titlestr;
  titlestr = '';
elseif nargin < 5,
  fontsize = 12;
end
if fontsize <= 0,
  fontsize = 12;
end

if nargin < 6,
  freqinterbal = 5000;
end
if nargin < 7,
  timeinterbal = 500;
end
[nsy,nsx]=size(sgram);

if nargin < 8
  fre_range = fs/2;
end

if nargin < 9,
  rangedb=50.0;
end

dbsgram=real(20*log10(sgram+0.001));
if nargin < 10,
  mxil=max(max(dbsgram));
else
  dbsgram = min(dbsgram, maxdb);%引数の最大値以上の値→引数の最大値
  mxil = maxdb;
end


imagesc((0:nsx-1)*shiftm, (0:nsy-1)/nsy*fs/2, max(dbsgram, mxil-rangedb),[mxil-rangedb maxdb]); %スケーリングを固定する場合
% imagesc((0:nsx-1)*shiftm, (0:nsy-1)/nsy*fs/2, max(dbsgram, mxil-rangedb));
set(gca, 'FontSize', fontsize);
% axis('xy'); colormap(1-gray);
axis('xy'); colormap('default');

if nargin >= 4 & ischar(titlestr),
  title(titlestr);
end
%%%変更開始%%%
% xlabel('Time [ms]', 'FontSize', fontsize);
% ylabel('Frequency [Hz]', 'FontSize', fontsize);
%%%変更終了%%%

%%%変更開始%%%
limy = floor(fre_range/1000);
freqend = freqinterbal*floor(fre_range/freqinterbal);
axis('xy')
ylim([0 fre_range])
xlabel('Time [ms]', 'FontSize', fontsize);
ylabel('Frequency [kHz]', 'FontSize', fontsize);
set(gca, 'XTick', 0:timeinterbal:nsx);
set(gca, 'YTick', 0:freqinterbal:freqend);
set(gca, 'YTicklabel', 0:freqinterbal/1000:limy);
h = colorbar; % カラーバーの表示（ハンドル h 取得）
ylabel(h,'Amplitude [dB]', 'FontSize', fontsize) % 表示対象とするハンドルを指定してY軸ラベルの表示
%%%変更終了%%%



