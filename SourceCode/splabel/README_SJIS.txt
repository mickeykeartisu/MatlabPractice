
	splabel  - MATLAB��spwave�p���x���t�@�C�����������߂̃��C�u����


�͂��߂�
--------

MATLAB�ŁAspwave�p���x���t�@�C����ǂݍ��񂾂�A�\�������肷�邽�߂�
���C�u�����ł��B


�g�p���@
--------

SPLOADLABEL: ���x���ǂݍ��݊֐��Bspwave�p���x����ǂݍ��݂܂��B

LABEL = SPLOADLABEL(FILENAME);  'sec'�i�b�t�H�[�}�b�g�j���x���p
LABEL = SPLOADLABEL(FILENAME, FORMAT);  
LABEL = SPLOADLABEL(FILENAME, FORMAT, FS);  'point'�i�|�C���g�t�H�[�}�b�g�j���x���p

 LABEL: ���x���̍\���̂ł��Btime�i�b�j�Aphoneme�i���f�j�Adata�i�f�[�^�j��
        �t�B�[���h���p�ӂ���Ă��܂��B�Ⴆ�΁Ak�Ԗڂ̃��x���̉��f�ɂ́A
        label(k).phoneme �ŃA�N�Z�X�ł��܂��B
 FORMAT: ���Ԃ̃t�H�[�}�b�g�ł��B'sec', 'msec', 'point'����I�����܂��B
 FS: �|�C���g�t�H�[�}�b�g�ɂ�����T���v�����O���g�����w�肵�܂��B


SPPLOTLABEL: ���x���v���b�g�֐��B���łɃv���b�g����Ă���}�i�����g�`��
             �X�y�N�g���O�����j�̏�ɏd�˂ă��x�����v���b�g���܂��B
��Ȏg�����͈ȉ��̒ʂ�ł��i���ɂ�����܂����A�ڍׂ�help spplotlabel���Q�Ɖ������j�B

SPPLOTLABEL(LABEL);  'sec'�i�b�t�H�[�}�b�g�j���x���p
SPPLOTLABEL(LABEL, LINESPEC);  'sec'�i�b�t�H�[�}�b�g�j���x���p
SPPLOTLABEL(LABEL, LINESPEC, FONTSIZE);  'sec'�i�b�t�H�[�}�b�g�j���x���p
SPPLOTLABEL(LABEL, FORMAT);			
SPPLOTLABEL(LABEL, FORMAT, LINESPEC);	
SPPLOTLABEL(LABEL, FORMAT, LINESPEC, FONTSIZE);

 LINESPEC: plot�֐��Ɠ��l�̐���̐ݒ�̂��߂̈����ł��B
           �Ⴆ�΁A'b:'�Ȃǂ��w��ł��܂��B
 FONTSIZE: ���f�̕\���ɗp����t�H���g�T�C�Y�ł��B�f�t�H���g��16�ł��B
 FORMAT: ���łɃv���b�g����Ă���}�ɂ����鎞�Ԃ̃t�H�[�}�b�g�ł��B
         'sec', 'msec', 'point'����I�����܂��B


�g�p��
------

testlabel.m ���Q�Ƃ��ĉ������B


--
���G���iBanno Hideki�j
