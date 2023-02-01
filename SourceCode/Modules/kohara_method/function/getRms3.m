function [ rmsV ] = getRms3(x,flame)
%引数：入力音声,fftポイント数,フレーム長
%入力音声に対して窓かけを行い実効値を求め、その値を戻り値とする

i = 0:flame-1;
haming = 0.54-0.46*cos(2*i*pi/(flame-1)); %ハミング窓定義
H = x.*haming';


% fft = fft(H',fftpoint);


% ps = (abs(fftH).^2);
% ps = sqrt(ps(1:flame));
% 
% rmsV = ps;


% powerSpectrum = abs(fftH).^2;
% 
% rmsV = 20*log10(rms(H));
rmsV = rms(H);
end

