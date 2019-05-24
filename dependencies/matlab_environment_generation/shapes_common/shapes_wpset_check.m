%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ in_collision ] = shapes_wpset_check( wpset, shape_array )
%SHAPES_WPSET_CHECK Checks whether wpset is inside an array of shapes
%   wpset: Nxd coordinates for wp trajectory
%   shape_array: array of shapes
%   in_collision: 0 if point is not in shape, 1 if it is in the shape

for i = 1:size(wpset, 1)
    pt = wpset(i, :);
    if(shapes_point_check( pt, shape_array ))
        in_collision = 1;
        return;
    end
end

in_collision = 0;

end

