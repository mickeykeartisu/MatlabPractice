function [cep] = getSt2Cep(n3sgram, lifter)
% [cep] = getSt2Cep(n3sgram, lifter)
% lifter : lftering point

% (�ΐ�)�X�y�N�g����Ώ̂ɂ���
logsgram = zeros(2*(size(n3sgram,1)-1), size(n3sgram,2));
logsgram(1:size(n3sgram,1),:) = log(n3sgram);
logsgram(size(n3sgram,1)+1:end, :) = logsgram(size(n3sgram,1)-1:-1:2,:);
% �P�v�X�g����
cep = real(ifft(logsgram,2*(size(n3sgram,1)-1),1));

if nargin==2,
    % cep(fftl/2+2:end,:) = [];
    cep(lifter+1:end,:) = [];
end

end