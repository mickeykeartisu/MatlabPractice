% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% プログラムの初期化
clear variables;  % 変数の初期化
clc % コマンドウィンドウの初期化

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ファイルを適切に開く

filename = 'D:\名城大学\研究室\演習\data\M007_ATR503_A01_T01.raw'; % Path
permission = 'r';    % 読み込みモード

% エラーが起きないようにファイルを読み込む
[fileID, errmsg] = fopen(filename, permission);
if fileID < 0
    disp('fileID : ', fileID);
    disp('errmsg : ', errmsg);
else
    disp('Could open file correctly');
end

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% FFTで周波数領域に変換する

% 音声信号を読み取る
precision = 'int16';    % 整数符号付き16bit信号(short型でも可)
originalSignals = fread(fileID, precision);

% 読み込んだデータの"あ"の部分を抽出する
startPoint = 8863;  % スタートのポイント
time = 0.03; % 抽出時間[s]
samplingRate = 8000; % サンプリング周波数[Hz]
N = time * samplingRate;    % ポイント数
extractedSignals = originalSignals(startPoint : 1 : startPoint + N - 1);

% ハミング窓を生成し抽出した信号に乗じる
n = (0 : N - 1)';  % ベクトル(240行1列) : 転置を利用
hammingWindow = 0.54 - 0.46 * cos(2 * n * pi / (N - 1));    % ハミング窓
windowedSignals = extractedSignals .* hammingWindow;

% FFT(Fast Fourier Transfer)を行って振幅スペクトルを生成する
FFTPoint = 512; % フーリエ変換のポイント数
fourierTransformedSignals = fft(windowedSignals, FFTPoint);
amplitutedSpectral = sqrt(abs(real(fourierTransformedSignals) .^ 2 + imag(fourierTransformedSignals) .^ 2));

% 振幅スペクトルをdBに変換する
X0 = 32768; % 基準値
amplitutedSpectralWithdB = 20 * log10(amplitutedSpectral / X0);

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ケプストラムを求める

% 振幅スペクトルを自然対数に変換
amplitutedSpectralNaturalLogarithm = log(amplitutedSpectral);

% 逆フーリエ変換を行う
inversedFourierTransformedSignals = ifft(amplitutedSpectralNaturalLogarithm);
inversedFourierTransformedSignalsReal = real(inversedFourierTransformedSignals);

% 基本周波数を算出する
cepstrumPoint = 31; % ケプストラムの次数
[maxValue,peakPoint] = max(inversedFourierTransformedSignalsReal(cepstrumPoint: FFTPoint / 2));   % ピークとなるポイント
peakPoint = peakPoint + cepstrumPoint - 1;
basicPeriod = peakPoint / samplingRate; % 基本周期
basicFrequency = 1 / basicPeriod;  % 基本周波数

% 低ケフレンシー成分を抽出する(30次のリフタリング)
lowQuefrency = inversedFourierTransformedSignalsReal;
lowQuefrency(cepstrumPoint + 1:FFTPoint - cepstrumPoint) = 0;   % 低ケフレンシー成分

% スペクトル包絡(声道情報)に変換する
spectralEnvelope = fft(lowQuefrency, FFTPoint);
amplitutedSpectralEnvelope = sqrt(abs(real(spectralEnvelope) .^ 2 + imag(spectralEnvelope) .^ 2));
amplitutedSpectralEnvelopeLinear = exp(amplitutedSpectralEnvelope);

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% スペクトル包絡から音声を合成する

% スペクトル包絡から実部を取り出して,IFFTをして実部にfftshiftして中心に持ってくる
amplitutedSpectralEnvelopeLinearReal = real(amplitutedSpectralEnvelopeLinear);
inversedFourierTransformedLinearAmplitutedSpectralEnvelopeReal = ifft(amplitutedSpectralEnvelopeLinear, FFTPoint);
IFFTRealLinearAmplitutedSpectralEnvelopeReal = real(inversedFourierTransformedLinearAmplitutedSpectralEnvelopeReal);
fftshiftedSignal = fftshift(IFFTRealLinearAmplitutedSpectralEnvelopeReal);

% 基本周期で重畳加算
mixedSignal = zeros([peakPoint * 100 + FFTPoint, 1]);  % 合成した信号
for index = 0 : 100
    mixedSignal(peakPoint * index + 1 : peakPoint * index + FFTPoint) = mixedSignal(peakPoint * index + 1 : peakPoint * index + FFTPoint) + fftshiftedSignal(1 : FFTPoint);
end

% データをプロットする

% プロットする際のサイズ
rows = 5;   % 5行
columns = 3;    % 3列

% 読み取った信号をプロットする
subplot(rows, columns, 1);
plot(originalSignals, 'b');
title('Original signals');
xlabel('Time[s]');
ylabel('X[n]');
axis([1 length(originalSignals) -X0 X0]);
grid on;

% 抽出した信号をプロットする
subplot(rows, columns, 2);
plot(extractedSignals, 'b');
title('Extracted signals');
xlabel('Plot point');
ylabel('X[n]');
axis([1 N -X0 X0]);
grid on;

% ハミング窓をプロットする
subplot(rows, columns, 3);
plot(hammingWindow, 'b');
title('Hamming window');
xlabel('Hamming point');
ylabel('w[n]');
axis([1 N 0 1]);
grid on;

% ハミング窓を乗じた後の信号をプロットする
subplot(rows, columns, 4);
plot(windowedSignals, 'b');
title('Windowed signals');
xlabel('Plot point');
ylabel('X[n] * w[n]');
axis([1 N -X0 X0]);
grid on;

% フーリエ変換の結果をプロットする
subplot(rows, columns, 5);
plot(amplitutedSpectral, 'b');
title('Fourier transformed signals');
xlabel('FFT point');
ylabel('|A[n]|');
axis([1 FFTPoint 0 5*10^5]);
grid on;

% 振幅スペクトルをdBでプロットする
subplot(rows, columns, 6);
plot(amplitutedSpectralWithdB, 'b');
title('Amplituted spectrums[dB]');
xlabel('FFT point');
ylabel('|A[n]|([dB])');
axis([1 FFTPoint -60 25]);
grid on;

% 自然対数の振幅スペクトルをdBでプロットする
subplot(rows, columns, 7);
plot(amplitutedSpectralNaturalLogarithm, 'b');
title('Amplituted spectrums natural logarithm');
xlabel('Real');
ylabel('Imaginary');
axis([1 FFTPoint 3 14]);
grid on;

% ケプストラムの結果をプロットする
subplot(rows, columns, 8);
plot(inversedFourierTransformedSignalsReal, 'b');
title('Cepstrum');
axis([-5 FFTPoint + 3 -1 1]);
grid on;

% 低次のケプストラムの結果をプロットする
subplot(rows, columns, 9);
plot(lowQuefrency, 'b');
title('Low Cepstrum');
axis([-5 FFTPoint + 3 -1 1]);
grid on;

% スペクトル包絡の結果をプロットする
subplot(rows, columns, 10);
plot(amplitutedSpectralEnvelope, 'b');
title('Spectral Envelope');
axis([-5 FFTPoint + 3 4 13]);
grid on;

% スペクトル包絡の結果をプロットする
subplot(rows, columns, 11);
plot(amplitutedSpectralEnvelopeLinear, 'b');
title('Spectral Envelope Linear');
axis([1 FFTPoint 0 5*10^5]);
grid on;

% インパルス応答をプロットする
subplot(rows, columns, 11);
plot(fftshiftedSignal, 'b');
title('IFFT Spectral Envelope Linear');
axis([0 FFTPoint -1.5*10^4 3.5*10^4]);
grid on;

% インパルス応答をプロットする
subplot(rows, columns, 12);
plot(mixedSignal, 'b');
title('IFFT Spectral Envelope Linear');
axis([0 FFTPoint -1.5*10^4 3.5*10^4]);
grid on;

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ファイルを適切に閉じる

% 読み込んだデータを正しく閉じる
status = fclose(fileID);
if status == 0
    disp('Could close file correctly')
else
    disp('Can not close file correctly')
end

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% ファイルを適切に開く

filename = 'D:\名城大学\研究室\演習\data\speech.raw'; % Path
permission = 'w';    % 読み込みモード

% エラーが起きないようにファイルを読み込む
[fileID, errmsg] = fopen(filename, permission);
if fileID < 0
    disp('fileID : ', fileID);
    disp('errmsg : ', errmsg);
else
    disp('Could open file correctly');
end

% 音声信号を読み取る
precision = 'int16';    % 整数符号付き16bit信号(short型でも可)
fwrite(fileID, mixedSignal, precision);

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% ファイルを適切に閉じる

% 読み込んだデータを正しく閉じる
status = fclose(fileID);
if status == 0
    disp('Could close file correctly')
else
    disp('Can not close file correctly')
end