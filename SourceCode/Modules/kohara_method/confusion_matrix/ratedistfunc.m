function y = ratedistfunc(N, word_rate_list, vowel_rate_list, consonant_rate_list, vc_ratio_list)

predicted_rate_list = predictfunc(vowel_rate_list, consonant_rate_list, N, vc_ratio_list);

y = sqrt(mean((word_rate_list - predicted_rate_list).^2));
