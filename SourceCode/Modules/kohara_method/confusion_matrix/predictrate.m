function [N, dist, predicted_rate_list] ...
= predictrate(word_rate_list, vowel_rate_list, consonant_rate_list, vc_ratio_list)

% rangemin = 1; rangemax = 10;
%rangemin = eps; rangemax = 1;
rangemin = eps; rangemax = 10;

[N, dist] = fminbnd(@ratedistfunc, rangemin, rangemax, [], ...
  word_rate_list, vowel_rate_list, consonant_rate_list, vc_ratio_list);

if nargout >= 3,
  predicted_rate_list = predictfunc(vowel_rate_list, consonant_rate_list, N, vc_ratio_list);
end
