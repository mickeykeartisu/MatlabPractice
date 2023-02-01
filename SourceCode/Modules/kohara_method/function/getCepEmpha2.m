function [ gainS, cep ] = getCepEmpha2( n3sgram, sigma, marg, flag, gain_v, lifter ,m)
%GETCEPEMPHA2 この関数の概要をここに記述
%   詳細説明をここに記述
%作成者：小原
%LogCep:変動情報信号　cep_nd：平滑化ケプストラム lifter:リフタリングポイント(求めたい次元の値+1の値※0次はmatlabでは1次であるため)
%m:n3sgramが帯域分割を行ったものの場合(0:低域のスペクトログラム,1:高域のスペクトログラム)

%-----straightスペクトルからケプストラムを求める-----%
%%リフタリングポイントが与えられてない時
if m ==1, %線形に戻してから平均
    cep = getSt2Cep(n3sgram,lifter); %関数getSt2Cep呼び出し
    LogCep = getLogCep(cep, sigma, marg); %平滑化
    LogCep = LogCep * gain_v;
    gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'linear'); %ケプストラムの系列を周波数領域に戻す
    gainS = mean(gainS);
end

if m == 2, %m=1の平均を行わないver
    cep = getSt2Cep(n3sgram,lifter); %関数getSt2Cep呼び出し
    LogCep = getLogCep(cep, sigma, marg); %平滑化
    LogCep = LogCep * gain_v;
    gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'linear'); %ケプストラムの系列を周波数領域に戻す
end

if m == 3, %線形に戻してから平均
    cep = getSt2Cep(n3sgram, lifter); %関数getSt2Cep呼び出し
    LogCep = getLogCep(cep, sigma, marg); %平滑化
    LogCep = LogCep * gain_v;
    cep_emp = cep + LogCep;
    n3sgram_emp = getCep2spec(cep_emp, 2*(size(n3sgram,1)-1), 'linear'); %%強調されたスペクトルを得る
    gainS = n3sgram_emp ./ n3sgram;
    gainS = mean(gainS);
end

% if m == 4,
%     LogCep = getCepEmpha(n3sgram, sigma, marg, flag,2);
%     LogCep = LogCep * gain_v;
%     gainS = LogCep;
%     gainS = exp(gainS);
% end
% 
% if m == 5,
%     LogCep = getCepEmpha(n3sgram, sigma, marg, flag,2);
%     LogCep = LogCep * gain_v;
%     gainS = LogCep;
%     gainS = exp(gainS);
% end

% figure
% plot(gainS);
%    
%------得られたケプストラムとσとマージから、変動情報信号と平滑化信号を得る-----%
% [LogCep, cep_nd] = getLogCep(cep, sigma, marg, flag);
end



% if m == 4, %平均してから線形に戻す
%     cep = getSt2Cep(n3sgram, lifter); %関数getSt2Cep呼び出し
%     LogCep = getLogCep(cep, sigma, marg); %平滑化
%     LogCep = LogCep * gain_v;
%     cep_emp = cep + LogCep;
%     n3sgram_emp = getCep2spec(cep_emp, 2*(size(n3sgram,1)-1)); %%強調されたスペクトルを得る
%     gainS = n3sgram_emp ./ n3sgram;
%     gainS = mean(gainS,2);
% end



% 
% if m == 2, %平均してから線形に戻す
%     cep = getSt2Cep(n3sgram,lifter); %関数getSt2Cep呼び出し
%     LogCep = getLogCep(cep, sigma, marg); %平滑化
%     LogCep = LogCep * gain_v;
%     gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1)); %ケプストラムの系列を周波数領域に戻す
%     gainS = mean(gainS);
%     gainS = exp(gainS);
% end
