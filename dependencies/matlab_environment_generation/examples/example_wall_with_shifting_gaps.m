%%
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_WALL_WITH_SHIFTING_GAPS
% Make a wall with a gaps randomly shifting
clc;
clear;
close all;

%% Create two rectangles
scenario = 2;
switch scenario
    case 1
        bbox = [0 1 0 1]; %unit bounding box
        rectangle_array = get_wall_with_shifting_gaps( bbox, 0.4, 0.2, 0.1, [0.7 0.9] );
    case 2
        bbox = [0 1 0 1]; %unit bounding box
        rectangle_array1 = get_wall_with_shifting_gaps( bbox, 0.3, 0.2, 0.1, [0.7 0.9] );
        rectangle_array2 = get_wall_with_shifting_gaps( bbox, 0.7, 0.2, 0.1, [0.1 0.3] );
        rectangle_array = [rectangle_array1 rectangle_array2];
end


%% Visualize
figure;
visualize_shapes(rectangle_array);
axis(bbox)