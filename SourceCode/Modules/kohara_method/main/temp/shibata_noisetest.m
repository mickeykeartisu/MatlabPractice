inputDirName = '../voice_data/sample/';

inputName = 'sample Normal';
% inputName = 'sample Normal2';
% inputName = 'he ra zu ke';

[X,fs_X] = audioread([inputDirName 'wav/' inputName '.wav']);
load ([inputDirName 'mat/' inputName]); %%Mat�f�[�^�ǂݍ���
% load ([inputDirName 'mat/label/' inputName '_label']) %�|�C���g�̏��%
label = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1/1000);
label2 = sploadlabel([inputDirName 'label/' inputName '_label.txt'],'point',1);

%%�p�����[�^�̎w��
%��������ϒ����g���̒l(Hz)
empha_Hz = 16;
%�Q�C���̑����̔{���̎w��(dB)
setGain = 0;
%�t�B���^��(�~���b)���w��
t = 6;
%���������`(2�ш�ɕ�������Ȃ�2 3�ш�Ȃ�3....)
T = [4 9]; 
%----------------------straight�X�y�N�g������ϓ����M�������߂�----------------------------

% cut_margin = 50; % ���x���ʒu����cut_margin�����L�߂ɂ���Ƃ�
% t_width = [t_s2e(1)-cut_margin t_s2e(2)+cut_margin];
% if t_width(1) < 1,
%     t_width(2) = 1;
% end
% if t_width(2) > size(n3sgram,2),
%     t_width(2) = size(n3sgram,2);
% end
% 
% n3sgram2 = n3sgram(:, t_width(1):t_width(2));
% ap2 = ap(:, t_width(1):t_width(2));
% f0raw2 = f0raw(t_width(1):t_width(2));

% n3sgram2 = n3sgram;

% figure
% plot(X);
% figure
% plot(log(n3sgram(:,1)));


[sigma, marg] = getPeakf2Sigma(empha_Hz);
if empha_Hz ==16,
    sigma = 14.0100;
end
if empha_Hz ==8,
    sigma = 27.9400;
end
if empha_Hz ==4,
    sigma = 55.5500;
end
% marg = 200;
marg = sigma * 5;


[gain_v] = getGain4normalization(sigma,setGain);

% dims = 1;

flag = 1; %-1:�Q�C���n��̐����𔽓]������@1:�Ȃɂ����Ȃ�

%�t�B���^�̐���
load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(t) 'ms'])
% n = 0:N-1;
% h0 = QMFDesign(N, 0.3, 1); % H0(z)���[�p�X�t�B���^
% % h0 = lowpass(0.25, 80, 0.3);
% g0 = h0;
% h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)�n�C�p�X�t�B���^
% g1 = -1 * h1;

%�t�B���^�[�̒x�������߂�
fd = conv(h0,g0); %filter delay���v�Z
[d,fd] = max(fd);
fdp = fd - 1; %�t�B���^�[�̒x�����v�Z�i�s�[�N-1�̒l�j
fdph = floor(fdp/2); 


%---------------�ēc���\�b�h�ɂ�鋭�����ꂽ�X�y�N�g�������߂�----------------
lifter = round(4 * fs /1000);
cep = getSt2Cep(n3sgram,lifter); %�֐�getSt2Cep�Ăяo��
LogCep = getLogCep(cep, sigma, marg,flag); %������
LogCep = LogCep * gain_v;
gainS = getCep2spec(LogCep, 2*(size(n3sgram,1)-1),'linear'); %�P�v�X�g�����̌W���s������g���̈�ɖ߂�% % 

if strcmp(inputName,'sample Normal'),
    x_lim = [195 4400];
    x_lim_s = [0 4200];
    fontsize = 12;
    freqinterbal = 1000;
    timeinterbal = 500;
    fre_range = 4000;
    rangedb = 70;
    maxdb = 0;
end
if strcmp(inputName,'sample Normal2'),
    x_lim = [200 2900];
    x_lim_s = [25 2725];
    
    fontsize = 12;
    freqinterbal = 1000;
    timeinterbal = 500;
    fre_range = 4000;
    rangedb = 70;
    maxdb = 5;
end

xplot_1 = (0:length(X)-1) ./ (fs/1000);
figure
plot(xplot_1,X);
% title([inputName ' 16Hz ' num2str(gain(g)) 'dB ' num2str(P{l})]);
xlim(x_lim)
xlabel('Time [ms]','FontSize',14)
ylabel('Amplitude','FontSize',14)
set( gca, 'FontName','MS UI Gothic','FontSize',12);
spplotlabel(label,'k:',18);

emp_sgram =  cell(length(T),1);

for t = 1:length(T)
    splitSgram =  cell(T(t),1);
    splitgainS =  cell(T(t),1);

    %n3sgram�𕪊�����
    buf_n3sgram = n3sgram;
    buf_sgram = gainS;
    for k = T(t):-1:2,
        splitSgram{k} = buf_n3sgram(ceil( size(buf_n3sgram,1)/2 ):end, :);
        splitSgram{k-1} = buf_n3sgram(1:ceil( size(buf_n3sgram,1)/2 ), :); 

        splitgainS{k} = buf_sgram(ceil( size(buf_n3sgram,1)/2 ):end, :);
        splitgainS{k-1} = buf_sgram(1:ceil( size(buf_n3sgram,1)/2 ), :); 

        buf_sgram = splitgainS{k-1};    
        buf_n3sgram = splitSgram{k-1};
    end

    emp_sgram{t} = n3sgram;
    s_point = 1;
    for k = 1:T(t),
        range = size(splitgainS{k},1);

        splitgainS{k} = mean(splitgainS{k});
        splitgainS{k} = repmat(splitgainS{k},range,1);

        emp_sgram{t}(s_point:s_point + range-1,:) = emp_sgram{t}(s_point:s_point + range-1,:) .* splitgainS{k};

        s_point = s_point + range - 1;
    end
end

load([inputName '_emp_n3sgram_Peak16'])

scrsz = get(0,'ScreenSize');
figure('Name',inputName,'NumberTitle','off', 'Position',[0 0 scrsz(3) scrsz(4)])
subplot(length(T),2,1)
dispsgram_color(n3sgram,fs,1, 'original' , fontsize, freqinterbal, timeinterbal, fre_range, rangedb, maxdb);
xlim(x_lim)
for t = 1:length(T)
    subplot(length(T),2,t+1)
    dispsgram_color(emp_sgram{t},fs,1,[num2str(T(t)) 'band'], fontsize, freqinterbal, timeinterbal, fre_range, rangedb, maxdb);
    xlim(x_lim)
%     saveas(gcf,[outputDirName outputName '_waveform.emf']);
end
subplot(length(T),2,length(T)+2)
dispsgram_color(shibata_emp_sgram,fs,1,'shibata spectrogram', fontsize, freqinterbal, timeinterbal, fre_range, rangedb, maxdb);
xlim(x_lim_s)

outputDirName = '../fig_data/BandDivision_tec/shibata_noisetest/';
outputName = [inputName '_' num2str(T(1)) 'Band_' num2str(T(2)) 'Band'];
% saveas(gcf,[outputDirName outputName '.emf']); %���O��figure��ۑ�