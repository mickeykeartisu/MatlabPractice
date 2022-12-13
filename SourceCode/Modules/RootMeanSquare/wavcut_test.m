
sound_type = 'normal';
takasa_no = 1;

[wav, Fs] = audioread(['C:/work/matlab/folder_sound/' sound_type '-' num2str(takasa_no) '.wav']);
wav = (wav / max(abs(wav)))*0.5;

frame_ms = 30;
shift_ms = 10;

%frame_len = (Fs/1000) * frame_ms;
%shift_len = (Fs/1000) * shift_ms;

frame_n = floor((length(wav)/(Fs/1000)-frame_ms) / shift_ms);

[wav_new, thresh_start, thresh_fin] = wavcut(wav, Fs, frame_ms, shift_ms, frame_n);
[rms_db] = rms_cmand(wav_new, Fs, frame_ms, shift_ms);


t=(0: length(wav_new)-1)/Fs;
%fig = figure('visible', 'off');
figure
subplot(2,1,1); plot(t,wav_new);
xlim([0 3.5])
xlabel('Time [s]','FontSize',14); ylabel('Amplitude','FontSize',14);
title([sound_type '-' num2str(takasa_no) 'の時間波形'],'FontSize',14);
set(gca,'FontSize',12);

x = (0: length(rms_db)-1)*(shift_ms/1000);
subplot(2, 1, 2); plot(x, rms_db);
xlim([0 3.5]);
xlabel('Time [s]','FontSize',14); ylabel('Amplitude','FontSize',14);
title('RMS','FontSize',14);
set(gca,'FontSize',12);

audiowrite(['C:/work/matlab/prog_tsukuda/cut-sound/' sound_type '-' num2str(takasa_no) '-cut.wav'],  wav_new, Fs);
saveas(gcf, ['C:/work/matlab/prog_tsukuda/cut-sound/' sound_type '-' num2str(takasa_no) '-' ...
    num2str(thresh_start) '-' num2str(thresh_fin) '.fig']);
