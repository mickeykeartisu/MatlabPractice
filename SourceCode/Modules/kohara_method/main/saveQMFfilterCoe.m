%%QMFに用いるフィルタh0の係数を求め、matデータとして保存するプログラム

%音声のサンプリング周波数を指定
fs = 48000;
%フィルタ長(ミリ秒)を指定
t = 10;
%フィルタ長を指定
N = fs/1000 * t;

% keyboard

h0 = QMFDesign(N, 0.3, 1); % H0(z)ローパスフィルタ

g0 = h0;

h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)ハイパスフィルタ

g1 = -1 * h1;


outputDirName = './QMFfilterCoefficient_mat/';
filename = [num2str(fs) 'Hz_' num2str(t) 'ms'];

save ([outputDirName filename], 'h0', 'g0', 'h1', 'g1');

