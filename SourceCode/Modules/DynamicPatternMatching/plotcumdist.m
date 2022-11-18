function plotcumdist(g, map, shiftm)

if nargin < 3,
  shiftm = 8;
end

imagesc((0:(size(g,1)-1))*shiftm, (0:(size(g,2)-1))*shiftm, min(g', 100)); axis xy; hold on;

if nargin >= 2,
  plot((0:(length(map)-1))*shiftm, (map-1)*shiftm, 'w', 'LineWidth', 2);
end

xlabel('Test time [ms]'); ylabel('Reference time [ms]');
