function [compensate_db, y_max, y_max_fact, refdb, spl_max] = defCalibrationParams(y_ref, fs_ref, refdb, region_ref)
% [compensate_db, y_max, y_max_fact, refdb] = defCalibrationParams(y_ref, fs_ref, bit_ref, refdb, region_ref)


if nargin < 3,
    refdb = 95;
end
if nargin < 4,
    region_ref = [10*fs_ref length(y_ref)-10*fs_ref]; % �L�����u���[�^�̐M���̕���SPL�����߂���
end

% figure
% plot(y_ref(1:500));
% �L�����u���[�V�����M���̐U�����i�قځj�ő�ɂ���
y_max_fact = floor(1 / max(abs(y_ref)));
y_max = y_max_fact * y_ref;
y_ref = y_max;
% wavwrite(y_ref ,fs_ref , bit_ref, [calib_file '_maxfact_' num2str(y_max_fact)])

% figure
% plot(y_ref(1:500));
% keyboard

% �L�����u���[�^�M���̕���La�����߂遨�␳�l�����߂�
% �e�M���ɕ␳����l�iSPL��compensate_db�𑫂���refdb dB�ɂȂ�j
[compensate_db, spl_max] = getsplcompensation(y_ref, fs_ref, refdb, region_ref, 'fast', 'A');


% plot(10*log10(y_ref.^2))
% 
% 20*log10(sqrt(mean(y_ref.^2)))
% 
% flen = 30*fs_ref/1000;
% shift = 10*fs_ref/1000;
% frame_idx = 1:shift:length(y_ref)-flen+1;
% for   l=1:length(frame_idx),
% frame = y_ref(frame_idx(l):frame_idx(l)+flen-1);
% fmrame_pow(l) = mean(frame.^2);
% end
% 
% end
% 
% 10*log10(mean(fmrame_pow))
% 
% plot(10*log10(fmrame_pow))