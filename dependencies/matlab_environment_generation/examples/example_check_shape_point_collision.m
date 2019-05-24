%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_CHECK_SHAPE_POINT_COLLISION
% Check point in shape
clc;
clear;
close all;

%% Create two rectangles
bbox = [0 1 0 1]; %unit bounding box
% rectangle 1
shapes_array(1) = get_rectangle_shape(0.2,0.2,0.2,0.4);
% rectangle 2
shapes_array(2) = get_rectangle_shape(0.6,0.5,0.2,0.4);

%% Interactive point checking
figure;
visualize_shapes(shapes_array);
axis(bbox)
grid on;

while(1)
    [x, y] = ginput(1);
    scatter(x, y, 5, [0 0 1]);
    [collision, d, grad] = shapes_point_check( [x y], shapes_array );
    str = sprintf('Distance is %f , Grad is %f %f Hit return to continue', d, grad(1), grad(2));
    title(str);
    pause;
    clf;
    hold on;
    visualize_shapes(shapes_array);
    axis(bbox)
    grid on;
end
