function spplotsimplelabel(label, varargin)
% SPPLOTSIMPLELABEL  Plot simple labels to the current window
%
%	SPPLOTSIMPLELABEL(LABEL, FORMAT);			
%	SPPLOTSIMPLELABEL(LABEL, FORMAT, LINESPEC);	
%	SPPLOTSIMPLELABEL(LABEL, FORMAT, LINESPEC, FONTSIZE);
%	SPPLOTSIMPLELABEL(LABEL);				for 'sec' label
%	SPPLOTSIMPLELABEL(LABEL, LINESPEC);  			for 'sec' label
%	SPPLOTSIMPLELABEL(LABEL, LINESPEC, FONTSIZE);  	for 'sec' label
%	SPPLOTSIMPLELABEL(LABEL, 'point', FS);			for 'point' label
%	SPPLOTSIMPLELABEL(LABEL, 'point', FS, LINESPEC);		for 'point' label
%	SPPLOTSIMPLELABEL(LABEL, 'point', FS, LINESPEC, FONTSIZE);	for 'point' label
%	LABEL: Simple labels including time only
%	FORMAT:	Time format in target figure ('sec', 'msec', or 'point'). Defalt: 'sec'.
%	LINESPEC: Line specification same as in `plot' function
%	FONTSIZE: Font size. Default: 16.
%	FS: Sampling frequency for point

labelstruct = struct('time', num2cell(label), 'phoneme', [], 'data', []);
%spplotlabel(labelstruct, format, fs, linespec, fontsize);
spplotlabel(labelstruct, varargin{:});
