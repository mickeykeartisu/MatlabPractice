function [ X_Int ] = LinearInt( X, Y )
%LINEARINT ���`��Ԃ��s���֐�
% X:���`��Ԃ��s���n�� Y:�ڕW�̌n��

xq = 1:(length(X)/length(Y)):length(X);
X_Int = interp1(1:length(X), X, xq); %���`���
temp = ones(1,length(Y)-length(X_Int)); %�ڕW�̌n��Ƃ̃|�C���g���̍�����1�̌n����쐬
X_Int = cat(2,X_Int,temp); %���`��Ԃ����n��̖����ɑ���Ȃ�������1��ǉ�
end

