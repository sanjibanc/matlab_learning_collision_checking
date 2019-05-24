%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function rectangle_array = get_rectangle_bugtrap( x, y, orient, wall_width, back_length, side_length)
%GET_WALL_WITH_SHIFTING_GAP Creates a wall with uniform gaps
%   x: x coordinate of middle 
%   y: y coordinate of middle 
%   orient: 1 vertical, 2 horizontal
%   wall_width: width of trap wall
%   back_length: length of back wall
%   side_length: length of side wall

rectangle_array = [];

if (orient == 1)
    x_lb = x + side_length*0.5 - wall_width;
    y_lb = y - back_length*0.5 - wall_width;
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, wall_width, 2*wall_width + back_length )];
    
    x_lb = x - side_length*0.5;
    y_lb = y - back_length*0.5 - wall_width;
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, side_length, wall_width)];
    
    x_lb = x - side_length*0.5;
    y_lb = y + back_length*0.5;
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, side_length, wall_width)];
elseif (orient == 2)
    x_lb = x - back_length*0.5 - wall_width;
    y_lb = y + side_length*0.5;
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, 2*wall_width + back_length, wall_width )];
    
    x_lb = x - back_length*0.5 - wall_width;
    y_lb = y - side_length*0.5;
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, wall_width, side_length)];
    
    x_lb = x + back_length*0.5;
    y_lb = y - side_length*0.5;
    rectangle_array = [rectangle_array get_rectangle_shape(x_lb, y_lb, wall_width, side_length)];
end
    
end

