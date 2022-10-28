function spsavelabel(filename, label, format, fs)
% SPSAVELABEL  Save a label file for spwave
% 
% 	SPSAVELABEL(FILENAME, LABEL);  for 'sec' label
% 	SPSAVELABEL(FILENAME, LABEL, FORMAT);
% 	SPSAVELABEL(FILENAME, LABEL, 'point', FS);  for 'point' label
%	LABEL: Label structure for spwave
%	FORMAT:	Time format ('sec', 'msec', or 'point'). Defalt: 'sec'
%	FS: Sampling frequency for point

fid = fopen(filename, 'wt');
if fid == -1
    return;
end

if nargin <= 2
    format = 'sec';
end
if strcmpi(format, 'point') | strcmpi(format, 'pt')
    if nargin < 4
	fs = 8000.0;
    end
end

for n=1:length(label)
    if strcmpi(format, 'msec') | strcmpi(format, 'ms')
	time = label(n).time ./ 1000.0;
	fprintf(fid, '%.3f %s %s\n', time, label(n).phoneme, label(n).data);
    elseif strcmpi(format, 'point') | strcmpi(format, 'pt')
	time = round(label(n).time ./ fs);
	fprintf(fid, '%.0f %s %s\n', time, label(n).phoneme, label(n).data);
    else
	fprintf(fid, '%f %s %s\n', label(n).time, label(n).phoneme, label(n).data);
    end
end

fclose(fid);
