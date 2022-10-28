% WAVファイル読み込み
[x, fs, nbits] = wavread('vaiueo2d.wav');
% STRAIGHTは、16ビット量子化を仮定しないとうまく動作しないことがある。
x = x .* 32768; 

% 基本周波数抽出
% [f0raw, ap] = exstraightsource(x, fs);
%sourceParams.NewVersion = 1; % 最新版の基本周波数抽出を使う
sourceParams.F0searchLowerBound=40; % 周波数探索範囲の下限
sourceParams.F0searchUpperBound=800; % 周波数探索範囲の上限
[f0raw, ap] = exstraightsource(x, fs, sourceParams);

% STRAIGHT分析（STRAIGHTスペクトログラムの抽出）
[n3sgram] = exstraightspec(x, f0raw, fs);

% STRAIGHT合成
% pconv: 基本周波数変換率, fconv: 周波数軸変換率, sconv: 時間軸変換率
synthParams.pconv = 1.0; synthParams.fconv = 1.0; synthParams.sconv = 1.0;
[sy] = exstraightsynth(f0raw, n3sgram, ap, fs, synthParams);

% 合成音の再生
sound(sy ./ 32768, fs);

% スペクトログラムの表示（坂野独自関数）
dispsgram(n3sgram, fs);
