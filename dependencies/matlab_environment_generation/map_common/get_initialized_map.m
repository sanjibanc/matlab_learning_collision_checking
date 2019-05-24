%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function map = get_initialized_map( bbox, resolution )
%GET_INITIALIZED_MAP Get an initialized map where all values are 1
%   bbox: 1x4 bounding box [xmin xmax ymin ymax]
%   resolution: map resolution
%   map: map struct

map = get_blank_map();
map.resolution = resolution;
map.origin = [bbox(1) bbox(3)];
[row, col] = world_to_grid(bbox(2), bbox(4), map);
map.table = ones(row, col);

end

