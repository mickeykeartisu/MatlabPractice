function [wav_new, thresh_start, thresh_fin] = wavcut(wav, Fs, frame_ms, shift_ms, frame_n, filt)

frame_len = (Fs/1000) * frame_ms;
shift_len = (Fs/1000) * shift_ms;

%thresh
thresh_start = -80;
thresh_fin = -91;

[rms_m] = rms_cmand(wav, Fs, frame_ms, shift_ms);

[~, start] = max(rms_m(1: floor(length(rms_m)/4)));
m = start;
frame_pos = m * shift_len;

while (start ~= 1)
    if (rms_m(m-1) <= rms_m(m))
        if (rms_m(m-2) >= rms_m(m-1) && rms_m(m-2) <= thresh_start)
            start = frame_pos - shift_len;
            break;
        else
            frame_pos = frame_pos - shift_len;
            m = m-1;
        end
    else
        frame_pos = frame_pos - shift_len;
        m = m-1;
    end
end

finish = floor(length(rms_m)*3/4);
m = finish;
frame_pos = m * shift_len;

while (finish ~= (frame_n * shift_len + frame_len))
    if(rms_m(m) <= thresh_fin)
        finish = frame_pos + shift_len*2;
        break;
    else
        frame_pos = frame_pos + shift_len;
        m = m+1;
    end
end

if (nargin == 6)
    fin_new = finish + floor(length(filt)/2) + 1;
    if (length(wav) <= fin_new)
        wav_r = zeros((fin_new - length(wav)), 1);
        for k = 1: (fin_new - length(wav))
            wav_r(k) = eps;
        end
        wav = [wav; wav_r];
    end
    finish = fin_new;
end

wav_new = wav(start: finish);

end