%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_CHECK_SHAPE_LINE_COLLISION
%Check line in shape
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
    [x, y] = ginput(2);
    plot(x, y, 'b');
    collision = shapes_coll_line_check( [x(1) y(1)], [x(2) y(2)], shapes_array );
    if (collision)
        title('Collision!! Hit return to continue');
    else
        title('Free!! Hit return to continue');
    end
    pause;
    clf;
    hold on;
    visualize_shapes(shapes_array);
    axis(bbox)
    grid on;
end
