function [ X_cut, cut_info ] = cut_wav( X, fs, thre_v, thre_v2, thre_l, edge_l, speech_l, s_p, e_p )
%CUT_WAV ���͉�����P�ꂲ�Ƃɕ�������֐�
%   X:���͐M��
%   fs:�T���v�����O���g��
%   thre_v:������Ԕ���p臒l
%   thre_v2:������Ԕ���p臒l�i��{�I�ɂ�thre_v�Ɠ����l��OK�j
%   thre_l:������Ԕ����Ԃ̒����i�~���b�j
%   edge_l:�؂����������̒[�̒���
%   speech_l:�؂�������Ԃ��特���̋�Ԃ��������o���ۂ�臒l
%   s_p:���͉����̕����J�n�|�C���g�i���̈����͖����Ă�OK�j
%   e_p:���͉����̕����I���|�C���g�i���̈����͖����Ă�OK�j


if nargin < 8
    s_p = 1;
    e_p = length(X);
end
X = X(s_p:e_p);

thre_p = fs/1000*thre_l;

edge_p = fs/1000*edge_l;
speech_p = fs/1000*speech_l;


% keyboard
c_s = zeros(1,100);
c_e = zeros(1,100);
cut_info = zeros(10,2);
count = 1;
% count_2;
% p_memo == p+thre_l-1 || 
% X = X(1495671:2408470);

Xabs =  abs(X);
p = 1;
% for p = 1:length(X),
while 1,
    if thre_v > Xabs(p) %臒l�ȉ�������
        if p+thre_p-1 < length(X),%�����̒����𒴂��ĂȂ��Ƃ�
            disc = mean(Xabs(p:p+thre_p-1));
        else%�����̒����𒴂����ꍇ
            disc = mean(Xabs(p:end));
        end
        if thre_v > disc, %���݂̃|�C���g����w��̋�Ԃ̕��ς̐U����臒l�ȉ��������ꍇ          
           c_s(count) = p;
           p_memo = p;
%            keyboard
            while 1,
                if (thre_v2 < Xabs(p_memo) && thre_v2 < Xabs(p_memo+1)) || p_memo == length(X),
                    c_e(count) = p_memo;
                    count = count + 1;
                    break
                else
                    p_memo = p_memo + 1;
                end
                
            end
            p = p_memo;
        end
    end  
    
    if p == length(X),
        break
    else
        p = p+1;
    end
end

count = 1;
for n = 1:length(c_s)-1,
    if c_s(n+1)-c_e(n) >= speech_p,
%         figure
%         plot(X(c_e(n)-edge_l:c_s(n+1)+edge_l))
%         soundsc(X(c_e(n)-edge_l:c_s(n+1)+edge_l),fs)
        cut_info(count,1) = c_e(n)-edge_p/2;
        cut_info(count,2) = c_s(n+1)+edge_p;
%         keyboard
        count = count + 1; 
    end
end

X_cut = cell(1,size(cut_info,1));
for n = 1:size(cut_info,1),
    X_cut{n} = X(cut_info(n,1):cut_info(n,2));
%     if n == 50,
%         X_cut{n} = X(cut_info(n,1):cut_info(n,2)+edge_p);
%     end
end

end

