function [ s_p, e_p ] = getSilentTime( sig, fs, thre_gain )
%GETSILENTTIME 音声の前後の無音区間のポイントを検出

sig_spl = getsplsig(sig,fs,0,'fast','A');

%前
thre_p = floor(length(sig)/3);
[sig_max, sig_max_p] = max(sig_spl(1:thre_p));
spl_thre  = sig_max - thre_gain;

for s_p = sig_max_p:-1:1,
    if spl_thre > sig_spl(s_p),
        break
    end
end


%後
thre_p = floor(2*length(sig)/3);
[sig_max, sig_max_p] = max(sig_spl(thre_p:end));
spl_thre  = sig_max - thre_gain;

for e_p = sig_max_p:1:length(sig_spl),
    if spl_thre > sig_spl(e_p),
        break
    end
end

end

