function spplotlabel(label, format, fs, linespec, fontsize)
% SPPLOTLABEL  Plot labels to the current window
%
%	SPPLOTLABEL(LABEL, FORMAT);			
%	SPPLOTLABEL(LABEL, FORMAT, LINESPEC);	
%	SPPLOTLABEL(LABEL, FORMAT, LINESPEC, FONTSIZE);
%	SPPLOTLABEL(LABEL);				for 'sec' label
%	SPPLOTLABEL(LABEL, LINESPEC);  			for 'sec' label
%	SPPLOTLABEL(LABEL, LINESPEC, FONTSIZE);  	for 'sec' label
%	SPPLOTLABEL(LABEL, 'point', FS);			for 'point' label
%	SPPLOTLABEL(LABEL, 'point', FS, LINESPEC);		for 'point' label
%	SPPLOTLABEL(LABEL, 'point', FS, LINESPEC, FONTSIZE);	for 'point' label
%	LABEL: Label structure for spwave
%	FORMAT:	Time format in target figure ('sec', 'msec', or 'point'). Defalt: 'sec'.
%	LINESPEC: Line specification same as in `plot' function
%	FONTSIZE: Font size. Default: 16.
%	FS: Sampling frequency for point

h = get(0, 'CurrentFigure');

if isempty(h)
    % return if no figure
    return
end

ispoint = 0;
ismsec = 0;
issec = 0;
color = 'b';
defaultfontsize = 16;

if nargin <= 1
    format = 'sec';
    linespec = color;
    fontsize = defaultfontsize;
    issec = 1;
else
    if (strcmpi(format, 'point') | strcmpi(format, 'pt'))
	ispoint = 1;
    elseif (strcmpi(format, 'msec') | strcmpi(format, 'ms'))
	ismsec = 1;
    elseif (strcmpi(format, 'sec') | strcmpi(format, 's'))
	issec = 1;
    end

    if ~ispoint & ~ismsec & ~issec
	linespec = format;
	if nargin >= 3
	    fontsize = fs;
	else
	    fontsize = defaultfontsize;
	end
	issec = 1;
    elseif ~ispoint
	if nargin >= 3
	    linespec = fs;
	else
	    linespec = color;
	end
	if nargin >= 4
	    fontsize = linespec;
	else
	    fontsize = defaultfontsize;
	end
    else
	if nargin < 4
	    linespec = color;
	end
	if nargin < 5
	    fontsize = defaultfontsize;
	end
    end
end

colorstr = 'rgbcmykw';
for k = 1:length(colorstr),
    if ~isempty(findstr(colorstr(k), linespec))
	color = colorstr(k);
	break;
    end
end

orighold = ishold;

v = axis;

xmin = v(1, 1);
xmax = v(1, 2);
ymin = v(1, 3);
ymax = v(1, 4);
xoffset = abs(xmax - xmin) / 200.0;
yoffset = abs(ymax - ymin) / 40.0;

hold on

X = [];
Y = [];
for k = 1:length(label),
    if ismsec
	t = 1000.0 .* label(k).time;
    elseif ispoint
	t = round(label(k).time .* fs);
    else
	t = label(k).time;
    end
    if t >= xmax
	break;
    elseif t >= xmin
	tt = [t; t];
	X = [X tt];
	yy = [ymin; ymax];
	Y = [Y yy];
	text(t + xoffset, ymax - yoffset, label(k).phoneme, ...
	     'FontSize', fontsize, 'Color', color, 'VerticalAlignment', 'Top');
	% text(t, ymin, label(k).phoneme);
    end
end

plot(X, Y, linespec);

if orighold == 0
    hold off
end
