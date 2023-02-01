clear all

scrsz = get(0,'ScreenSize'); %%�E�B���h�E�T�C�Y���擾


%%�p�����[�^�̎w��
%��������ϒ����g���̒l(Hz)
empha_Hz = 16;
%�Q�C���̑����̔{���̎w��(dB)
setGain = 6;
%���������`(2�ш�ɕ�������Ȃ�2 3�ш�Ȃ�3....)
T = 16; 
%�n�j���O������Hz�܂ł����邩�i�ő�l�̓i�C�L�X�g���g���j
maxfreq = 500;

inputDirName = '../voice_data/sample/';
inputDirName_AE = ['../voice_data/new_BandDivision_tec/ATR_16kHz/' num2str(maxfreq) 'Hz/'];

outputDirName = '../fig_data/RMS_comparison/';
mkdir(outputDirName);

frame_t = 10; %�t���[����(�~���b)
shift_t = 1; %�V�t�g���i�~���b�j

% for i = 1:5,
%     inputName_AN = ['AN' num2str(i,'%02d')];
%     inputName_AE = ['AN' num2str(i, '%02d') '_' num2str(setGain) 'dB_' num2str(T) 'band_hanning' num2str(maxfreq) 'Hz'];
%     [AN.X, AN.fs]= audioread ([inputDirName 'wav/ATR_16kHz/' inputName_AN '.wav']);
%     [AE.X, AE.fs]= audioread ([inputDirName_AE inputName_AE '.wav']);
% 
%     AN.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AN '_lab.txt'],'point',1/1000);
% %     AE.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AE '_lab.txt'],'point',1/1000);
%     
%     frame_p = AN.fs/1000 * frame_t; %�T���v�����O���g��16kHz�̎��̃t���[����20ms%
%     shift_p = AN.fs/1000 * shift_t; %�T���v�����O���g��16kHz�̎��̃t���[���V�t�g1ms%
% 
%     AN.R = floor((length(AN.X)-frame_p)/shift_p); %���͉����̒������V�t�g���Ŋ���A�i�[����x�N�g���̒��������߂�
%     AE.R = floor((length(AE.X)-frame_p)/shift_p); %���͉����̒������V�t�g���Ŋ���A�i�[����x�N�g���̒��������߂�
% 
%     AN.rms = zeros(1,AN.R);
%     AE.rms = zeros(1,AE.R);
%     point = 1;
%     for ii = 1:1:AN.R,
%         x = AN.X(point:point+(frame_p-1));
%         rmsV = getRms(x,frame_p);
%         AN.rms(ii) = 20*log10(rmsV);
%         point = point+shift_p;
%     end
%     
%     point = 1;
%     for ii = 1:1:AE.R,
%         x = AE.X(point:point+(frame_p-1));
%         rmsV = getRms(x,frame_p);
%         AE.rms(ii) = 20*log10(rmsV);
%         point = point+shift_p;
%     end
%     
%     x_lim = [AN.label(1).time-50 AN.label(end).time+50];
%     y_lim = [min(AE.rms)-10 max(AE.rms)+10];
%     fontsize = 20;
%     ylabel_fontsize = 20;
%     
%     figure('Name',[''],'NumberTitle','off', 'Position',[1 1 9*scrsz(3)/10 5*scrsz(4)/10])
%     plot(AN.rms,'b');
%     set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
%     xlabel('Time [ms]', 'fontsize', fontsize);
%     ylabel('RMS [dB]', 'fontsize', ylabel_fontsize);
%     xlim(x_lim);
%     ylim(y_lim)
%     spplotlabel(AN.label,'k:',26);
%     
%     hold on
%     plot(AE.rms,'r');
%     xlim(x_lim)
%     ylim(y_lim)
% %     spplotlabel(AN.label,'k:',26);
%     hold off
%     
%     saveas(gcf,[outputDirName inputName_AE '_RMS.emf']); %���O��figure��ۑ�
% end

inputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\sample\wav\center_listeningTest_sample\test_4\';
inputDirName_AE = 'C:\Users\share\Documents\MATLAB\voice_data\center_listeningTest\test_4\';

outputDirName = '../fig_data/RMS_comparison/';

for i = 1:1,
    inputName_AN = ['No1_S01_16kHz'];
    inputName_AE = ['No1_S01_16kHz_3dB_16band_hanning500Hz_Gainlimit6dB'];
    [AN.X, AN.fs]= audioread ([inputDirName inputName_AN '.wav']);
    [AE.X, AE.fs]= audioread ([inputDirName_AE inputName_AE '.wav']);

%     AN.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AN '_lab.txt'],'point',1/1000);
%     AE.label = sploadlabel([inputDirName 'label/ATR_label/' inputName_AE '_lab.txt'],'point',1/1000);
    
    frame_p = AN.fs/1000 * frame_t; %�T���v�����O���g��16kHz�̎��̃t���[����20ms%
    shift_p = AN.fs/1000 * shift_t; %�T���v�����O���g��16kHz�̎��̃t���[���V�t�g1ms%

    AN.R = floor((length(AN.X)-frame_p)/shift_p); %���͉����̒������V�t�g���Ŋ���A�i�[����x�N�g���̒��������߂�
    AE.R = floor((length(AE.X)-frame_p)/shift_p); %���͉����̒������V�t�g���Ŋ���A�i�[����x�N�g���̒��������߂�

    AN.rms = zeros(1,AN.R);
    AE.rms = zeros(1,AE.R);
    point = 1;
    for ii = 1:1:AN.R,
        x = AN.X(point:point+(frame_p-1));
        rmsV = getRms(x,frame_p);
        AN.rms(ii) = 20*log10(rmsV);
        point = point+shift_p;
    end
    
    point = 1;
    for ii = 1:1:AE.R,
        x = AE.X(point:point+(frame_p-1));
        rmsV = getRms(x,frame_p);
        AE.rms(ii) = 20*log10(rmsV);
        point = point+shift_p;
    end
    
%     x_lim = [AN.label(1).time-50 AN.label(end).time+50];
    y_lim = [min(AE.rms)-10 max(AE.rms)+10];
    fontsize = 20;
    ylabel_fontsize = 20;
    
    figure('Name',[''],'NumberTitle','off', 'Position',[1 1 9*scrsz(3)/10 5*scrsz(4)/10])
    plot(AN.rms,'b');
    set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
    xlabel('Time [ms]', 'fontsize', fontsize);
    ylabel('RMS [dB]', 'fontsize', ylabel_fontsize);
%     xlim(x_lim);
    ylim(y_lim)
%     spplotlabel(AN.label,'k:',26);
    
    hold on
    plot(AE.rms,'r');
%     xlim(x_lim)
    ylim(y_lim)
%     spplotlabel(AN.label,'k:',26);
    hold off
    
%     saveas(gcf,[outputDirName inputName_AE '_RMS.emf']); %���O��figure��ۑ�
end
