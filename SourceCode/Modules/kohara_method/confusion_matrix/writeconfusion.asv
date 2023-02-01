function writeconfusion(phonelist, confusionfile, confusion_matrix)

fid = fopen(confusionfile, 'w');

num_column = size(confusion_matrix, 2);
num_column = min(size(phonelist, 1) + 2, num_column);

% header
fprintf(fid, '  , ');
for ii = 1:num_column,
  if ii > size(phonelist, 1),
    if ii == num_column,
      fprintf(fid, 'Sum');
    elseif ii == (num_column - 1),
      fprintf(fid, 'Null, ');
    end
  else
    fprintf(fid, '%s, ', deblank(phonelist(ii, :)));
  end
end
fprintf(fid, '\n');

% body
for ii = 1:size(phonelist, 1),
  fprintf(fid, '%s, ', deblank(phonelist(ii, :)));
  fprintf(fid, '%f, ', confusion_matrix(ii,1:end-1)');
  fprintf(fid, '%f', confusion_matrix(ii,end)');
  fprintf(fid, '\n');
end

fclose(fid);
