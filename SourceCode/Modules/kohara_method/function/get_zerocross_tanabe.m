function [syn] = get_zerocross(sig, fs)
%����������o�� str : 01_org
%���͂����������̒��������̓t���[������菬�������̂�����ꍇ�ɂ��ďC�����K�v
%�����̓t���[�����Ȃ������Ƃɂ��C��(2016/01/05)

close all

zerocross = 0;
for t = 1 : length(sig)-1
    if sig(t) >= 0
        if sig(t+1) < 0
            zerocross = zerocross + 1;
        end
    elseif sig(t) < 0
        if sig(t+1) > 0
            zerocross = zerocross + 1;
        end
    else
        %zerocross = zerocross + 1;
    end
end
%syn(syn_pos) = zerocross*100/ms;%1�b�Ԃ̗���������i�[
syn= zerocross;


%%���̓t���[�����g�p�����͂���ꍇ�͈ȉ�

% frame_pos = 1;
% % frame_len = 480;%���̓t���[����
% % shift_len = 240;%���̓V�t�g
% frame_len = round(fs/100);
% shift_len = round(frame_len/2);
% syn_pos = 1;
% %FF = (0:length(sig)-1)/ fs * 1000;
% ms = frame_len / fs * 1000;%point����ms�ɒ���
% %syn = zeros(length(sig),1);

% while frame_pos + frame_len < length(sig)
%     zerocross = 0;
%     for t = 0 : frame_len-1
%         if sig(frame_pos+t) >= 0
%             if sig(frame_pos+t+1) < 0
%                 zerocross = zerocross + 1;
%             end
%         elseif sig(frame_pos+t) < 0
%             if sig(frame_pos+t+1) > 0
%                 zerocross = zerocross + 1;
%             end
%         else
%             %zerocross = zerocross + 1;
%         end
%     end
%     %syn(syn_pos) = zerocross*100/ms;%1�b�Ԃ̗���������i�[
%     syn(syn_pos) = zerocross;
%     syn_pos = syn_pos + 1;
%     frame_pos = frame_pos + shift_len;
% end

% ff = (0:length(syn)-1)/length(syn)*length(sig)/fs;
% figure
% plot (ff,syn);
% set( gca,'FontSize',16 ); 
% xlabel('����[s]','FontSize',16);
% ylabel('�������[��/s]','FontSize',16);
% h = gcf;
% str2 = ['zerocross_' str '.fig'];
% str3 = ['zerocross_' str '.emf'];
% saveas(h,str2)
% saveas(h,str3)
% saveas(h,'zerocross_040_org.fig')
% saveas(h,'zerocross_040_org.emf')
% saveas(h,'zerocross_040_04Hz.fig')
% saveas(h,'zerocross_040_04Hz.emf')