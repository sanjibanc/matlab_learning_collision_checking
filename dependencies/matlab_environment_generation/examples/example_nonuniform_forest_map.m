%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%% EXAMPLE_NONPOISSON_FOREST_MAP
% Create sample poisson forest composed on rectangles
clc;
clear;
close all;

%% Create analytic world
bbox = [0 1 0 1]; %unit bounding box
side = 0.1;
num_squares = 15; % number of rectangles

%% Create centres
mu = [0.3 0.3; 
      0.1 0.5;
      0.7 0.7;
      0.9 0.5;
      0.5 0.5];
sigma = repmat(0.01*eye(2), [1 1 size(mu,1)]);
p = ones(1,size(mu,1));
obj = gmdistribution(mu,sigma,p);

figure;
axis(bbox);
ezcontour(@(x,y)pdf(obj,[x y]),bbox);


square_array = get_square_nonuniform_forest( bbox, side, num_squares, obj );

resolution = 0.001; %resolution of map
map = convert_rectangle_shape_array_to_map( square_array, bbox, resolution );

%% Visualize work
figure;
visualize_map(map);
