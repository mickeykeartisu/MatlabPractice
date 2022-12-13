【TANDEM-STRAIGHTに関するプログラムについて】

坂野先生のTANDEM-STRAIGHTをほとんど使わせていただき、変更しています。


●Tandem_analysis_ver3.mlx : メインのプログラム
	・基本周波数のグラフ、スペクトログラム、matファイル(基本周波数、サンプリング周波数、STRAIGHTスペクトル)を出力

	●exF0candidatesTSTRAIGHTGB_ver2.m
		・framePeriodの変更(5→1)
	●exSpectrumTSTRAIGHTGB_ver2.m
		・framePeriodの変更(5→1)


●Tandem_analysis_LTAS_ver3.mlx : 長時間平均スペクトル
●Tandem_analysis_LTAS_ver3_phoneme.mlx : 母音部分と子音部分に分けた長時間平均スペクトル
●Tandem_analysis_LPC_ver9.mlx : LPC分析

	●getstraight_ver3.m : ソース情報を抽出、スペクトル情報を抽出する関数


●Tandem_analysis_ver3_kohara.mlx : 動的特徴の強調処理(ファイルemphasize_dynamicFeatures)で使用音声のmatファイルの作成
