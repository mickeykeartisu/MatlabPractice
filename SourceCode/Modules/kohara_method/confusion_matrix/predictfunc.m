function predicted_rate_list = predictfunc(vowel_rate_list, consonant_rate_list, ...
  N, vc_ratio)

% averaging
% predicted_rate_list = ((vowel_rate_list + consonant_rate_list) ./ 2).^N;

predicted_rate_list = ((vc_ratio .* vowel_rate_list + (1.0 - vc_ratio) .* consonant_rate_list)).^N;

% predicted_rate_list = (vowel_rate_list .* consonant_rate_list).^N;

% predicted_rate_list = ((vowel_rate_list .* consonant_rate_list).^4) .* ((1.0 - N).^3);

% predicted_rate_list = ((vowel_rate_list .* consonant_rate_list).^4) .* ((1.0 ./ N).^4);
% predicted_rate_list = ((N .* vowel_rate_list .* consonant_rate_list).^4);
