function [dist, map, g, accurate_dist] = dpMatch(xmat, ymat, ...
                                                 start_free_nframe, end_free_nframe, ...
                                                 limit_factor, ...	        % factor for DP slope limit (0.0 < factor < 1.0)
                                                 dist_func)
%
%[DIST, MAP, G, ACCURATE_DIST] = DPMATCH(XMAT, YMAT, START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR)
%[DIST, MAP, G, ACCURATE_DIST] = DPMATCH(XMAT, YMAT, START_FREE_NFRAME, END_FREE_NFRAME, LIMIT_FACTOR, DIST_FUNC)
% 
% XMAT, YMAT: input matrices whose columns are feacher vectors
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
				    
if nargin < 8,
  dist_func = 'dpEuclid';
end

if isempty(strmatch('DP_DEFAULT_TYPICAL_CONSTRAINT', who('global'))),
  global DP_DEFAULT_TYPICAL_CONSTRAINT;
  DP_DEFAULT_TYPICAL_CONSTRAINT = 1;
else
  global DP_DEFAULT_TYPICAL_CONSTRAINT;
end

constraint = dpCreateTypicalConstraint(DP_DEFAULT_TYPICAL_CONSTRAINT);

[dist, map, g, accurate_dist] = dpMatchConstraint(constraint, xmat, ymat, ...
                                                  start_free_nframe, end_free_nframe, ...
                                                  limit_factor, dist_func);
				  
return;

%
%
%
function constraint = dpCreateTypicalConstraint(type)

if type == 0,
%      o--o
%    /  / |
%   o  o  o
%        /
%      o
  constraint = [ 1 -1  0  1;
                 0 -1 -1  2;
		 1 -1 -1  2;
		 1  0 -1  1;
		 0 -1 -1  2];
elseif type == 1,
%        o-----o
%     / /  /  /
%   o    o  
%    /     /
%   o    o
  constraint = [ 1 -1 -2  1;
                 1 -1 -1  1;
		 1 -1  0  1;
		 0 -1 -2  1;
		 1 -1  0  1;
		 0 -1 -1  1];
else
  error(['constraint type ' num2str(type) ' is not supported.']);
end

return;

