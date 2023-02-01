function [dcep, ddcep] = getDeltaCep(cep, prm)
% [dcep] = getDeltaCep(cep, fs, prm)
% cep,dcep:     (delta)cepstrum matrix(quefrency,frame)
% fs:           sampling rate [Hz]
% prm.msceporder:   lifter length [ms]
% prm.dceptime:     delta cepstrum smoothing time [ms]
% prm.msshift:      shift length [ms]

% , msceporder, dceptime, msshift

% prm.msceporder=2; prm.msframe=10;
% prm.msshift=1; prm.msdceptime=200;

ceporder = size(cep,1);

% Delta Cepstrum
k = round( prm.msdceptime / (2*prm.msshift) );
kmat = repmat((-k:k),ceporder,1);
dcep = zeros(ceporder,size(cep,2)-2*k);
cnt = 1;
for t=1+k:size(cep,2)-k, % frame shift
    tmp1 = sum(kmat .* cep(:,t+(-k:k)),2);
    tmp2 = sum(kmat.^2,2);
    dcep(:,cnt) = tmp1./tmp2;
    cnt=cnt+1;
end

% DeltaDelta Cepstrum
if nargout > 1,
    kpowsum = sum((-k:k).^2);
    ddcep = zeros(ceporder,size(cep,2)-2*k);
    cnt = 1;
    for t=1+k:size(cep,2)-k, % frame shift
        % •ªq
        tmp1 = kpowsum * sum(cep(:,t+(-k:k)),2);
        tmp2 = (2*k+1) * sum(kmat.^2 .* cep(:,t+(-k:k)),2);
        
        %@•ª•ê
        tmp3 = kpowsum.^2;
        tmp4 = (2*k+1) * sum((-k:k).^4);
        
        ddcep(:,cnt) = (tmp1 - tmp2) ./ (tmp3 - tmp4);
        cnt=cnt+1;
    end
end
