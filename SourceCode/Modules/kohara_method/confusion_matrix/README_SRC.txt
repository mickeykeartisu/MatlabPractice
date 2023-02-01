コンフュージョンマトリックス作成
--------------------------------

mkconfusion.m: メイン



正解率推定
----------

execpredictrate.m: メイン

* 正解率のグラフについて（correct.png, correct_male.png, correct_female.png）
  ○: 単語正解率
  △: 子音正解率 
  ×: 母音正解率
  ＋: 推定正解率
  一点鎖線: 母音の割合（推定時の重み付けの値）
  グラフのタイトル: <被験者ID>, <入力音声性別>, N = <推定N>, dist = <％換算の誤差>
  被験者ID: 
    日本人男性: J1M, J2M, J3M
    日本人女性: J4F, J5F, J6F
    非日本人: NJ1M（男性）, NJ2F（女性）


* 推定Nのグラフについて（predicted_N.png）
  被験者IDは上記グラフと同じ
  