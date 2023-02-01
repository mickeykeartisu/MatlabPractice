threshold_dB = 9;
ratio = Inf;
kneeWidth_dB = 6;

if 1
    x_dB = -100:0.1:20;
    x = 10 .^ (x_dB / 20);
    plot(x);
    
    [y, gain, y_dB] = softlimit(x, threshold_dB, ratio, kneeWidth_dB);

    plot(x_dB, y_dB);
else
    x = 0:0.001:4;
    y = 4 * sin(2 * pi * x);
    [y2, gain, y_dB]= softlimit(y, threshold_dB, ratio, kneeWidth_dB);
    plot(x, y, x, y2);
%     figure
%     plot(y_dB);
end

% figure
% y = audioread('No1_S02_16kHz.wav');
% [y2, gain, y_dB]= softlimit(y, threshold_dB, ratio, kneeWidth_dB);
% plot(y,'b');
% hold on 
% plot(y2,'r');
% hold off
% 
% figure
% plot(20 * log10(abs(y)));