kakasi�̃C���X�g�[��
--------------------

kakasi-2.3.4.zip ���𓀂��A����kakasi�t�H���_�� c:\ �̉��ɃR�s�[����B
���̃t�H���_�\���łȂ��Ɛ��������삵�Ȃ��i�ݒ肷��΂Ȃ�Ƃ��Ȃ邪�A�ȗ��j�B
�������R�s�[����Ă���΁Ac:\kakasi\bin\kakasi.exe �����݂���͂��B


�񓚃t�@�C���̍쐬
------------------

�G�N�Z���ŃJ�^�J�i�œ��͂��AParamfile�Ɠ����t�H���_��CSV�t�@�C���Ƃ��ĕۑ�����B
exercise�̕��͓��͂��Ȃ��B
�Ȃ��A4���[���ɂȂ��Ă��Ȃ��ꍇ�͏����ł��Ȃ����߁A�󗓂Ƃ���
���͂���B�t�@�C�����́A�ȉ��Őݒ�ł��邪�A�������u_words.csv�v��
����̂��ǂ��B

��: Test_answer3_words.csv

���ɁA���̃t�@�C����kakasi��p���ĉ��f�ɕϊ�����B�ϊ���̃t�@�C�����́A
�������u_words.txt�v�Ƃ��邱�ƁB

��: Test_answer3_words.csv����͂Ƃ���Test_answer3_words.txt���o�͂���ꍇ

c:\kakasi\bin\kakasi.exe -Ha -Ka -Ja -ka < Test_answer3_words.csv > Test_answer3_words.txt


�ݒ�
----

�܂��A�ȉ��̕ϐ��������̃}�V���ɍ��킹�ĕҏW�B
���ׂẴt�H���_�͑��݂��Ă���K�v������B

  workdir : ���o�̓t�@�C��������t�H���_�̏�ʃt�H���_
  idir : workdir�̉��̓��̓t�@�C��������t�H���_
  odir : workdir�̉��̏o�̓t�@�C����ۑ�����t�H���_
  param_file : Paramfile�̖��O�B�Ⴆ��'Paramfile.txt'
  list_file : List�t�@�C���̖��O
  master_file : Master�t�@�C���̖��O

���ɁAuser_list��ҏW����B

user_list = strvcat(user_list, 'Test_answer3');

�ȂǂƂȂ��Ă���ӏ��ɂ����āA�K�v�Ȑ������t�@�C����ǉ��B�g���q�͕t���Ȃ��B

�܂��AParamfile������t�H���_�ɁA�����t�@�C��'correct_master.txt'���K�v�B


���s
----

% mkconfusion_kohara


�t�@�C�����ɂ���
------------------

<�팱�Җ�><���[��ID>_confusion_<������>.csv : �l�̌���
<�팱�Җ�><���[��ID>_confusion_<������>_normalized.csv : �l�̌��ʁi�����Ɋ��Z�j
<�팱�ҌQ��><���[��ID>_confusion_<������>_mean.csv : �팱�ҌQ�ɂ����镽��
<�팱�ҌQ��><���[��ID>_confusion_<������>_mean_normalized.csv : �팱�ҌQ�ɂ����镽�ρi�����Ɋ��Z�j
<�팱�ҌQ��><���[��ID>_confusion_<������>_std.csv : �팱�ҌQ�ɂ�����W���΍�
<�팱�ҌQ��>_correct<���[��ID>.csv�F�팱�ҌQ�ɂ����鐳��
<�팱�ҌQ��>_%correct<���[��ID>.csv�F�팱�ҌQ�ɂ����鐳��

<�팱�ҌQ��>:
 all: �S��

<���[��ID>:
"": �S���[������
_mora1: ��1���[���̂�
_mora2: ��2���[���̂�
_mora3: ��3���[���̂�
_mora4: ��4���[���̂�

<������>:


�R���t���[�W�����}�g���b�N�X�ɂ���
------------------------------------

* �s: �掦�����̉��f
* ��: �񓚂������f�B�uNull�v�́A�u�񓚂Ȃ��v�̏ꍇ�̐��B
* �E�[�̗�: ���a


�����\�L�ɂ���
----------------

* �um�v���� �u.�v�܂łœ���Ȃ���
 S: ���A����A����A����
 tS: ���A����A����A����
 d3:  ���A����A����A����
 hj: �ЁA�Ђ�A�Ђ�A�Ђ�
 f: ��
 j: ��A��A��
 N: ��
 . : �q���Ȃ��i���A���A���A���A���j

* �ua�v, �ui�v, �uu�v,�ue�v, �uo�v �ȍ~
 a/i/u/e/o : �ꉹ�����ɂ��A���A���A���A�����܂�
  �i�X�y�[�X�j: �ꉹ�Ȃ��i��j

�{���A�um�v����u.�v�܂łƁA�ua�v����u �i�X�y�[�X�j�v�܂ł̕����͂��ꂼ��
�ʂ̃t�@�C���ɂ��ׂ��ł��邪�A�t�@�C�������c��ɂȂ��Č���̂���ςȂ��߁A
����͓���ɂ��Ă���B

�܂��A�����͍���̕]���ł͖������Ă���B
