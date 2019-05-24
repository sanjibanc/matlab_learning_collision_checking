%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_SAMPLE_SHAPES
% Create sample shapes composed on rectangles
clc;
clear;
close all;

%% Create two rectangles
bbox = [0 1 0 1]; %unit bounding box
% rectangle 1
rectangle_array(1) = get_rectangle_shape(0.2,0.2,0.2,0.4);
% rectangle 2
rectangle_array(2) = get_rectangle_shape(0.6,0.5,0.2,0.4);

%% Visualize 
figure;
visualize_shapes(rectangle_array);
axis(bbox)
