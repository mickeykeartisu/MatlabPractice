function [sig_gain, splmean, gain] = getSig4SplNormalization(sig, fs, compensate_db, setDB, region, format)
% function [sig_gain gaindB] = getSig4SplNormalization(sig, fs, compensate_db, setDB, mode,region, format)
% Laの平均で音圧を正規化するかLaの最大値で正規化するかを選択できるように変更（小原：2017/11/02）
% [sig_gain] = getGain4SPLnormalization(sig, fs, compensate_db, setDB, region, format)
% 所望の音圧レベル
% if nargin < 5,
%     mode = 'mean';
% end

if nargin < 5,
    region_p = [1 length(sig)];
else
    if nargin < 6,
        format = 'point';
    end
        
    if strcmp(format, 'msec'),
        region_p = 1 + (region * fs / 1000);
    elseif strcmp(format, 'sec'),
        region_p = 1+ region * fs;
    else
        region_p = region;
    end
end
% 信号の平均Laを求める
[spl] = getsplsig(sig, fs, compensate_db, 'fast', 'A');
spl_lim = spl(region_p(1):region_p(2));
% figure
% plot(spl_lim)
% keyboard

spl_delinf = spl_lim(spl_lim~=-inf);

% if strcmp(mode,'mean') == 1,
%     splmean = mean(spl_delinf);
%     gaindB = setDB - splmean;
% elseif strcmp(mode,'max') == 1,
%     splmax = max(spl_delinf);
%     gaindB = setDB - splmax;
% end

splmean = mean(spl_delinf);

% keyboard
gaindB = setDB - splmean;
gain = 10.^(gaindB/20);
sig_gain = sig * gain;

