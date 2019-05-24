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
env_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_4/environments/');

%% Wall with gaps
prob_blob = 0.3;
blob_side = 0.8;

%% Forest
square_side = 0.02;
num_squares = 30; % number of rectangles

%% Create world
for i = 1:num_worlds
    i

    shape_array = [];
    % Sample a config
    if (rand() < prob_blob)
        shape_array = [shape_array get_rectangle_shape(0.5-blob_side*0.5, 0.5-blob_side*0.5, blob_side, blob_side)];
    end
    shape_array = [shape_array get_square_poisson_forest( bbox, square_side, num_squares )];

    map = convert_rectangle_shape_array_to_map( shape_array, bbox, resolution );
%     figure(1);
%     visualize_map(map);pause;
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    save(filename, 'map');
end
