%%
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_RECTANGLE_BUG_TRAP
% Make a wall with a gap
clc;
clear;
close all;

%% Create two rectangles
scenario = 2;
switch scenario
    case 1
        bbox = [0 1 0 1]; %unit bounding box
        rectangle_array = get_rectangle_bugtrap( 0.5, 0.5, 1, 0.05, 0.4, 0.3);
    case 2
        bbox = [0 1 0 1]; %unit bounding box
        rectangle_array = get_rectangle_bugtrap( 0.5, 0.5, 2, 0.05, 0.4, 0.3);
end


%% Visualize
figure;
visualize_shapes(rectangle_array);
axis(bbox)