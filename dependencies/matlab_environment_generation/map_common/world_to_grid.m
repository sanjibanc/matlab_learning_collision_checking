%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ r, c ] = world_to_grid( x_world, y_world, map )
%WORLD_TO_GRID Convert a world coordinate to grid coordinate
%   x_world: x coordinate
%   y_world: y coordinate
%   map: map struct
%   r: row
%   c: columan

r = 1+round((x_world - map.origin(1))/map.resolution);
c = 1+round((y_world - map.origin(2))/map.resolution);

end

