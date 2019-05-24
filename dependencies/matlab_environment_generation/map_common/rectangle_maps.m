%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ map ] = rectangle_maps( bbox, rectangle_array, resolution)
%RECTANGLE_MAPS Creates a map structure from the analytic rectangle
%primitives.
%   bbox - the bounding box of the environment [xmin xmax ymin ymax]
%   rectangle_array - a 1xN structure array of low(1x2) and
%   high(1x2) (sorry we cant accept rotated rectangles!)
%   resolution - 1 pix = resolution units of distance
%   map - see defined structure


map = get_initialized_map(bbox, resolution);

for i = 1:length(rectangle_array)
    [row1, col1] = world_to_grid(rectangle_array(i).low(1), rectangle_array(i).low(2), map);
    [row2, col2] = world_to_grid(rectangle_array(i).high(1), rectangle_array(i).high(2), map);
    row1 = min(size(map.table,1), max(1, row1));
    row2 = min(size(map.table,1), max(1, row2));
    col1 = min(size(map.table,2), max(1, col1));
    col2 = min(size(map.table,2), max(1, col2));
    map.table(row1:row2, col1:col2) = 0;
end

end

