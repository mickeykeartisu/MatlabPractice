function [ rmsV ] = getRms3(x,flame)
%�����F���͉���,fft�|�C���g��,�t���[����
%���͉����ɑ΂��đ��������s�������l�����߁A���̒l��߂�l�Ƃ���

i = 0:flame-1;
haming = 0.54-0.46*cos(2*i*pi/(flame-1)); %�n�~���O����`
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

