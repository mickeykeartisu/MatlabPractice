function [spec] = getCep2spec(cep, fftl, scale)
% ケプストラムからスペクトルを求める
% [spec] = getCep2spec(cep, fftl, scale)
% spec  : Spectrum (log scale)
% cep   : Cepstrum
% fftl  : FFT point
% scale : Output Spectrum scale 'log_e()'(default), 'linear' or 'dB'

if nargin < 3,
    scale = 'log';
end
str = {'linear', 'dB'};
strnum = find(strcmp(scale, str));

% keyboard

% ケプストラムをリフタ前に戻す
ceptemp = zeros(fftl,size(cep,2));
ceptemp(1:size(cep,1),:) = cep;
ceptemp(end-size(cep,1)+2:end,:) = cep(end:-1:2,:);
% スペクトル変換
spec = fft(ceptemp,fftl,1);
clear ceptemp; %%メモリ削減のため
spec(fftl/2+2:end,:) = [];
spec = real(spec);

if strnum==1,
    % display('spectrum : linear scale')
    spec = exp(spec);
elseif strnum==2,
    % display('spectrum : dB scale')
    spec = 20*spec/log(10);
end

end