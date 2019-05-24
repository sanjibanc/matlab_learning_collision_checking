%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function rectangle_array = get_wall_with_shifting_gaps( bbox, x, width, gap_height, gap_bounds  )
%GET_WALL_WITH_SHIFTING_GAP Creates a wall with uniform gaps
%   bbox: bbox of the environment
%   x: x coordinate of lower corner
%   width: width of the gap
%   gap_height: height of the gaps 
%   gap_bounds: 1x2 vector of [ymin ymax] of gap centre

rectangle_array = [];
x_lb = x - width*0.5;
y_gap = gap_bounds(1) + rand()*(gap_bounds(2)-gap_bounds(1));
rectangle_array = [rectangle_array get_rectangle_shape(x_lb, bbox(3), width, y_gap - 0.5*gap_height )];
rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_gap + 0.5*gap_height, width, bbox(4) - (y_gap + 0.5*gap_height) )];

end

