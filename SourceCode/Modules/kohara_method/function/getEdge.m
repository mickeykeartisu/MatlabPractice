function [d2, d1] = getEdge(x, c0_flag,f2)
% function [d2, d1] = getEdge(x, c0_flag)
% c0_flav_v = [-1 0 1 2];
% c0_str = {'minusc0', 'equalc0', 'plusc0', 'onlyc0'};



if nargin < 2,
    c0_flag=0;
end

% ”÷•ªƒtƒBƒ‹ƒ^
f1 = [
    %     0, 0, 0;
    -1, 0, 1;
    %     0, 0, 0
    ];
if nargin < 3,
    f2 = [
    %     0, 0, 0;
    -1, 2, -1;
    %     0, 0, 0
    ];
end

% f2 = [
%     %     0, 0, 0;
%     -1, 4, -1;
%     %     0, 0, 0
%     ];


d1 = filter2(f1, x, 'same');
d1(:,1) = d1(:,2);
d1(:,end) = d1(:,end-1);

d2 = filter2(f2, x, 'same');
d2(:,1) = d2(:,2);
d2(:,end) = d2(:,end-1);

if c0_flag==0,
    d1(1,:) = 0;
    d2(1,:) = 0;
elseif c0_flag==-1,
    d1(1,:) = -d1(1,:);
    d2(1,:) = -d2(1,:);
elseif c0_flag==2,
    d1(2:end,:) = 0;
    d2(2:end,:) = 0;
elseif c0_flag==3,
    d1(2:end,:) = 0;
    d2(2:end,:) = 0;
    d1(1,:) = -d1(1,:);
    d2(1,:) = -d2(1,:);
end
