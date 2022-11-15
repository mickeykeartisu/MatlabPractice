
	dpMatch, dpMatchConstraint  - DP�}�b�`���O�̎��s


�͂��߂�
--------

DP�}�b�`���O�����s����Matlab�̃v���O�����ł��B����ɂ��A���
�����x�N�g����̎��ԓI�Ή��֌W�����߂邱�Ƃ��ł��܂��B


�g�p���@
--------

�����ŌX�ΐ�����݌v�������ꍇ��DPMATCHCONSTRAINT���A�����łȂ��ꍇ��DPMATCH
���g���܂��B

[DIST, MAP, G] = DPMATCH(XMAT, YMAT, START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR)
[DIST, MAP, G] = DPMATCH(XMAT, YMAT, START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR, DIST_FUNC)
[DIST, MAP, G] = DPMATCHCONSTRAINT(CONSTRAINT, XMAT, YMAT, ...
 				   START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR)
[DIST, MAP, G] = DPMATCHCONSTRAINT(CONSTRAINT, XMAT, YMAT, ...
 				   START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR, DIST_FUNC)

 XMAT, YMAT: ���͍s��ł��B���ꂼ��̗񂪓����x�N�g���ɂȂ��Ă���K�v������܂��B
             �����x�N�g����1�����̏ꍇ�́A���͍s�񂪍s�x�N�g���ɂȂ�܂��B
 CONSTRAINT: �X�ΐ��������肷��s��ł��B���L�Q�ƁB
 START_FREE_NFRAME: �n�_�t���[�̃t���[�����ł��B0�̏ꍇ�͎n�_�t���[�͖����ɂȂ�܂��B
 END_FREE_NFRAME: �I�_�t���[�̃t���[�����ł��B0�̏ꍇ�͏I�_�t���[�͖����ɂȂ�܂��B
 LIMIT_FACTOR: �ݐϘc�݂̌v�Z�͈͂𐧌�����W���ł��B0�ɋ߂��قǌv�Z�͈͂����肳��܂��B
               1�̏ꍇ�͐������Ȃ��A0�̏ꍇ�ɂ̓f�t�H���g�l���g�p���܂��B
 DIST_FUNC: �c�݂��v�Z����֐����w�肵�܂��B�ȗ�����ƁA�f�t�H���g�ł��郆�[�N���b�h�������g���܂��B
            �֐��́A`func(xvec, yvec)'�̌`�ɂȂ��Ă���K�v������܂��B
 DIST: �ŏI�I�ɓ�����ݐϋ����ł��B
 MAP: �o�H���i���ԓI�Ή��֌W�j��ۑ������x�N�g���ł��B
      XMAT�̎��Ԏ��i�t���[�����j��YMAT�̂ǂ̎��ԁi�t���[�����j�ɑΉ����Ă��邩�������Ă��܂��B
      �����͊�{�I��XMAT�̗񐔂Ɠ����ɂȂ�܂����A
      �I�_�t���[���L���ȏꍇ�ɂ́A����Ƃ͈قȂ�l�ɂȂ邱�Ƃ�����܂��B
 G: �ݐϋ����s��ł��B�傫���́uXMAT�̗� x YMAT�̗񐔁v�ƂȂ�܂��B


�X�ΐ����s��
------------

�ȉ��̂悤�Ȍ`���ɂȂ��Ă���K�v������܂��B

CONSTRAINT = [ IS_FIRST_NODE  X_DIFF  Y_DIFF  WEIGHT ;
	                     :                       ;
                             :                        ]
 IS_FIRST_NODE: 1���ŏ��̃m�[�h�������A0�������ł͂Ȃ��m�[�h�������܂��B
 X_DIFF: �m�[�h�Ԃ�X�������̕ψʂł��B
 Y_DIFF: �m�[�h�Ԃ�Y�������̕ψʂł��B
 WEIGHT: �m�[�h�Ԃɗ^������d�݂ł��B

��F
%      o--o
%    /  / |
%   o  o  o
%        /
%      o
  constraint = [ 1 -1  0  1;
                 0 -1 -1  2;
		 1 -1 -1  2;
		 1  0 -1  1;
		 0 -1 -1  2];
%        o-----o
%     / /  /  /
%   o    o  
%    /     /
%   o    o
  constraint = [ 1 -1 -2  1;
                 1 -1 -1  1;
		 1 -1  0  1;
		 0 -1 -2  1;
		 1 -1  0  1;
		 0 -1 -1  1];



�g�p��
------

% 2�̃T�C���g��Ή��t����v���O����

xlen = 256; ylen = 256;
fx = 100; fy = 110;
xdelay = 5; ydelay = 10;
x = [zeros(1, xdelay) sin(2 * pi * fx * (0:(xlen-1)) / xlen)];
y = [zeros(1, ydelay) sin(2 * pi * fy * (0:(ylen-1)) / ylen)];

[dist, map, g] = dpMatch(x, y, 10, 50, 0.6);

imagesc(min(g', 100)); axis xy; hold on;
plot(map, 'w', 'LineWidth', 2);

figure;
plot(1:length(map), x(1:length(map)), 1:length(map), y(map));


--
���G���iBanno Hideki�j
