function myprint(fname, type_flag)

if nargin<2,
    type_flag = 0; % META and EPS
end

if type_flag ==1 , % EMF
    print(fname, '-dmeta')
elseif type_flag == 2, % EPS
    print(fname, '-depsc2')
else                % BOTH
    print(fname, '-dmeta')
    print(fname, '-depsc2')
end                                                   