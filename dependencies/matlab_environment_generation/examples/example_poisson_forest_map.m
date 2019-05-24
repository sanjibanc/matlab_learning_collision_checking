%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_POISSON_FOREST_MAP
% Create sample poisson forest composed on rectangles
clc;
clear;
close all;

%% Create analytic world
bbox = [0 1 0 1]; %unit bounding box
side = 0.1;
num_squares = 15; % number of rectangles

square_array = get_square_poisson_forest( bbox, side, num_squares );

resolution = 0.001; %resolution of map
map = convert_rectangle_shape_array_to_map( square_array, bbox, resolution );

%% Visualize work
figure;
visualize_map(map);
