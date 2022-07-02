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
    disp('Could opne file correctly');
end

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% 信号を適切に処理する

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
amplitutedSpectrums = sqrt(abs(real(fourierTransformedSignals) .^ 2 + imag(fourierTransformedSignals) .^ 2));

% 振幅スペクトルをdBに変換数
X0 = 32768; % 基準値
amplitutedSpectrumsWithdB = 20 * log10(amplitutedSpectrums / X0);

% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% データをプロットする

% プロットする際のサイズ
rows = 3;   % 3行
columns = 2;    % 2列

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
plot(amplitutedSpectrums, 'b');
title('Fourier transformed signals');
xlabel('FFT point');
ylabel('|A[n]|');
axis([1 FFTPoint 0 5*10^5]);
grid on;

% 振幅スペクトルをdBでプロットする
subplot(rows, columns, 6);
plot(amplitutedSpectrumsWithdB, 'b');
title('Amplituted spectrums');
xlabel('FFT point');
ylabel('|A[n]|([dB])');
axis([1 FFTPoint -60 25]);
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