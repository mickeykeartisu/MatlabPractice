function [ X_Int ] = LinearInt( X, Y )
%LINEARINT 線形補間を行う関数
% X:線形補間を行う系列 Y:目標の系列

xq = 1:(length(X)/length(Y)):length(X);
X_Int = interp1(1:length(X), X, xq); %線形補間
temp = ones(1,length(Y)-length(X_Int)); %目標の系列とのポイント数の差だけ1の系列を作成
X_Int = cat(2,X_Int,temp); %線形補間した系列の末尾に足りない分だけ1を追加
end

