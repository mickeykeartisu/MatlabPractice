function [h_mix, f, h_nd, h_dd] = freqz4log(f_nd, fftl, fs)
% function [h_mix, h_nd, h_dd, f] = freqz4log(f_nd, fftl, fs)

    if nargin<3,
        fs = 1000;
    end
    
    l = fftl/2+1;
    
    [h_nd, f] = freqz(f_nd, 1, l, fs); %ƒKƒEƒXŠÖ”‚ÌŽü”g”‰ž“š
    [h_dd, f] = freqz([-1 2 -1], 1, l, fs); %”÷•ªƒtƒBƒ‹ƒ^‚ÌŽü”g”‰ž“š
    
    h_nd = abs(h_nd);
    h_dd = abs(h_dd);
    h_mix = h_nd .* h_dd; %“ñ‚Â‚ÌŽü”g”‰ž“š‚ð‚©‚¯‚Ä‡¬ƒtƒBƒ‹ƒ^‚ÌŽü”g”‰ž“š‚ð‹‚ß‚é
    
    
    
%     figure
%     plot(h_nd);
%     title('Žü”g”‰ž“šƒxƒNƒgƒ‹(³‹K•ª•z)')
%     
%     figure
%     plot(f);
%     title('•¨—Žü”g”ƒxƒNƒgƒ‹');
%     
%     figure
%     plot(h_dd);
%     title('Žü”g”‰ž“šƒxƒNƒgƒ‹(2ŽŸ”÷•ª)')
    
%     figure
%     plot(20*log10(h_mix));
%     title('h_mix')
%     
%     [a,b] = max(h_mix);