function [paramlist, valuelist] = readparam(fname)

fid = fopen(fname,'r');
if fid == -1,
  error(['Cannot open parameter file: ' fname]);
end

paramlist = [];
valuelist = [];

while 1,
  tline = fgetl(fid);
  
  while 1,
    if isspace(tline(end)),
      tline2 = deblank(tline);
    else
      tline2 = tline;
    end
    if ~isempty(tline2) & tline2(end) == '\\' ...
	& (length(tline2) < 2 | tline2(end-1) ~= '\\'),
      tline = [tline2(1:end-1) fgetl(fid)];
    else
      break;
    end
  end
  
  if ~ischar(tline), 
    break;
  end
  
  if isempty(tline),
    % do nothing
    
  elseif tline(1) ~= '#' , 
    % remove comment
    commindex = zeros(1,1);
    while commindex(1) < length(tline),
      commindex = findstr(tline(commindex(1)+1:end), '#');
      if isempty(commindex) | commindex(1) < 2,
	break;
      elseif tline(commindex(1) - 1) == '\\',
	tline = [tline(1:commindex(1)-2) tline(commindex(1):end)];
	continue;
      else
	tline = tline(1:(commindex(1)-1));
	break;
      end
    end
    
    [param, value] = strtok(tline);
    if length(param) > 0,
      paramlist = strvcat(paramlist, param);
      if length(value) < 2,
	valuelist = strvcat(valuelist, ' ');
      else
	valuelist = strvcat(valuelist, value(2:end));
      end
    end
  end
end

fclose(fid);
