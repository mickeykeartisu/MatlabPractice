
	dpMatch, dpMatchConstraint  - DPマッチングの実行


はじめに
--------

DPマッチングを実行するMatlabのプログラムです。これにより、二つの
特徴ベクトル列の時間的対応関係を求めることができます。


使用方法
--------

自分で傾斜制限を設計したい場合はDPMATCHCONSTRAINTを、そうでない場合はDPMATCH
を使います。

[DIST, MAP, G] = DPMATCH(XMAT, YMAT, START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR)
[DIST, MAP, G] = DPMATCH(XMAT, YMAT, START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR, DIST_FUNC)
[DIST, MAP, G] = DPMATCHCONSTRAINT(CONSTRAINT, XMAT, YMAT, ...
 				   START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR)
[DIST, MAP, G] = DPMATCHCONSTRAINT(CONSTRAINT, XMAT, YMAT, ...
 				   START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR, DIST_FUNC)

 XMAT, YMAT: 入力行列です。それぞれの列が特徴ベクトルになっている必要があります。
             特徴ベクトルが1次元の場合は、入力行列が行ベクトルになります。
 CONSTRAINT: 傾斜制限を決定する行列です。下記参照。
 START_FREE_NFRAME: 始点フリーのフレーム数です。0の場合は始点フリーは無効になります。
 END_FREE_NFRAME: 終点フリーのフレーム数です。0の場合は終点フリーは無効になります。
 LIMIT_FACTOR: 累積歪みの計算範囲を制限する係数です。0に近いほど計算範囲が限定されます。
               1の場合は制限がなく、0の場合にはデフォルト値を使用します。
 DIST_FUNC: 歪みを計算する関数を指定します。省略すると、デフォルトであるユークリッド距離が使われます。
            関数は、`func(xvec, yvec)'の形になっている必要があります。
 DIST: 最終的に得られる累積距離です。
 MAP: 経路情報（時間的対応関係）を保存したベクトルです。
      XMATの時間軸（フレーム数）がYMATのどの時間（フレーム数）に対応しているかを示しています。
      長さは基本的にXMATの列数と同じになりますが、
      終点フリーが有効な場合には、それとは異なる値になることがあります。
 G: 累積距離行列です。大きさは「XMATの列数 x YMATの列数」となります。


傾斜制限行列
------------

以下のような形式になっている必要があります。

CONSTRAINT = [ IS_FIRST_NODE  X_DIFF  Y_DIFF  WEIGHT ;
	                     :                       ;
                             :                        ]
 IS_FIRST_NODE: 1が最初のノードを示し、0がそうではないノードを示します。
 X_DIFF: ノード間のX軸方向の変位です。
 Y_DIFF: ノード間のY軸方向の変位です。
 WEIGHT: ノード間に与えられる重みです。

例：
%      o--o
%    /  / |
%   o  o  o
%        /
%      o
  constraint = [ 1 -1  0  1;
                 0 -1 -1  2;
		 1 -1 -1  2;
		 1  0 -1  1;
		 0 -1 -1  2];
%        o-----o
%     / /  /  /
%   o    o  
%    /     /
%   o    o
  constraint = [ 1 -1 -2  1;
                 1 -1 -1  1;
		 1 -1  0  1;
		 0 -1 -2  1;
		 1 -1  0  1;
		 0 -1 -1  1];



使用例
------

% 2つのサイン波を対応付けるプログラム

xlen = 256; ylen = 256;
fx = 100; fy = 110;
xdelay = 5; ydelay = 10;
x = [zeros(1, xdelay) sin(2 * pi * fx * (0:(xlen-1)) / xlen)];
y = [zeros(1, ydelay) sin(2 * pi * fy * (0:(ylen-1)) / ylen)];

[dist, map, g] = dpMatch(x, y, 10, 50, 0.6);

imagesc(min(g', 100)); axis xy; hold on;
plot(map, 'w', 'LineWidth', 2);

figure;
plot(1:length(map), x(1:length(map)), 1:length(map), y(map));


--
坂野秀樹（Banno Hideki）
