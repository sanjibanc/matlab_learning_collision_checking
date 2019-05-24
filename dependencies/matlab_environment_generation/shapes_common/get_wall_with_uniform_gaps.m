%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function rectangle_array = get_wall_with_uniform_gaps( bbox, x, width, gap_height, gap_config  )
%GET_WALL_WITH_UNIFORM_GAP Creates a wall with uniform gaps
%   bbox: bbox of the environment
%   x: x coordinate of lower corner
%   width: width of the gap
%   gap_height: height of the gaps 
%   gap_config: a vector of 0s (no gap) and 1s (gap) showing a gap config

rectangle_array = [];
num_block = length(gap_config)+1;
block_height = ((bbox(4) - bbox(3)) - length(gap_config)*gap_height)/num_block;

for i = 1:num_block
    x_lb = x - width*0.5;
    y_lb = bbox(3) + (i-1)*(block_height+gap_height);
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, width, block_height)];
end

for i = 1:length(gap_config)
    x_lb = x - width*0.5;
    y_lb = bbox(3) + (i-1)*(block_height+gap_height) + block_height;
    if (gap_config(i)==0)
        rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, width, gap_height)];
    end
end

end

