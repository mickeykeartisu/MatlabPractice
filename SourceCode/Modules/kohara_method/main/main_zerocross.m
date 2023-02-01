%�e�����̗�����_�𒊏o����v���O����
clear all;
close all;

st = 1;                 %�t�@�C���̓ǂݍ��݊J�n�ԍ�
ed = 1;                %�t�@�C���̓ǂݍ��ݏI���ԍ�

inputDirName = '../voice_data/sample/';
inputDirName2 = '../voice_data/';
inputDirName_mat = '../voice_data/sample/';

frame_t = 6; %�t���[����(�~���b)
shift_t = 3; %�V�t�g���i�~���b�j
for i = st:ed
    inputName = ['AN' num2str(i,'%02d')];
    [X, fs]= audioread ([inputDirName 'wav/ATR_16kHz/' inputName '.wav']);
%     label = get_label_tanabe(i);        %�����̃��x�����𒊏o
    label = sploadlabel([inputDirName 'label/ATR_label/' inputName '_lab.txt'],'point',1);
    
%     N_zero = zeros(length(label),1);
%     zerocross_time = zeros(length(label),1);
    
    [X_zerocross, frame_p, shift_p]= getZerocross(X,fs,frame_t,shift_t);
%     keyboard
    
    xplot = (0:length(X_zerocross)-1) .* shift_p ./ (fs/1000);
%     xplot = linspace(1,X*,length(X_zerocross))
    xplot_1 = (0:length(X)-1) ./ (fs/1000);
    
    
%     figure
%     subplot 211
%     plot(xplot_1,X);
%     
%     subplot 212
    plot(xplot,X_zerocross);
    xlim([1 length(X_zerocross)])
    set( gca, 'FontName','MS UI Gothic','FontSize',20);
    a = ylabel('Zero crossing rate', 'fontsize', 20);
    xlabel('Time [ms]', 'fontsize', 20);
%     
    
    outputname = [inputName '_zerocorss'];
%     save(['C:/work/kennkyu/zerocross/mat/' rfilename '.mat'],'N_zero','zerocross_time','fs');
%     save([outputname '.mat'],'N_zero','zerocross_time','fs');
end

    