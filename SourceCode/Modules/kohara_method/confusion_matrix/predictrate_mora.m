function [N, dist, predicted_rate_list] = predictrate_mora(word_rate_list, mora_rate_list)

% rangemin = 1; rangemax = 10;
%rangemin = eps; rangemax = 1;
rangemin = eps; rangemax = 10;

[N, dist] = fminbnd(@ratedistfunc_mora, rangemin, rangemax, [], ...
  word_rate_list, mora_rate_list);

if nargout >= 3,
  predicted_rate_list = predictfunc_mora(mora_rate_list, N);
end
