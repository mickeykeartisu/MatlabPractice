%正規性の検定
%
%データ入力：

type = {'単語了解度','母音正答率','子音正答率','品質評価'};
% type = {'単語了解度'};

% answer_data = csvread('単語了解度.csv',1,1);
for t = 1:length(type),
    answer_data = csvread([type{t} '.csv'],1,1);
    for i =1:3,
        method(i).data = answer_data(i,:);
        method(i).std = std(method(i).data);
        method(i).ave = mean(method(i).data);
        [~, method(i).p] = kstest((method(i).data-method(i).ave)/method(i).std);
        p(i) = method(i).p;
        method_average(i) = method(i).ave;
    end
    if length(p>0.05) ==3,
        disp([type{t} 'は正規分布'])
    else
        disp([type{t} 'は正規分布ではない'])
    end
end
