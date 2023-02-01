function [sigma_v, marg] = getPeakf2Sigma(peak_f, marg, sigma_interval, fchara_flag)

if nargin<2,
    marg = 200;
end
if nargin<3,
%     sigma_interval = 0.1;
    sigma_interval = 1;
end
if nargin<4,
    fchara_flag = 0;
end

x = -marg:1:marg;

% sig_v = 5:sigma_interval:60; % 5ms->44.8Hz, 60ms->3.7Hz
% sig_v = 14:sigma_interval:57; % 14ms->16.1Hz, 57ms->3.9Hz
sig_v = 1:sigma_interval:57; % 14ms->16.1Hz, 57ms->3.9Hz

freq_v = zeros(length(sig_v),1);
% plot(getNormalDistribution(x, sig_v(end)))

for k=1:length(sig_v), % k:all count sigma number
    
    sigma = sig_v(k);
    
    % ���K���z
    f_nd = getNormalDistribution(x, sigma);
    
    % �����̓���
    fftl = 1024*10;
    %     [h, f] = freqz(f_nd, 1, fftl, 1000); % 2nd_diff
    %     [h_dd, f] = freqz([-1 2 -1], 1, fftl, 1000); % ���K���z
    %     h_mix = abs(h) .* abs(h_dd);    % �����̓���
    [h_mix, f] = freqz4log(f_nd, fftl, 1000);
    
    [h_max, h_idx] = max(h_mix); % ���g�������̃s�[�N�̃C���f�b�N�X�̌���
    freq_v(k) = f(h_idx); % ���g�������̃s�[�N�̎��g���̊i�[
    
end

% plot(sig_v, freq_v)
% setLabel('sigma [ms]', 'peak Hz', '')

% �t�B���^�̍ő�l�����߂邽�߂�signma�̃C���f�b�N�X�����߂�
% peak_f = [5 15 25]; % ���̒l�ɍł��߂�
for l = 1:length(peak_f),
    [tmp, minidx(l)] = min(abs(freq_v - peak_f(l)));
end

sigma_v = sig_v(minidx);

% ���g�������v�����g�p

if fchara_flag,
    for m = 1:length(sigma_v),

        sigma = sigma_v(m);
        
        marg = sigma * 5;
        x = -marg:1:marg;
        % ���K���z
        f_nd = getNormalDistribution(x, sigma);
        
        % �����̓���
        [h_mix, f, h_nd, h_dd] = freqz4log(f_nd, fftl, 1000);
        [h_max, h_idx] = max(h_mix);
        
        figure(1), clf
        plot(f, 20*log10(abs(h_dd)), 'b:', 'linewidth', 2)
        hold on
        plot(f, 20*log10(abs(h_nd)), 'k:', 'linewidth', 2)
        plot(f, 20*log10(h_mix), 'r', 'linewidth', 2)
        grid on
        xlim([0 100])
        ylim([-200 0])
        set(gca, 'fontsize', 14)
        setLabel('Frequency [Hz]', 'Gain [dB]', ...
            ['PeakFreq=' num2str(round(f(h_idx)), '%0.1f') '[Hz]', 'sigma=' num2str(round(sigma)) '[ms]', 'Gauslen=' round(num2str(marg*2)) '[ms]'] , 14)
        legend('Laplacian', 'Gaussian', 'LoG')
%         line([f(h_idx) f(h_idx)], [20*log10(h_max)-50 20*log10(h_max)], 'Color','g','LineWidth',1, 'LineStyle', '--')
%         line([0 100], [20*log10(h_max)-50 20*log10(h_max)-50], 'Color','g','LineWidth',1, 'LineStyle', '--')
%         line([0 100], [20*log10(h_max) 20*log10(h_max)], 'Color','g','LineWidth',1, 'LineStyle', '--')
        print(['freqz_PeakFreq_' num2str(round(f(h_idx)), '%02d') 'Hz_sigma_' ...
            num2str(round(sigma), '%02d') 'ms'], '-dmeta')
    end
    
end
