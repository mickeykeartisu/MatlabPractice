function [found_phone, found_phone_index, offset] = findphone(phonelist, string, offset)

string = deblank(string);

if offset + 1 <= length(string) & string(offset) == string(offset + 1) ...
  & string(offset) ~= 'n' & string(offset) ~= 'a' & string(offset) ~= 'i' ...
  & string(offset) ~= 'u' & string(offset) ~= 'e' & string(offset) ~= 'o',
  % sokuon processing is not implemented yet
  disp(['sokuon found: ' string(offset:offset+1) ' ' string]);
  % offset = offset + 1;
  string(offset) = 'Q';
elseif offset >= 3 & string(offset) == '^',
  disp(['chouon found: ' string(offset-1:offset) ' ' string]);
  string(offset) = string(offset-1);
end

if offset > size(string, 2),
  return;
end

found_phone_index = 0;

for jj = size(phonelist, 1):-1:1,
  phone = deblank(phonelist(jj, :));
  if offset + length(phone) - 1 > length(string),
    continue;
  end
  target = string(offset:(offset+length(phone)-1));
  % if strcmp(target, 'du'),
  if strcmp(target, phonelist(59,:)),
    %target = 'zu';
    target = phonelist(54,:);
  elseif strcmp(target, 'si'),
    target = phonelist(13,:);
  elseif strcmp(target, 'tu'),
    target = phonelist(19,:);
  elseif strcmp(target, phonelist(58,:)),
    % target = 'ji';
    target = phonelist(53,:);
  end
  
  foundindex = findstr(target, phone);
  
  % keyboard
  
  if ~isempty(foundindex),
    found_phone_index = jj;
    break;
  end
end

if found_phone_index <= 0,
  error(['Cannot find corresponding phone: ' deblank(string(offset:end))]);
else
  found_phone = deblank(phonelist(found_phone_index, :));
  offset = offset + max(length(found_phone), 1);
end
