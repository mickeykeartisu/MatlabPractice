clear all;
inputDirName = '../voice_data/sample/';

inputName = 'sample Normal';
% inputName = 'sample Normal_kita';
% inputName = 'sample Normal_kawa';
% inputName = 'sample Normal2';
% inputName = 'he ra zu ke';

[X,fs_X] = audioread([inputDirName 'wav/' inputName '.wav']);

%���������`(2�ш�ɕ�������Ȃ�2 3�ш�Ȃ�3....)
T = [4 5 6 7 8 9]; 


%�t�B���^�̐���
N = 96%�t�B���^�̃|�C���g��
% n = 0:N-1;
h0 = QMFDesign(N, 0.3, 1); % H0(z)���[�p�X�t�B���^
% h0 = lowpass(0.25, 100, 0.3);
g0 = h0;
h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)�n�C�p�X�t�B���^
g1 = -1 * h1;

%�t�B���^�[�̒x�������߂�
fd = conv(h0,g0); %filter delay���v�Z
[d,fd] = max(fd);
fdp = fd - 1; %�t�B���^�[�̒x�����v�Z�i�s�[�N-1�̒l�j
fdph = floor(fdp/2); 

    
for t = 1:length(T)

    L = T(t)-1;


    %�Z���z��̒�`
    LowX = cell(L,1);
    HighX = cell(L,1);
    LowXRe =  cell(L,1);
    HighXRe = cell(L,1);
    % Lsgram = cell(L,1); %����straight�X�y�N�g���O�������i�[
    % Hsgram = cell(L,1); %����́V
    LCep = cell(L,1); %���̃P�v�X�g�����̎��n����i�[
    HCep = cell(L,1); %����́V


    %���[�v1:�����̑ш敪��
    buf_X = X; %�g�`�̃o�b�t�@
    for i =1:L,
        LowX{i} = conv(h0,buf_X);
        LowX{i} = LowX{i}(1+fdph:end);
        LowX{i} = LowX{i}(1:2:length(LowX{i})); %�_�E���T���v�����O

        HighX{i} = conv(h1,buf_X);
        HighX{i} = HighX{i}(1+fdph:end);
        HighX{i} = HighX{i}(1:2:length(HighX{i})); %�_�E���T���v�����O

        buf_X = LowX{i};
    end

    %���[�v3;�����̍č\��
    for i = L:-1:1,
       if i == L,
           LowXRe{i} = upsample(LowX{i},2); %�A�b�v�T���v�����O
    %        disp('first');
       else
           LowXRe{i} = upsample(LowXRe{i},2); %�A�b�v�T���v�����O
    %        disp('second');
       end

       LowXRe{i} = conv(g0,LowXRe{i});
       LowXRe{i} = LowXRe{i}(1+fdph:end); %�x�����l��

       HighXRe{i} = upsample(HighX{i},2); %�A�b�v�T���v�����O
       HighXRe{i} = conv(g1,HighXRe{i});
       HighXRe{i} = HighXRe{i}(1+fdph:end); %�x�����l��

       LowXRe{i} = LowXRe{i}(1:length(HighXRe{i}));

       if i ~= 1,
           LowXRe{i-1} = 2*(LowXRe{i}+HighXRe{i});
           LowXRe{i-1} = LowXRe{i-1}(1+1:end);
       end
    end
    ReX = 2*(LowXRe{1} + HighXRe{1});
    ReX = ReX(1+1:length(X)+1);

    % %--------S/N��--------
    S = sqrt(mean((X.^2))); 
    N = sqrt(mean((ReX-X).* conj(ReX-X)));
    SN = 20*log10(S/N);
    
    disp(['SN_' num2str(T(t)) 'band:' num2str(SN)]);
    
end