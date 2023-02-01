function [label] = get_label_tanabe(num)
%ファイル番号を入力することで，ラベルを取得するプログラム

if num < 10
    label = sploadlabel(['YSB_60dB_000' num2str(num) '_label.txt'], 'sec'); %分析する音声データの時刻（ラべリングの）を算出する
elseif num > 9 && num <100
    label = sploadlabel(['YSB_60dB_00' num2str(num) '_label.txt'], 'sec');
else
    label = sploadlabel(['YSB_60dB_0' num2str(num) '_label.txt'], 'sec');
end
%ラベル作成時は,"秒"で保存したので,フォーマットをsecにしている