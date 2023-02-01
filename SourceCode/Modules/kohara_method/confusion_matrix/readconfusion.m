function confusion_matrix = readconfusion(confusionfile, phonelist)

fid = fopen(confusionfile, 'r');

% read header
tline = fgetl(fid);

sum_included = 0;

phonelistread = [];
ii = 1; remain = tline;
while ~isempty(remain),
  if ii == 1 & remain(1) == ',',
    token = ' ';
  else
    [token, remain] = strtok(remain, ',');
  end
  
  if length(token) > 1 & isspace(token(1)) & ~isspace(token(2)),
    token = token(2:end);
  end
  
  % token
  % remain
  
  if strncmpi(deblank(token), 'Sum', 3),
    sum_included = 1;
    break;
  end
  
  if ii > 1,
    phonelistread = strvcat(phonelistread, token);
  end
  ii = ii + 1;
end

if isempty(deblank(phonelistread(end,:))) & isempty(deblank(phonelistread(end-1,:))),
  phonelistread = phonelistread(1:end-1,:);
end

if nargin <= 1,
  phonelist = phonelistread;
elseif nargin >= 2 & size(phonelistread, 1) ~= size(phonelist, 1),
  error('size of phonelist is different.');
end

if sum_included,
  col_size = size(phonelist, 1) + 1;
else
  col_size = size(phonelist, 1);
end
confusion_matrix = zeros(size(phonelist, 1), col_size);

% keyboard


% read body
row = 1;
while 1,
  tline = fgetl(fid);
  if tline == -1 | isempty(tline),
    break;
  end
  
  ii = 1; remain = tline;
  while ~isempty(remain),
    if ii == 1 & remain(1) == ',',
      token = ' ';
    else
      [token, remain] = strtok(remain, ',');
    end
%    if row == size(phonelist, 1),
%      keyboard
%    end
    
    if ii > 1,
      confusion_matrix(row, ii - 1) = sscanf(token, '%f');
    end
    ii = ii + 1;
  end
  
  row = row + 1;
end

fclose(fid);

%keyboard