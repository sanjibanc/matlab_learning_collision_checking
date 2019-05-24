
clc;
clear;
close all;

%% World
rng(1);
bbox = [0 1 0 1]; %unit bounding box
num_worlds = 5000;
resolution = 0.005; %map resolution
env_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_8/environments/');

%% Wall with gaps
wall_width = 0.1;
gap_width = 0.1;
gap_height = 0.15;
bounds = [0.3 0.7 0.2 0.8];

%% Create world
for i = 1:num_worlds
    i
    shape_array = [];
    % Sample a config
    pos  = unifrnd(bounds([1 3]), bounds([2 4]));
    shape_array = [shape_array get_wall_baffle( bbox, pos(1), pos(2), wall_width, gap_width, gap_height)];
    
    map = convert_rectangle_shape_array_to_map( shape_array, bbox, resolution );

%     figure(1);
%     visualize_map(map);
%     axis(bbox);
%     pause;
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    save(filename, 'map');
end
