%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_CONVERT_SHAPES_TO_MAP
% Convert shapes to a map
clc;
clear;
close all;

%% Create two rectangles
bbox = [0 1 0 1]; %unit bounding box
resolution = 0.001; %map resolution
% rectangle 1
rectangle_array(1) = get_rectangle_shape(0.2,0.2,0.2,0.4);
% rectangle 2
rectangle_array(2) = get_rectangle_shape(0.6,0.5,0.2,0.4);

%% Convert to map
map = convert_rectangle_shape_array_to_map( rectangle_array, bbox, resolution );

%% Visualize work
figure;
visualize_map(map);
