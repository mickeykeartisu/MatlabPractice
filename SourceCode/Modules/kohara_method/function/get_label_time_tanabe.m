function [label_time] = get_label_time_tanabe(label,num)
%{
get_label_timeに関する記述
受け取った番号における,ラベルの時刻を返す関数

%   詳細説明をここに記述
num … ラベルの値(数値)
label … 使用するラベル(struct型)

%}

labelst = struct2cell(label(1,num));           %構造体をセル配列にする
labelst_time = cell2mat(labelst(1,1));          %セル配列を元のデータに戻す
label_time = round((labelst_time) * 1000);      %msに変換

end