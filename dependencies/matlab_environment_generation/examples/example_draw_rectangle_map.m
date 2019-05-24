%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_DRAW_RECTANGLE_MAP
% Example to draw rectangles to create a map
clc;
clear;
close all;

%% Create drawing platforn 
bbox = [0 1 0 1];
resolution = 0.001; %resolution of map

figure;
axis(bbox);
grid on;
count = 1;
while(1)
    title('Drag rect');
    final_rect = getrect(gca);
    rectangle('Position',final_rect,'FaceColor','r');
    rectangle_array(count).low = final_rect(1:2);
    rectangle_array(count).high = final_rect(1:2)+final_rect(3:4);
    map = rectangle_maps( bbox, rectangle_array, resolution);
    
    clf;
    visualize_map(map);
    grid on;

    count = count + 1;
    title('Left click to continue, right click to stop');
    [~,~,button] = ginput(1);
    if (button == 3)
        break;
    end
end
