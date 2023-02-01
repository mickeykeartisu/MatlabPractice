clear all
inputName = 'sample Normal';

[A,fs] = audioread([inputName '.wav']);
load (inputName);
% label = sploadlabel([inputName '_label.txt'],'point',1/1000);


[Hd, b]= Bandtest(fs,100,10,16); %%�o���h�p�X�t�B���^���`
freqz(b,1)

% figure
% plot(n3sgram);

%�P�v�X�g���������߂�
lifter = 0;
cep = getSt2Cep(n3sgram,1);
% cep(1,:) = []; %0�����폜
cep = 10.^(cep);
%


n3sgram_1 = n3sgram(:,1); 
% 
% figure
% plot(n3sgram_1);

% X = filter2(b,n3sgram_1,'same');

% figure
% plot(n3sgram_1.*b');

X = filter2(b,cep);
plot(log(X))

%%
%�ēc���\�b�h
gain_v = getGain4normalization(sigma_v, set_gain_dB, marg_v);
cep = getSt2Cep(n3sgram,1);cep_emp = cell(length(sigma_v), 1); %�Z���z��
n3sgram_emp = cell(length(sigma_v), 1); %�Z���z��
for v=1:length(sigma_v),
    LogCep = getLogCep(cep, sigma_v(v), marg_v(v)); %������
    cep_emp{v} = cep + LogCep * gain_v(v);
    n3sgram_emp{v} = getCep2spec(cep_emp{v}, 2*(size(n3sgram,1)-1), 'linear');
    
    LogCepNorm{v} = (20/log(10)) .* sqrt( 2 .* sum((LogCep(2:end,:)* gain_v(v)).^2, 1) );
end


%%
%�t�B���^�K�p�O�ƓK�p��̎��n��̐M�������g���̈�ɕϊ�
cep_fft = fft(cep,512); %�t�[���G�ϊ�
cep_fft = abs(cep_fft); %��ΐ������߂�
cep_fft = 20*log10(cep_fft);
figure
plot(cep_fft(1:257)); 
title('1���̎��n��')
setLabel('Frequency[Hz]', 'log amplitude', '', 16);
set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 


X_fft = fft(X,512); %�t�[���G�ϊ�
X_fft = abs(X_fft); %��ΐ������߂�
X_fft = 20*log10(X_fft);
figure
plot(X_fft(1:257)); 
title('�t�B���^�K�p��')
setLabel('Frequency[Hz]', 'log amplitude', '', 16);
set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 

% xplot = (0:length(cep)-1);
% figure
% plot(xplot,20*log10(cep));
% title(['1���P�v�X�g�����̎��n��'])
% setLabel('Time[ms]', 'log amplitude', '', 16);
% set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
% xlim([1 max(xplot)])
% figure
% plot(xplot,20*log10(X));
% title(['�t�B���^�K�p��'])
% setLabel('Time[ms]', 'log amplitude', '', 16);
% set( gca, 'FontName','MS UI Gothic','FontSize',14 ); 
% xlim([1 max(xplot)])




