function [xspcmat, yspcmat] = plotalignedcep(xcepmat, ycepmat, map, fs, shiftm)

xspcmat = convceptospc(xcepmat);
yspcmat = convceptospc(ycepmat);

subplot(3, 1, 1); ldispsgram(xspcmat(:,1:length(map)), fs, shiftm, 'Spectrogram of test');
subplot(3, 1, 2); ldispsgram(yspcmat(:,map), fs, shiftm, ...
			    'Spectrogram of aligned reference');
subplot(3, 1, 3); ldispsgram(yspcmat, fs, shiftm, 'Spectrogram of reference');


function [spcmat] = convceptospc(cepmat, fftl)

if nargin < 2,
  fftl = 512;
end
nframe = size(cepmat, 2);

spcmat = zeros(fftl/2+1, nframe);
ceporder = size(cepmat, 1);
zeropad = zeros(fftl-(ceporder*2-1), 1);
for ii = 1:nframe,
  cep = [cepmat(:, ii); zeropad ; cepmat(end:-1:2, ii)];
  spc = exp(real(fft(cep, fftl)));
  spcmat(:, ii) = spc(1:size(spcmat, 1));
end

return;

function ldispsgram(sgram, fs, shiftm, titlestr)

dbsgram=20*log10(sgram+0.001);
mxil=max(max(dbsgram)); [nsy,nsx]=size(sgram);

imagesc((0:nsx-1)*shiftm, (0:nsy-1)/nsy*fs/2, max(real(dbsgram), mxil-50));
axis('xy'); colormap(1-gray);

if nargin >= 4,
  title(titlestr);
end
xlabel('Time [ms]'); ylabel('Frequency [Hz]');
