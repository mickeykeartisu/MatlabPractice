%���K���̌���
%
%�f�[�^���́F

type = {'�P�ꗹ��x','�ꉹ������','�q��������','�i���]��'};
% type = {'�P�ꗹ��x'};

% answer_data = csvread('�P�ꗹ��x.csv',1,1);
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
        disp([type{t} '�͐��K���z'])
    else
        disp([type{t} '�͐��K���z�ł͂Ȃ�'])
    end
end
