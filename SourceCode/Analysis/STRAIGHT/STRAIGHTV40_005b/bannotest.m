% WAV�t�@�C���ǂݍ���
[x, fs, nbits] = wavread('vaiueo2d.wav');
% STRAIGHT�́A16�r�b�g�ʎq�������肵�Ȃ��Ƃ��܂����삵�Ȃ����Ƃ�����B
x = x .* 32768; 

% ��{���g�����o
% [f0raw, ap] = exstraightsource(x, fs);
%sourceParams.NewVersion = 1; % �ŐV�ł̊�{���g�����o���g��
sourceParams.F0searchLowerBound=40; % ���g���T���͈͂̉���
sourceParams.F0searchUpperBound=800; % ���g���T���͈͂̏��
[f0raw, ap] = exstraightsource(x, fs, sourceParams);

% STRAIGHT���́iSTRAIGHT�X�y�N�g���O�����̒��o�j
[n3sgram] = exstraightspec(x, f0raw, fs);

% STRAIGHT����
% pconv: ��{���g���ϊ���, fconv: ���g�����ϊ���, sconv: ���Ԏ��ϊ���
synthParams.pconv = 1.0; synthParams.fconv = 1.0; synthParams.sconv = 1.0;
[sy] = exstraightsynth(f0raw, n3sgram, ap, fs, synthParams);

% �������̍Đ�
sound(sy ./ 32768, fs);

% �X�y�N�g���O�����̕\���i���Ǝ��֐��j
dispsgram(n3sgram, fs);
