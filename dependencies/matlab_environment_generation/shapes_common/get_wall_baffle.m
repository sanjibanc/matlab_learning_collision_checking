%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function rectangle_array = get_wall_baffle( bbox, x, y, wall_width, gap_width, gap_height)
%GET_WALL_BAFFLE Creates a wall with gaps
%   bbox: bbox of the environment
%   x: x coordinate of COM
%   y: y coordinate of COM
%   wall_width: width of wall
%   gap_width: width of gap
%   gap_height: height of gap

rectangle_array = [];
rectangle_array = [rectangle_array get_rectangle_shape(x - gap_width*0.5 - wall_width, bbox(3), wall_width, y + 0.5*gap_height)];
rectangle_array = [rectangle_array get_rectangle_shape(x + gap_width*0.5 , y - 0.5*gap_height, wall_width, bbox(4))];

end

