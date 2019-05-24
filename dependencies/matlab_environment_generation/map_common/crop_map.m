%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ cropped_map ] = crop_map( map, bbox_xy )
%CROP_MAP Crop a map
%   map: input map
%   bbox_xy: bounding box to crop to

cropped_map = map;
cropped_map.origin = [bbox_xy(1) bbox_xy(3)];
[row1, col1] = world_to_grid(bbox_xy(1), bbox_xy(3), map);
[row2, col2] = world_to_grid(bbox_xy(2), bbox_xy(4), map);
row1 = min(size(map.table,1), max(1, row1));
row2 = min(size(map.table,1), max(1, row2));
col1 = min(size(map.table,2), max(1, col1));
col2 = min(size(map.table,2), max(1, col2));
cropped_map.table = map.table(row1:row2, col1:col2);
[ x_world, y_world ] = grid_to_world( row1, col1, map );
cropped_map.origin = [x_world y_world];

end

