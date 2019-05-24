%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function rectangle_array = get_left_right_tunnel( bbox, vertical_disp, wall_width, gap_clearance)
%GET_WALL_WITH_UNIFORM_GAP Creates a wall with uniform gaps

rectangle_array = [];

for i = 1:(length(vertical_disp)-1)
    x_com = bbox(1) + i*(bbox(2)-bbox(1))/length(vertical_disp);
    rectangle_array = [rectangle_array get_rectangle_shape(x_com - 0.5*wall_width, 0, wall_width, vertical_disp(i) - 0.5*gap_clearance)];
    rectangle_array = [rectangle_array get_rectangle_shape(x_com - 0.5*wall_width, vertical_disp(i) + 0.5*gap_clearance, wall_width, 1.0 - (vertical_disp(i) + 0.5*gap_clearance))];
end

dir = [1 diff(vertical_disp) > 0];
for i = 1:(length(vertical_disp)-1)
    x_com = bbox(1) + (i-1)*(bbox(2)-bbox(1))/length(vertical_disp);
    if (dir(i) == 1)
        rectangle_array = [rectangle_array get_rectangle_shape(x_com, vertical_disp(i) + 0.5*gap_clearance, (bbox(2)-bbox(1))/length(vertical_disp), wall_width)];
    else
        rectangle_array = [rectangle_array get_rectangle_shape(x_com, vertical_disp(i) - 0.5*gap_clearance - wall_width, (bbox(2)-bbox(1))/length(vertical_disp), wall_width)];
    end
    x_com = bbox(1) + (i)*(bbox(2)-bbox(1))/length(vertical_disp);
    if (dir(i+1) == 0)
        rectangle_array = [rectangle_array get_rectangle_shape(x_com, vertical_disp(i) + 0.5*gap_clearance, (bbox(2)-bbox(1))/length(vertical_disp), wall_width)];
    else
        rectangle_array = [rectangle_array get_rectangle_shape(x_com, vertical_disp(i) - 0.5*gap_clearance - wall_width, (bbox(2)-bbox(1))/length(vertical_disp), wall_width)];
    end
end

end

