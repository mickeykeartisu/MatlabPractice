function [mat] = trunc2(mat, leng, dim, pos, pad, inum)
% [mat] = trunc2(mat, leng, dim, pos, pad, inum)
% mat   : Matrix
% leng  : truncation length
% dim   : truncation dimension.
% pos   : truncation position. 'both'(default), 'before', 'after'
% pad   : padding flag 0(truncation), 1(padding)
% inum  : initial value(padding)

if nargin < 4,
    strnum = 0;
else
    str = {'before', 'after'};
    strnum = find(strcmp(str, pos));
end

if nargin < 5,
    pad = 0;
end

if ~pad,
    % truncate before position
    if strnum==1,
        if dim==1,
            mat(1:leng, :) = [];
        else
            mat(:, 1:leng) = [];
        end
        % truncate after position
    elseif strnum==2,
        if dim==1,
            mat(end-leng+1:end, :) = [];
        else
            mat(:, end-leng+1:end) = [];
        end
        % truncate both position
    else
        if dim==1,
            mat(1:leng, :) = [];
            mat(end-leng+1:end, :) = [];
        else
            mat(:, 1:leng) = [];
            mat(:, end-leng+1:end) = [];
        end
    end
    
    %%%%%%%%%%%%%%%% PADDING %%%%%%%%%%%%%%%%
    %  before position
else
    if nargin < 6,
        inum = 0;
    end
    
    if strnum==1,
        if dim==1,
            mat = [inum * ones(leng, size(mat,2)); mat];
        else
            mat = [inum * ones(size(mat,1), leng) mat];
        end
        %  after position
    elseif strnum==2,
        if dim==1,
            mat = [mat; inum * ones(leng, size(mat,2))];
        else
            mat = [mat inum * ones(size(mat,1), leng) mat];
        end
        %  both position
    else
        if dim==1,
            mat = [inum * ones(leng, size(mat,2)); mat; inum * ones(leng, size(mat,2))];
        else
            mat = [inum * ones(size(mat,1), leng) mat inum * ones(size(mat,1), leng) ];
        end
    end
    
end


