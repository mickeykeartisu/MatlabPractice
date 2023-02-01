function [cep] = getSt2Cep_kohara(n3sgram, lifter)
% [cep] = getSt2Cep(n3sgram, lifter)
% lifter : lftering point

% (対数)スペクトルを対称にする
logsgram = zeros(2*(size(n3sgram,1)-1), size(n3sgram,2));
logsgram(1:size(n3sgram,1),:) = log(n3sgram);
logsgram(size(n3sgram,1)+1:end, :) = logsgram(size(n3sgram,1)-1:-1:2,:);

% figure
% plot(logsgram(:,1));
% keyboard
% ケプストラム
cep = real(ifft(logsgram,2*(size(n3sgram,1)-1),1));
% cep = real(ifft(logsgram,2*(size(logsgram,1)-1),1));
% cep = real(ifft(logsgram,2*512));
% figure
% plot(cep(2:end,1))
% setLabel('Time[ms]', 'log amplitude', '',16);
% set( gca, 'FontName','MS UI Gothic','FontSize',14 );
% title('cep処理前')

keyboard

if nargin==2,
    % cep(fftl/2+2:end,:) = [];
    cep(lifter+1:end,:) = [];
end

% keyboard

% figure
% plot(cep)
% title('cep処理後')


end