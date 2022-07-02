%% make 3 dimension graph plot
xIndex = -8 : 0.5 : 8;  % x index array (same y index array)
yIndex = xIndex;    % y index array (same x index array)
[x, y] = meshgrid(xIndex, yIndex);  % make lattice point
r = sqrt(x .^ 2 + y .^ 2);  % calculate radius
z = sin(r) ./ r;    % normalize
surf(x, y, z);  % plot 3 dimension graph