function y = ratedistfunc_mora(N, word_rate_list, mora_rate_list)

predicted_rate_list = predictfunc_mora(mora_rate_list, N);

y = sqrt(mean((word_rate_list - predicted_rate_list).^2));
