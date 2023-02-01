function [LogCep, cep_nd, cep] = getCepEmpha(n3sgram, sigma, marg, flag, lifter)
%作成者：小原
%LogCep:変動情報信号　cep_nd：平滑化ケプストラム lifter:リフタリングポイント(求めたい次元の値+1の値※0次はmatlabでは1次であるため)
%m:n3sgramが帯域分割を行ったものの場合(0:低域のスペクトログラム,1:高域のスペクトログラム)

%-----straightスペクトルからケプストラムを求める-----%
%%リフタリングポイントが与えられてない時
if nargin ==4,
    lifter = 0;
    cep = getSt2Cep(n3sgram);
    cep(1,:) = []; %0次を削除
    cep = mean(cep); %ケプストラムの全次元から平均を求める
end

if nargin == 5,
    cep = getSt2Cep(n3sgram, lifter);
    cep(1:lifter-1,:) = []; %求めたい次元以下のケプストラムの情報を削除
end

% if nargin == 6,
%     cep = getSt2Cep(n3sgram,lifter);
%     cep(1:lifter-1,:) = []; %求めたい次元以下のケプストラムの情報を削除
% end

%------得られたケプストラムとσとマージから、変動情報信号と平滑化信号を得る-----%
[LogCep, cep_nd] = getLogCep(cep, sigma, marg, flag);
