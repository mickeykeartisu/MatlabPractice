function [norm] = getDcepNorm_ver2(dcep, method)
% [norm] = getDcepNorm(dcep, method)
% dcep:   delta cepstrum (qefrency, time)
% method: 0:include power, 1:not include power

% normdcep = (20/log(10)) .* sqrt( 2.*sum(dcep(2:end,:).^2, 1) + dcep(1,:).^2 );
% normdcep_noc0 = (20/log(10)) .* sqrt(2.*sum(dcep(2:end,:).^2, 1));
% dcep_D = sum(dcep(2:end,:).^2 ,1) / (size(dcep, 1)-1);

if nargin < 2,
    return
end

if method==0,
    norm = (20/log(10)) .* sqrt( 2.*sum(dcep(2:end,:).^2, 1) + dcep(1,:).^2 );
    disp('�p���[�����E�X�y�N�g���������܂�');
elseif method==1
    norm = (20/log(10)) .* sqrt( 2.*sum(dcep(2:end,:).^2, 1) );
    disp('�X�y�N�g���̕ϓ������݂̂ɒ���');
else
    norm = (20/log(10)) .* sqrt( dcep(1,:).^2 );
    disp('�p���[����');
end

end
