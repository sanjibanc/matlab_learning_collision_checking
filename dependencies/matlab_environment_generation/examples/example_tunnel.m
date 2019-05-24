%%
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_TUNNEL
% Make a left to right tunnel
clc;
clear;
close all;

%% Create two rectangles
scenario = 2;
switch scenario
    case 1
        bbox = [0 1 0 1]; %unit bounding box
        vertical_disp = [0.4 0.7 0.2 0.5 1.0];
        wall_width = 0.02;
        gap_clearance = 0.1;
        rectangle_array = get_left_right_tunnel( bbox, vertical_disp, wall_width, gap_clearance);
    case 2
        rng(5);
        bbox = [0 1 0 1]; %unit bounding box
        wall_width = 0.02;
        gap_clearance = 0.1;
        while true
            vertical_disp = transpose(cumsum(randfixedsum(5,1,1.0,-0.5,0.5)));
            if(is_valid_left_right_tunnel( vertical_disp, bbox, gap_clearance))
                break;
            end
        end
        rectangle_array = get_left_right_tunnel( bbox, vertical_disp, wall_width, gap_clearance);
end


%% Visualize
figure;
visualize_shapes(rectangle_array);
axis(bbox)