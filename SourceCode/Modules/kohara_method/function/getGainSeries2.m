function [gainS_rev, gainS ] = getGainSeries2(gainM,T,flag)
%GETGAINSERIES 

if nargin <3,
    flag = 0;
end
gainS = cell(T,1);
gainS_rev = cell(T,1);
shift = fix( size(gainM,1)/T );
st = 1;
for i = 1:T,
    gainS{i} = gainM(st:st+shift , :);
    st = st+shift;
end

if flag ==1,
    for k = 1:T,
        gainS_rev{k} = gainS{T+1-k};
    end
end
end

