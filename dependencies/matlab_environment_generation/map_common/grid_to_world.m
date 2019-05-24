%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ x_world, y_world ] = grid_to_world( r, c, map )
%WORLD_TO_GRID Convert a world coordinate to grid coordinate
%   x_world: x coordinate
%   y_world: y coordinate
%   map: map struct
%   r: row
%   c: column
x_world = (r - 1)*map.resolution + map.origin(1);
y_world = (c - 1)*map.resolution + map.origin(2);

end

