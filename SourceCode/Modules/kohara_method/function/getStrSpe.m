function [n3sgram,  f0raw, ap] = getStrSpe( x, fs )
%GETSTRSPE ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q
[f0raw, ap] = exstraightsource(x, fs);

[n3sgram] = exstraightspec(x, f0raw, fs);

end

