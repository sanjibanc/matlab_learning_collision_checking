%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_DRAW_RECTANGLE_SHAPES
% Example to draw rectangles to create shapes
clc;
clear;
close all;
%% Create drawing platforn 
bbox = [-1 1 -1 1];

figure;
axis(bbox);
grid on;
count = 1;
while(1)
    title('Drag rect');
    final_rect = getrect(gca);
    rectangle('Position',final_rect,'FaceColor','k');
    shape_array(count) = get_rectangle_shape(final_rect(1), final_rect(2), final_rect(3), final_rect(4));
    
    clf;
    visualize_shapes(shape_array);
    axis(bbox)
    grid on;
    
    count = count + 1;
    title('Left click to continue, right click to stop');
    [~,~,button] = ginput(1);
    if (button == 3)
        break;
    end
end
