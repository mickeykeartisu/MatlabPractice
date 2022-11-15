close all;
clear all;

% dpSetDefaultTypicalConstraint(0);

xlen = 256; ylen = 256;
fx = 100; fy = 110;
xdelay = 5; ydelay = 0;
x = [zeros(1, xdelay) sin(2 * pi * fx * (0:(xlen-1)) / xlen)];
y = [zeros(1, ydelay) sin(2 * pi * fy * (0:(ylen-1)) / ylen)];

[dist, map, g, accurate_dist] = dpMatch(x, y, 10, 50, 0.6);
%[dist, map, g] = dpMatch(x, y, 0, 0, 0.6);

dist
accurate_dist

imagesc(min(g', 100)); axis xy; hold on;
plot(map, 'w', 'LineWidth', 2);

figure;
plot(1:length(map), x(1:length(map)), 1:length(map), y(map));
