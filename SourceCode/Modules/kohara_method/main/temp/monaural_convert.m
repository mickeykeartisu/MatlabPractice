

input_name = 'G:\Test_session1_48kHz.wav';
output_name = 'G:\Test_session1_48kHz_2ch.wav';

x_m =  audioread(input_name);

info = audioinfo(input_name);

fs = info.SampleRate;
nbit = info.BitsPerSample;

x_s = zeros(length(x_m),2);

x_s(:,1) = x_m;
% x_s(:,2) = x_m;

audiowrite(output_name,x_s,fs, 'BitsPerSample',nbit);

