close all

wide_framem = 3.33;
narrow_framem = 22.2;

framem = wide_framem;
%framem = narrow_framem;
shiftm = framem / 4;

if exist('audioread')
    [sig, fs] = audioread('F009_ATR503_A01_T01.wav');
else
    [sig, fs] = wavread('F009_ATR503_A01_T01.wav');
end

label = sploadlabel('F009_ATR503_A01_T01.mk', 'sec');

x = (0:length(sig)-1) ./ fs;

plot(x, sig);
axis([1.0 2.2 -1.0 1.0]);
spplotlabel(label, 'b:');

framel = round(framem * fs / 1000)
shiftl = round(shiftm * fs / 1000)
fftl = max(2 .^ nextpow2(framel), 256);
figure

spglinespec='k:';
if exist('spectrogram')
    spectrogram(sig, hamming(framel), framel - shiftl, fftl, fs, 'yaxis');
    colormap jet
    spglinespec='r:';
else
    specgram(sig, fftl, fs, hamming(framel), framel - shiftl);
    axis([1.0 2.2 0.0 fs/2]);
end
spplotlabel(label, spglinespec);

spsavelabel('F009_ATR503_A01_T01_lab.txt', label);
