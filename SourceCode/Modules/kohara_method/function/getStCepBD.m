function [ cep,cep_ori,logsgram ] = getStCepBD( sgram,lifter )
%�ш敪�����s����STRAIGHT�X�y�N�g������P�v�X�g���������߂�v���O����(getSt2Cep�̉��ǔ�)

logsgram = zeros(2*size(sgram,1)-1,size(sgram,2));
logsgram(1:size(sgram,1),:) = log(sgram);
logsgram(size(sgram,1)+1:end, :) = flipud(logsgram(1:size(sgram,1)-1,:));

% switch m
%     case 0 %���̏ꍇ
%         logsgram = zeros(2*size(sgram,1)-1,size(sgram,2));
%         logsgram(1:size(sgram,1),:) = log(sgram);
%         logsgram(size(sgram,1)+1:end, :) = flipud(logsgram(1:size(sgram,1)-1,:));
%        
%     case 1 %����̏ꍇ
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

