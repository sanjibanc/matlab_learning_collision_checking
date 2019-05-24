%%
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_WALL_WITH_GAPS
% Make a wall with a gap
clc;
clear;
close all;

%% Create two rectangles
scenario = 1;
switch scenario
    case 1
        bbox = [0 1 0 1]; %unit bounding box
        rectangle_array = get_wall_baffle( bbox, 0.3, 0.6, 0.1, 0.1, 0.15);
end


%% Visualize
figure;
visualize_shapes(rectangle_array);
axis(bbox)