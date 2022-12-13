メイン関数：	baion_rms_main.m
使用する関数：	baion_rms_plot.m(グラフのプロット)
		bandpass.m(バンドパスフィルタの設計)
			getkaiserparam.m(カイザー窓のパラメータ設定)
			lowhighpass.m(ローパス，ハイパスフィルタ)
			myfftfilt.m(fftフィルタ)
			mykaiser.m(カイザー窓の設計)
		rms_cmand.m(RMS値の算出)
		rms_f0.m(平均基本周波数抽出)
		wavcut.m(音声波形の雑音カット)

その他：	f0_plot.m(抽出した基本周波数のグラフのプロット)
			f0.txtがbaion_rms_main.mで作成される
		wavcut_test.m(wavcut.mのテスト)
			時間波形と全体のRMS値を見ながら閾値を決める
		