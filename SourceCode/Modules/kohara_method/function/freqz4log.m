function [h_mix, f, h_nd, h_dd] = freqz4log(f_nd, fftl, fs)
% function [h_mix, h_nd, h_dd, f] = freqz4log(f_nd, fftl, fs)

    if nargin<3,
        fs = 1000;
    end
    
    l = fftl/2+1;
    
    [h_nd, f] = freqz(f_nd, 1, l, fs); %�K�E�X�֐��̎��g������
    [h_dd, f] = freqz([-1 2 -1], 1, l, fs); %�����t�B���^�̎��g������
    
    h_nd = abs(h_nd);
    h_dd = abs(h_dd);
    h_mix = h_nd .* h_dd; %��̎��g�������������č����t�B���^�̎��g�����������߂�
    
    
    
%     figure
%     plot(h_nd);
%     title('���g�������x�N�g��(���K���z)')
%     
%     figure
%     plot(f);
%     title('�������g���x�N�g��');
%     
%     figure
%     plot(h_dd);
%     title('���g�������x�N�g��(2������)')
    
%     figure
%     plot(20*log10(h_mix));
%     title('h_mix')
%     
%     [a,b] = max(h_mix);