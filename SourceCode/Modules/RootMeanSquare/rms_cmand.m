function [rms_db] = rms_cmand(wav, Fs, frame_ms, shift_ms)
%normalization?

frame_len = (Fs/1000) * frame_ms;
shift_len = (Fs/1000) * shift_ms;

w = 0.54 - 0.46 * cos(2 * (0: frame_len-1) * pi / frame_len);

frame_n = floor((length(wav)/(Fs/1000)-frame_ms) / shift_ms);
%frame_n = (length(wav) - frame_len)/shift_len;

rms_m = zeros(frame_n, 1);

frame_pos = 1;

for m = 1: frame_n
        %calculate the RMS value for each frame
        rms_m(m) = rms(wav(frame_pos: frame_pos + frame_len-1).*w');
        %update frame_pos
        frame_pos = frame_pos + shift_len;
end
rms_db = 20*log10(rms_m);
end