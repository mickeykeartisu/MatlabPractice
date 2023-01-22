function [dcep, ddcep] = getDeltaCep4(cep, prm, win)
% [dcep, ddcep] = getDeltaCep(cep, fs, prm, win)
% cep,dcep:     (delta)cepstrum matrix(quefrency,frame)
% fs:           sampling rate [Hz]
% prm.msceporder:   lifter length [ms]
% prm.dceptime:     delta cepstrum smoothing time [ms]
% prm.msshift:      shift length [ms]

if ~isfield(prm, 'msshift'),
    prm.msshift = 1; % for STRAIGHT
end

ceporder = size(cep,1);


k = round( prm.msdceptime / (2*prm.msshift) );

% window
if nargin < 4,
    win = ones(2*k+1,1);
    % win = window(@hamming, 51);
else
    if length(win) ~= (2*k+1),
        disp(['not match k-win length. k is ' num2str(2*k+1)])
    end
end

% Delta Cepstrum
hmat = repmat(win', ceporder,1);
kmat = repmat((-k:k), ceporder,1);
dcep = zeros(ceporder, size(cep,2)-2*k);
cnt = 1;
for t=1+k:size(cep,2)-k, % frame shift
    tmp1 = sum(hmat .* kmat .* cep(:,t+(-k:k)), 2);
    tmp2 = sum(hmat .* kmat.^2, 2);
    dcep(:,cnt) = tmp1./tmp2;
    cnt=cnt+1;
end

% DeltaDelta Cepstrum
if nargout > 1,
    kpowsum = sum((-k:k).^2);
    ddcep = zeros(ceporder, size(cep,2)-2*k);
    cnt = 1;
    for t=1+k:size(cep,2)-k, % frame shift
        % ï™éq
        tmp1 = kpowsum * sum(cep(:,t+(-k:k)),2);
        tmp2 = (2*k+1) * sum(kmat.^2 .* cep(:,t+(-k:k)),2);
        
        %Å@ï™ïÍ
        tmp3 = kpowsum.^2;
        tmp4 = (2*k+1) * sum((-k:k).^4);
        
        ddcep(:,cnt) = (tmp1 - tmp2) ./ (tmp3 - tmp4);
        cnt=cnt+1;
    end
end

