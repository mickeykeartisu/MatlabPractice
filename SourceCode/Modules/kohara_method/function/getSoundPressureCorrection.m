function [ compensate_dB ] = getSoundPressureCorrection(inputDirName, calib_A_name, calib_B_name, calib_B__original_name, calib_A_dB, mode )
%GET_SOUNDPRESSURECORRECTION この関数の概要をここに記述
%   詳細説明をここに記述

if nargin < 6,
    mode = [];
end

sec =10;

% inputDirName = './calib_wav/';

[calib_A,fs]= audioread([inputDirName calib_A_name]);
calib_A = calib_A(1:fs*sec);
% calib_A = sfconv(calib_A,fs,fs_sig);

% [calib_A_noise,fs]= audioread([inputDirName 'calib_20s_07.wav']);
% calib_A_noise = calib_A(10*fs:fs*20);

[calib_B]= audioread([inputDirName calib_B_name]);
calib_B = calib_B(1:fs*sec);
% calib_B = calib_B(1:fs*10);
% calib_B = calib_B(fs*10+1:fs*20);
% calib_B = sfconv(calib_B,fs,fs_sig);

A_comp = getsplcompensation(calib_A,fs,calib_A_dB);
disp(['A_comp = ' num2str(A_comp)])

if strcmp(mode,'max') == 1,
    y_max_fact = floor(1 / max(abs(calib_B)));
    calib_B = y_max_fact * calib_B;
end

B_dB_levelsig = getsplsig(calib_B,fs,A_comp,'fast','A');

B_dB_level = max(abs(B_dB_levelsig));

% B_dB_level = mean(abs(B_dB_levelsig));


% 
% figure
% plot(calib_sin);
% figure
% plot(y_max);
[calib_B_ori,fs]= audioread([inputDirName calib_B__original_name]);
compensate_dB = getsplcompensation(calib_B_ori,fs,B_dB_level);
disp(['compensate_dB = ' num2str(compensate_dB)])
end

