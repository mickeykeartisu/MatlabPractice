function [dist, map, g, accurate_dist] = dpMatchConstraint(constraint, xmat, ymat, ...
                                                  start_free_nframe, end_free_nframe, ...
                                                  limit_factor, ...	% factor for DP slope limit (0.0 < factor < 1.0)
                                                  dist_func)
%
%[DIST, MAP, G, ACCURATE_DIST] = DPMATCHCONSTRAINT(CONSTRAINT, XMAT, YMAT, ...
% 				                   START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR)
%[DIST, MAP, G, ACCURATE_DIST] = DPMATCHCONSTRAINT(CONSTRAINT, XMAT, YMAT, ...
% 				                   START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR, DIST_FUNC)
%
% XMAT, YMAT: input matrices whose columns are feacher vectors
% CONSTRAINT: constraint matrix
% START_FREE_NFRAME: number of frames for start point free  (0: disable this option)
% END_FREE_NFRAME: number of frames for end point free  (0: disable this option)
% LIMIT_FACTOR: factor for DP slope limit (0.0 < factor <= 1.0)  (1.0: no limit, 0.0: use default value)
% DIST_FUNC: function to calculate distortion. function must be in the form `func(xvec, yvec)'
% DIST: cumulative distance
% MAP: vector including path information. This vector indicates the path mapping from
%      XMAT's time axis to YMAT's time axis. The length of the vector is basically same as the number of columns of XMAT
%      except that the end point free function is valid.
% G: cumulative distance matrix. The size is the number of columns of XMAT by the number of columns of YMAT.
% ACCURATE_DIST: accurate cumulative distance
%
% CONSTRAINT = [ IS_FIRST_NODE  X_DIFF  Y_DIFF  WEIGHT ;
% 	                     :     ]
% IS_FIRST_NODE: 1=first node, 0=not first node
% X_DIFF: difference between nodes for x axis
% Y_DIFF: difference between nodes for y axis
% WEIGHT: weight for path between nodes

if nargin < 9
  dist_func = 'dpEuclid';
end

dpSetGlobalValue;

x_nframe = size(xmat, 2);
y_nframe = size(ymat, 2);

r = dpGetWindowConstant(x_nframe, y_nframe, limit_factor);

d = dpGetFuncDist(xmat, ymat, r, dist_func);	 
[dist, map, g, accurate_dist] = dpCalcCumDist(constraint, x_nframe, y_nframe, d, r, start_free_nframe, end_free_nframe);

return;

%
%
%
function r = dpGetWindowConstant(nx, ny, limit_factor)

global DP_PATH_LIMIT_FACTOR;

if (limit_factor <= 0.0) | (limit_factor > 1.0)
  limit_factor = DP_PATH_LIMIT_FACTOR;
end

% window constant 
if nx <= ny
  r = ny - nx + round(nx * limit_factor);
else
  r = nx - ny + round(ny * limit_factor);
end

return;


%
% dpSetGlobalValue  (private function)
%
function dpSetGlobalValue()

global DP_MAX_DIST DP_PATH_LIMIT_FACTOR;

DP_MAX_DIST = 1000000000000.0;
DP_PATH_LIMIT_FACTOR = 0.3; % 30 %

return;

%
% private function
%
function num_branch = dpGetConstraintNumBranch(constraint)

num_branch = 0;
for ii = 1:size(constraint, 1),
  if constraint(ii, 1)
    num_branch = num_branch + 1;
  end
end

return;

%
% private function
%
function flag = dpIsConstraintRowLeafNode(constraint, row)

flag = 0;
if (row == size(constraint, 1)) | constraint(row + 1, 1)
  flag = 1;
end

return;

%
%
%
function row = dpGetConstraintBranchRow(constraint, branch_index)

row = 0;
num_branch = 0;
for ii = 1:size(constraint, 1),
  if constraint(ii, 1)
    num_branch = num_branch + 1;
    if branch_index == num_branch
      row = ii;
      break;
    end
  end
end

return;

%
%
%
function dist = dpEuclid(xvec, yvec)

order = min(length(xvec), length(yvec));
%dist = sum((xvec(1:order) - yvec(1:order)).^2);
dist = sqrt(sum((xvec(1:order) - yvec(1:order)).^2));

return;

%
%
%
function d = dpGetFuncDist(xmat, ymat, window_size, dist_func)

global DP_MAX_DIST;

if nargin < 4
  dist_func = 'dpEuclid';
end

max_dist = DP_MAX_DIST;

x_nframe = size(xmat, 2);
y_nframe = size(ymat, 2);

d = zeros(x_nframe+1, y_nframe+1);

flag = 0;

for x=1:x_nframe,
  for y=1:y_nframe,
    if ((x <= y + window_size) & (x >= y - window_size))
      xvec = xmat(:, x);
      yvec = ymat(:, y);
      current_dist = feval(dist_func, xvec, yvec);
    else
      current_dist = max_dist;
    end
    d(x+1, y+1) = current_dist;
  end
  % debugmessage(0, 'dpGetFuncDist', [num2str(x) ' / ' num2str(x_nframe)]);
end

for x=1:x_nframe,
  d(x + 1, 1) = max_dist;
end
for y=1:y_nframe,
  d(1, y + 1) = max_dist;
end

% keyboard

return;

%
%
%
function [min_index, min_value] = dpFindMinBranch(constraint, x, y, d, g)

global DP_MAX_DIST;

min_index = 1;
min_value = DP_MAX_DIST;
constraint_row = 1;

for ii = 1:dpGetConstraintNumBranch(constraint),
  xoffset = 0;
  yoffset = 0;
  dist = 0.0;

  constraint_row = dpGetConstraintBranchRow(constraint, ii);
  
  jj = 1;
  while 1,
    if (x + xoffset < 0) | (y + yoffset < 0)
      dist = DP_MAX_DIST;
      break;
    elseif (constraint_row <= 0) | (constraint_row > size(constraint, 1)) ...
	| (jj > 1 & constraint(constraint_row, 1))
      dist = dist + g(x + 1 + xoffset, y + 1 + yoffset);
      break;
    end
    weight = constraint(constraint_row, 4);
    dx = constraint(constraint_row, 2);
    dy = constraint(constraint_row, 3);
    dist = dist + weight * d(x + 1 + xoffset, y + 1 + yoffset);
    
    xoffset = xoffset + dx;
    yoffset = yoffset + dy;
    
    constraint_row = constraint_row + 1;
    jj = jj + 1;
  end
  
  if dist < min_value
    % debugmessage(-1, 'dpFindMinBranch', ['min_value updated: dist = ' num2str(dist) ', min_value = ' num2str(min_value)]);
    min_index = ii;
    min_value = dist;
  end
end

% debugmessage(-1, 'dpFindMinBranch', ['(x, y) = (' num2str(x) ', ' num2str(y) '), min_index = ' num2str(min_index)]);
% debugmessage(-1, 'dpFindMinBranch', ['min_value = ' num2str(min_value)]);

return;

%
%
%
function [map, accurate_cum_dist] = dpFindMap(constraint, nx, ny, d, min_node_index)

match = zeros(nx + ny + 2, 2);

x = nx; y = ny;
match(1, 1) = x;
match(1, 2) = y;

map = [];

accurate_cum_dist = 0.0;

k = 2;
while (x > 1 & y > 1),
  constraint_row = dpGetConstraintBranchRow(constraint, min_node_index(x, y));
  while 1,
    x = x + constraint(constraint_row, 2);
    y = y + constraint(constraint_row, 3);
    weight = constraint(constraint_row, 4);
    
    match(k, 1) = x;
    match(k, 2) = y;
    
    accurate_cum_dist = accurate_cum_dist + weight * d(x + 1, y + 1);
    
    k = k + 1;
    
    if dpIsConstraintRowLeafNode(constraint, constraint_row)
      break;
    end
    constraint_row = constraint_row + 1;
  end
end

accurate_cum_dist = accurate_cum_dist / (nx - x + 1 + ny - y + 1);

matchlen = k - 1;

% keyboard

x2 = 1;
y2 = 1;
map(1, 1) = 1;
for ii = 1:matchlen,
  x = match(matchlen + 1 - ii, 1);
  y = match(matchlen + 1 - ii, 2);
  
  if ii == 1 | x ~= x2
    map(1, (x2 + 1):(x - 1)) = y2;
    map(1, max(x,1)) = y;
  else
    if d(x + 1, y + 1) > d(x + 1, y2 + 1)
      map(1, x) = y2;
    else
      map(1, x) = y;
    end
  end
  x2 = x;
  y2 = y;
end

return;

%
%
%
function [cum_dist, map, g, accurate_cum_dist] = dpCalcCumDist(constraint, nx, ny, d, window_size, start_free_nframe, end_free_nframe)

global DP_MAX_DIST;

end_point_free = 1;
cum_dist = -1.0;

g = DP_MAX_DIST * ones(nx + 1, ny + 1);
min_node_index = ones(nx, ny);

%g(1, 1) = 0.0; % setting to 0 is BUG
g(2, 2) = 2 * d(2, 2);

% calculation for start and end points free
for y = 2:min(start_free_nframe + 1, ny),
  g(2, y + 1) = (1 + y) * d(2, y + 1);
end
for x = 2:min(start_free_nframe + 1, nx),
  g(x + 1, 2) = (1 + x) * d(x + 1, 2);
end

for y = 2:ny,
  % tic
  xcalc = 0;
  for x = 2:nx,
    if ((y <= x + window_size) & (y >= x - window_size))
      [min_index, min_value] = dpFindMinBranch(constraint, x, y, d, g);
      min_node_index(x, y) = min_index;
      g(x + 1, y + 1) = min_value;
      xcalc = xcalc + 1;
    else
      g(x + 1, y + 1) = DP_MAX_DIST;
      min_node_index(x, y) = 1;
    end
  end
  % debugmessage(0, 'dpCalcCumDist', [num2str(y) ' / ' num2str(ny) ', xcalc = ' num2str(xcalc)]);
  % toc
end

% keyboard

if end_point_free
  min_value = g(nx + 1, ny + 1) / (nx + ny);
  min_nx = nx;
  min_ny = ny;

  for y = max(ny - end_free_nframe, 2):(ny - 1),
    value = g(nx + 1, y + 1) / (nx + y);
    if value < min_value
      min_value = value;
      min_nx = nx;
      min_ny = y;
    end
  end
  for x = max(nx - end_free_nframe, 2):(nx - 1),
    value = g(x + 1, ny + 1) / (x + ny);
    if value < min_value
      min_value = value;
      min_nx = x;
      min_ny = ny;
    end
  end

  nx = min_nx;
  ny = min_ny;
  cum_dist = min_value;
else
  cum_dist = g(nx + 1, ny + 1) / (nx + ny);
end

if nargout >= 2
  [map, accurate_cum_dist] = dpFindMap(constraint, nx, ny, d, min_node_index);
end

% keyboard

return;
