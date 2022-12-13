function [f0_mean] = rms_f0(wav, Fs, sound_type, takasa_no)

save_filename = 'C:/work/matlab/prog_tsukuda/lab_sound_f0/';

%[value, index] = max(abs(wav));
t=(0: length(wav)-1)/Fs;
fig = figure('visible', 'off');
%figure;

min_f0 = 100;
max_f0 = 500;

subplot(2,1,1); plot(t,wav);
xlabel('Time [s]','FontSize',14); ylabel('Amplitude','FontSize',14);
title([num2str(sound_type) '-' num2str(takasa_no) 'の時間波形'],'FontSize',14);
set(gca,'FontSize',12);

%caliculate f0
[f0raw, ~] = exstraightsource(wav, Fs);




%setting of the x axis
x = (0: length(f0raw)-1)/1000;

%initialisation of the count
ave_count = 0;
count = 0;

%average of f0
for ii=1:length(f0raw)
    if f0raw(ii) >= min_f0 && f0raw(ii) <= max_f0
        ave_count = ave_count + f0raw(ii);
        count = count + 1;
    end
end

%average of f0
f0_mean = ave_count / count;

subplot(2,1,2); plot(x,f0raw);
xlabel('Time [s]','FontSize',14); ylabel('Frequency [Hz]','FontSize',14);
title([num2str(sound_type) '-' num2str(takasa_no) 'の基本周波数'],'FontSize',14);

set(gca,'FontSize',12);

%saveas(fig, [ num2str(save_filename) num2str(sound_type) '-' num2str(takasa_no) '-f0.png']);
end
