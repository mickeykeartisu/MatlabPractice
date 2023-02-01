function [gainS_rev, gainS, gainS2_rev ,gainS2] = getGainSeries3(gainM,T,flag,w,fs,maxfreq)
%�W���s�񂩂�Q�C���n������߂�i�e�[�p�[�����g�pVer�j�����͂̌W���s���dB�l
%���Ō�Z���z��𔽓]�����Ă��闝�R
%��main�̑ш敪�������ŁC�ш敪����̔g�`���i�[����ϐ��ɁC1���珇�ɍ���̑ш�̔g�`���i�[���Ă���̂ŁC����ɑΉ�����悤�C���]�����Ă܂��D
%���������C�����Ă��炦��΁C�Ō�Z���z��𔽓]����K�v�͂���܂���
%gainM�F�W���s��
%T�F�ш敪��
%frag�F�n��𔽓]�����邩
%w�F����I��
%

if nargin < 3,
    flag = 0;
end
if nargin < 4,
    w = 'ones';
end

if nargin < 5,
    fs = 16000;
end

if nargin < 6,
    maxfreq = fs/2;
end

if strcmp(w,'ones'),
    win = ones( size(gainM,1),size(gainM,2) );
end
if strcmp(w,'hanning'),
    if maxfreq == fs/2,
        win = hann( size(gainM,1)*2,'periodic');
        win = win(1:size(gainM,1));
        win = repmat(win,1,size(gainM,2));
    else
        oneBand = (fs/2)/T; %1�ш�̎��g���͈͂����߂�
        maxNumber = maxfreq/oneBand;
        maxPoint = fix(size(gainM,1)/T) * maxNumber;
                   
        fil = hann(maxPoint*2,'periodic');
        win = ones(size(gainM,1),1);
        win(1:maxPoint-1,1) = fil(1:maxPoint-1,1);
%         figure
%         plot(win);
%         keyboard
%         win(maxPoint+1:end,1) = ones(size(gainM,1) - maxPoint,1);
%          keyboard
        win = repmat(win,1,size(gainM,2));
    end
%     figure
%     plot(win(:,1));
%     keyboard
    

end

% %�m�F�p%
% j =50;
% gainM_1_dB = gainM(:,j);
% gainM_1_win_dB = gainM_1_dB .* win(:,j);
% 
% plot_gain = linspace(0,8000,length(gainM_1_dB));
% figure
% plot(plot_gain,gainM_1_dB,'b');
% hold on
% plot(plot_gain,gainM_1_win_dB,'r');
% hold off
% xlabel('Frequency [Hz]')
% ylabel('Spectrum [dB]')
% legend('gainM(1)-dB','gainM-1(1)*win-dB')
% 
% gainM_1_lin = (gainM_1_dB/20)*log(10);
% gainM_1_lin = exp(gainM_1_lin);
% gainM_1_win_lin = (gainM_1_win_dB/20)*log(10);
% gainM_1_win_lin = exp(gainM_1_win_lin);
% 
% 
% 
% figure
% plot(gainM_1_lin,'b');
% hold on
% plot(gainM_1_win_lin,'r');
% hold off
% legend('gainM(1)-lin','gainM-1(1)*win-lin')
% keyboard

%�W���s��ɑ���������
gainM2 = gainM;
gainM = gainM.*win;


lim_fontsize = 20;
fontsize = 20;

scrsz = get(0,'ScreenSize');
fig_size = [0.1 0.1 1.6*scrsz(3)/5 0.8*scrsz(4)/2]; %�C�_�p

figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
x = linspace(0,8000,length(win(:,1)));
plot(x,win(:,1), 'r' ,'linewidth', 3);
xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
ylabel('', 'fontsize', lim_fontsize)
set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
xlim([0 1000])
ylim([0 1.1])

% temp = 1;
[temp2, temp]= max(gainM2(1,:));

y_lim = [1 20];

figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
x = linspace(0,8000,length(gainM2(:,temp)));
plot(x,exp(gainM2(:,temp)/20*log(10)),'linewidth', 3);
% plot(x,gainM2(:,temp),'linewidth', 2);
xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
ylabel('Magnification', 'fontsize', lim_fontsize)
set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
xlim([0 1000])
ylim(y_lim)

figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
x = linspace(0,8000,length(gainM(:,temp)));
plot(x,exp(gainM(:,temp)/20*log(10)),'linewidth', 3);
% plot(x,gainM(:,temp),'linewidth', 2);
xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
ylabel('Magnification', 'fontsize', lim_fontsize)
set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
xlim([0 1000])
ylim(y_lim)

figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
x = linspace(0,8000,length(gainM2(:,temp)));
plot(x,exp(gainM2(:,temp)/20*log(10)),'linewidth', 3);
hold on
% plot(x,gainM2(:,temp),'linewidth', 2);
plot(x,exp(gainM(:,temp)/20*log(10)),'r--','linewidth', 4);
hold off
% plot(x,gainM(:,temp),'linewidth', 2);
xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
ylabel('Magnification', 'fontsize', lim_fontsize)
set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
legax = legend('Before processing', 'After processing');
set(legax, 'fontsize', fontsize)
xlim([0 1000])
ylim(y_lim)


figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
x = linspace(0,8000,length(gainM2(:,temp)));
% plot(x,exp(gainM2(:,temp)/20*log(10)),'linewidth', 2);
plot(x,gainM2(:,temp)/20,'linewidth', 3);
xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
ylabel('Log magnification', 'fontsize', lim_fontsize)
set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
xlim([0 1000])
ylim([0 1.4])

figure('Name',[''],'NumberTitle','off', 'Position',fig_size)
x = linspace(0,8000,length(gainM(:,temp)));
% plot(x,exp(gainM(:,temp)/20*log(10)),'linewidth', 2);
plot(x,gainM(:,temp)/20,'linewidth', 3);
xlabel('Frequency [Hz]', 'fontsize', lim_fontsize)
ylabel('Log magnification', 'fontsize', lim_fontsize)
set( gca, 'FontName','MS UI Gothic','FontSize',fontsize);
xlim([0 1000])
ylim([0 1.4])
keyboard


% keyboard
%�W���s���dB����linear��
% gainM =  (gainM/20)*log(10);
% gainM = exp(gainM);
% 
% gainM2 =  (gainM2/20)*log(10);
% gainM2 = exp(gainM2);

%�e�[�p�[���̐���%
L = fix( size(gainM,1)/T );
tL = L/0.8; %%�Ώۂ�1/0.8�{�̒������`
gap = (tL - L)/2;
hl = (tL)*0.4; %%�e�[�p�[�̗]��������S�̂�4���Ƃ���

H = hann(hl,'periodic' );
H = H(1:end/2);
taper = ones(tL+1,1);
taper(1:length(H)) = taper(1:length(H)).* H;
taper(end-length(H)+1:end) = taper(end-length(H)+1:end) .* flipud(H);

t = repmat(taper,1,size(gainM,2)); %�e�[�p�[�����g��
% t = repmat(ones(size(taper,1),size(taper,2)),1,size(gainM,2)); 
% keyboard


gainS = cell(T,1);
gainS_rev = cell(T,1);

%taper�����Ȃ��p%
gainS2 = cell(T,1);
gainS2_rev = cell(T,1);

shift = L;
st = 1;
tL = tL+1;
% keyboard
for i = 1:T,
    if i == 1,
        gainS2{i} = gainM2(st:st+tL-gap-1 , :) .* t(gap+1:end,:);
        gainS{i} = gainM(st:st+tL-gap-1 , :) .* t(gap+1:end,:);
        st = st + shift-gap-1+1;
%         keyboard
    elseif i == T,
%         keyboard
        gainS2{i} = gainM2(st:st+tL-gap-1,:) .* t(1:end-gap,:);
        gainS{i} = gainM(st:st+tL-gap-1,:) .* t(1:end-gap,:);
        st = st + shift-gap;
%         keyboard
    else
        gainS2{i} =gainM2(st:st+tL-1,:) .* t;
        gainS{i} =gainM(st:st+tL-1,:) .* t;
        st = st + shift-1+1;
    end
%     gainS{i} = gainM(st:st+shift , :);
%     st = st+shift;
end

% if flag ==1,
%     for k = 1:T,
%         gainS_rev{k} = gainS{T+1-k};
%         gainS2_rev{k} = gainS2{T+1-k};
%     end
% end
if flag ==1,
    for k = 1:T,
        gainS_rev{k} = exp( gainS{T+1-k}/20*log(10) );
        gainS2_rev{k} =exp( gainS2{T+1-k}/20*log(10) );
    end
end
%�^���ɖ߂�
for k = 1:T,
    gainS{k} = exp( gainS{k}/20*log(10) );
    gainS2{k} =exp( gainS2{k}/20*log(10) );
end

% keyboard
end

