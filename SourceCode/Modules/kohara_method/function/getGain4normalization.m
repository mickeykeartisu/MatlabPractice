function [gain_v, h_mix_max_dB_v, peak_f, marg] = getGain4normalization(sigma_v, set_gain_dB, marg_v)


if nargin<3,
    marg = 200;
    marg_v = ones(1, length(sigma_v)) * marg;
end


fftl = 1024*10;
h_mix_maxidx_v = zeros(length(sigma_v),1);
h_mix_max_v = zeros(length(sigma_v),1);

for k=1:length(sigma_v),
    
    x = -marg_v(k):1:marg_v(k);
    f_nd = getNormalDistribution(x, sigma_v(k));
%     figure
%     plot(f_nd)
    
    [h_mix, f, h_nd, h_dd] = freqz4log(f_nd, fftl, 1000);
%     figure
%     plot(f,h_nd)
%     title('h_nd')
%     figure
%     plot(f,h_dd)
%     title('h_dd')
%     figure
%     plot(f,h_mix)
%     title('h_mix')
%     
    [h_mix_max_v(k), h_mix_maxidx_v(k)] = max(h_mix);
    
    
    
    %     plot(f, 20*log10(abs(h_dd)), 'b:', 'linewidth', 2)
    %     hold on
    %     plot(f, 20*log10(abs(h_nd)), 'k:', 'linewidth', 2)
    %     plot(f, 20*log10(h_mix), 'r', 'linewidth', 2)
    %     grid on
    %     xlim([0 100])
    %     ylim([-300 0])
    %     set(gca, 'fontsize', 14)
    %     setLabel('Frequency [Hz]', 'Gain [dB]', ['sigma=' num2str(sigma_v(k)) '[ms], max\_freq=' num2str(f(h_mix_maxidx_v(k)), '%0.2f') '[Hz]'] , 14)
    %     legend('Laplacian', 'Gaussian', 'LoG')
    %     line([f(h_mix_maxidx_v(k)) f(h_mix_maxidx_v(k))], [20*log10(h_mix_max_v(k))-50 20*log10(h_mix_max_v(k))], 'Color','g','LineWidth',1, 'LineStyle', '--')
    %     line([0 100], [20*log10(h_mix_max_v(k))-50 20*log10(h_mix_max_v(k))-50], 'Color','g','LineWidth',1, 'LineStyle', '--')
    %     line([0 100], [20*log10(h_mix_max_v(k)) 20*log10(h_mix_max_v(k))], 'Color','g','LineWidth',1, 'LineStyle', '--')
    
end

h_mix_max_dB_v = 20*log10(h_mix_max_v);
peak_f = f(h_mix_maxidx_v);

% set_gain_dB = -10;
gaindB_v = set_gain_dB - h_mix_max_dB_v;

gain_v = 10.^(gaindB_v/20);
% keyboard