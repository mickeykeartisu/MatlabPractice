%%QMF�ɗp����t�B���^h0�̌W�������߁Amat�f�[�^�Ƃ��ĕۑ�����v���O����

%�����̃T���v�����O���g�����w��
fs = 48000;
%�t�B���^��(�~���b)���w��
t = 10;
%�t�B���^�����w��
N = fs/1000 * t;

% keyboard

h0 = QMFDesign(N, 0.3, 1); % H0(z)���[�p�X�t�B���^

g0 = h0;

h1 = ((-1).^(0:length(h0)-1))'.*h0; % H1(-z)�n�C�p�X�t�B���^

g1 = -1 * h1;


outputDirName = './QMFfilterCoefficient_mat/';
filename = [num2str(fs) 'Hz_' num2str(t) 'ms'];

save ([outputDirName filename], 'h0', 'g0', 'h1', 'g1');

