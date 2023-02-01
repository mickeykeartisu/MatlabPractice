function [ th_dB ] = getTh_dB( LogCep )
%GETTH_DB è‡’l‚ğ•Ô‚·ŠÖ”
max_buf = zeros(1,size(LogCep,1));
for i = 1:size(LogCep,1)
    max_buf(i) = max(LogCep(i,:));   
end

keyboard
th_dB = mean(max_buf);

th_dB = th_dB/2;
end

