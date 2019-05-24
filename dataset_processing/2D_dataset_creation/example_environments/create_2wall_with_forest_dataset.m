%% Create a wall with gaps in conjunction with poisson forest
% Create a wall with gaps and induce stochasticity by randomly sampling
% from a list of configurations. A small list enforces a natural structural
% corrleation. The poisson forest is to additionally increase difficulty of
% the problem
clc;
clear;
close all;

%% World
rng(1);
bbox = [0 1 0 1]; %unit bounding box
num_worlds = 1000;
resolution = 0.001; %map resolution
env_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_2/environments/');

%% Wall with gaps
num_gaps = 5;
num_configs = 20;
config_set = randi(2, num_configs, 2*num_gaps)-1;
config_set( logical(sum(config_set(:, 1:num_gaps),2) <=1) | logical(sum(config_set(:, (num_gaps+1):2*num_gaps),2) <=1), :) = [];
width = 0.15;
gap_height = 0.5/num_gaps; %half the height

%% Forest
square_side = 0.1;
num_squares = 3; % number of rectangles
bbox_forest = [bbox(1) + square_side*0.75 bbox(2) - square_side*0.75 bbox(3) + square_side*0.75 bbox(4) + square_side*0.75];

%% Create world
for i = 1:num_worlds
    i

    shape_array = [];
    % Sample a config
    config = config_set(randi(size(config_set,1)), :);
    shape_array = [shape_array get_wall_with_uniform_gaps( bbox, 0.3, width, gap_height, config(1:num_gaps) )];
    shape_array = [shape_array get_wall_with_uniform_gaps( bbox, 0.7, width, gap_height, config((num_gaps+1):2*num_gaps) )];
    shape_array = [shape_array get_square_poisson_forest( bbox, square_side, num_squares )];

    map = convert_rectangle_shape_array_to_map( shape_array, bbox, resolution );

    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    save(filename, 'map');
end
