%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function map = convert_rectangle_shape_array_to_map( shapes_array, bbox, resolution )
%CONVERT_RECTANGLE_SHAPE_ARRAY_TO_MAP Converts rectangle shape array to a map struct
%   shapes_array: an array of shape struct of rectangles
%   bbox: the bounding box
%   resolution: the resolution of the map

for count = 1:length(shapes_array)
    rectangle_array(count).low = shapes_array(count).data(1:2);
    rectangle_array(count).high = shapes_array(count).data(1:2) + shapes_array(count).data(3:4);
end

map = rectangle_maps( bbox, rectangle_array, resolution);

end

