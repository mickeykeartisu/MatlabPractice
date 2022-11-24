function label = sploadlabel(filename, format, fs)
% SPLOADLABEL  Load a label file for spwave
% 
% 	LABEL = SPLOADLABEL(FILENAME);  for 'sec' label
% 	LABEL = SPLOADLABEL(FILENAME, FORMAT);
% 	LABEL = SPLOADLABEL(FILENAME, 'point', FS);  for 'point' label
%	LABEL: Label structure for spwave
%	FORMAT:	Time format ('sec', 'msec', or 'point'). Defalt: 'sec'
%	FS: Sampling frequency for point

if nargin <= 1
    format = 'sec';
end
if strcmpi(format, 'point') | strcmpi(format, 'pt')
    if nargin < 3
	fs = 8000.0;
    end
end

[timestr, phoneme, data] = textread(filename, '%q%q%q', 'commentstyle', 'shell');

if isempty(data)
    data = '';
end

% time = sscanf(char(timestr)', '%f');
time = zeros(size(timestr));
for k = 1:size(timestr, 1),
    time(k, 1) = sscanf(char(timestr(k, :)), '%f');
end

if strcmpi(format, 'msec') | strcmpi(format, 'ms')
    time = time ./ 1000.0;
elseif strcmpi(format, 'point') | strcmpi(format, 'pt')
    time = time ./ fs;
end
label = struct('time', num2cell(time)', 'phoneme', phoneme', 'data', data');
