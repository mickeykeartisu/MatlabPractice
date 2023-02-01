%�����g�`��n�ɕ������čč\������v���O����(�����̂�)
% clear all;
inputDirName = '../voice_data/sample/';

inputName = 'sample Normal';
% inputName = 'sample Normal_kita';
% inputName = 'sample Normal_kawa';
% inputName = 'sample Normal2';
% inputName = 'he ra zu ke';

[X,fs] = audioread([inputDirName 'wav/' inputName '.wav']);

%���������`(2�ш�ɕ�������Ȃ�2 3�ш�Ȃ�3....)
T = [4]; 
%�t�B���^��(�~���b)���w��
t = 6;

%�t�B���^�̐���
% N = 96%�t�B���^�̃|�C���g��
% % n = 0:N-1;
% h0 = QMFDesign(N, 0.3, 1); % H0(z)���[�p�X�t�B���^
% % h0 = lowpass(0.25, 100, 0.3);
% g0 = h0;
% h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)�n�C�p�X�t�B���^
% g1 = -1 * h1;

load(['./QMFfilterCoefficient_mat/' num2str(fs) 'Hz_' num2str(t) 'ms'])

%�t�B���^�[�̒x�������߂�
fd = conv(h0,g0); %filter delay���v�Z
[d,fd] = max(fd);
fdp = fd - 1; %�t�B���^�[�̒x�����v�Z�i�s�[�N-1�̒l�j
fdph = floor(fdp/2); 
% fdph = fdp; 

    
for t = 1:length(T)

    L = T(t)-1;
    mode = 1; 
    % 1:�P�v�X�g������2�K���������n����t�[���G�ϊ����Čn������߂�(���`�ɖ߂��Ă��畽��)
    % 2:�P�v�X�g������2�K���������n����t�[���G�ϊ����Čn������߂�(���ς��Ă�����`�ɖ߂�)
    % 3:�������ꂽ�X�y�N�g��/�X�y�N�g���Ōn������߂�
    % 4:���莟���̃P�v�X�g��������Q�C���n������߂�(���_�̌n��)


    %�Z���z��̒�`   
    stock = cell(T(t),1);
    
    %���[�v1:�����̑ш敪��
    stock{1} = X;
    for i =1:log2(T(t)),
        for ii=1:2^( log2(T(t)) +1-i ):T(t),
            p = 2^( log2(T(t)) - i);
            stock{ii+p} = conv(h0,stock{ii});
%             keyboard
            stock{ii+p} = stock{ii+p}(1+fdph:end);
%             stock{ii+p} = stock{ii+p}(1:2:length(stock{ii+p}));
            
            stock{ii} = conv(h1,stock{ii});
            stock{ii} = stock{ii}(1+fdph:end);
%             stock{ii} = stock{ii}(1:2:length(stock{ii}));
        end
    end
    
    soundsc(stock{3},16000,24); 
    
    
    %���[�v3;�����̍č\��
    stockRe = stock;
    for i =log2(T(t)):-1:1,
        for ii=1:2^( log2(T(t)) +1-i ):T(t),
            p = 2^( log2(T(t)) - i);
%             stockRe{ii+p} = upsample(stockRe{ii+p},2);
            stockRe{ii+p} = conv(g0,stockRe{ii+p});
            stockRe{ii+p} = stockRe{ii+p}(1+fdph:end);
            
%             stockRe{ii} = upsample(stockRe{ii},2);
            stockRe{ii} = conv(g1,stockRe{ii});
            stockRe{ii} = stockRe{ii}(1+fdph:end);
            
%             stockRe{ii} = 2*(stockRe{ii}+stockRe{ii+p});
            stockRe{ii} = stockRe{ii}+stockRe{ii+p};
            stockRe{ii} = stockRe{ii}(1+1:end);
%             keyboard
        end
        if i ==1,
           keyboard 
            ReX = stockRe{i}(1:length(X));
        end
    end

    % %--------S/N��--------
    S = sqrt(mean((X.^2))); 
    N = sqrt(mean((ReX-X).* conj(ReX-X)));
    SN = 20*log10(S/N)
    
%     disp(['SN_' num2str(T(t)) 'band:' num2str(SN)]);
    
end