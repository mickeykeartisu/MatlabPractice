function [ cep,cep_ori,logsgram ] = getStCepBD( sgram,lifter )
%帯域分割を行ったSTRAIGHTスペクトルからケプストラムを求めるプログラム(getSt2Cepの改良版)

logsgram = zeros(2*size(sgram,1)-1,size(sgram,2));
logsgram(1:size(sgram,1),:) = log(sgram);
logsgram(size(sgram,1)+1:end, :) = flipud(logsgram(1:size(sgram,1)-1,:));

% switch m
%     case 0 %低域の場合
%         logsgram = zeros(2*size(sgram,1)-1,size(sgram,2));
%         logsgram(1:size(sgram,1),:) = log(sgram);
%         logsgram(size(sgram,1)+1:end, :) = flipud(logsgram(1:size(sgram,1)-1,:));
%        
%     case 1 %高域の場合
%         logsgram = zeros(2*size(sgram,1)-1,size(sgram,2));
%         logsgram(size(sgram,1):end, :) = log(sgram);
%         logsgram(1:size(sgram,1)-1,:) = flipud(logsgram(size(sgram,1)+1:end,:));
% 
% end

cep = real(ifft(logsgram,2*(size(sgram,1)-1),1));


if nargin == 2,
    cep_ori = cep;
    cep(lifter+1:end,:) = [];
end

end

