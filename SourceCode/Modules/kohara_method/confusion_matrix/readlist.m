function list = readlist(fname)
fid = fopen(fname,'r');
if fid == -1,
  return;
end

list = [];

while 1
  tline = fgetl(fid);
  if ~ischar(tline), 
    break;
  end
  
  if isempty(tline),
    list = strvcat(list, ' ');
    
  elseif tline(1) ~= '#' , 
    % disp(tline);
    [a count] = sscanf(tline, '%s');
    
    % remove comment
    commindex = zeros(1,1);
    while 1,
      commindex = findstr(a(commindex(1)+1:end), '#');
      if isempty(commindex) | commindex(1) < 2,
	break;
      elseif a(commindex(1) - 1) == '\\',
	continue;
      else
	a = deblank(a(1:(commindex(1)-1)));
	break;
      end
    end
    
    list = strvcat(list, a);
    
    %if count > 1,
    %  keyboard;
    %end
  end
end

fclose(fid);
