
clc;
clear;
close all;

%% World
rng(1);
bbox = [0 1 0 1]; %unit bounding box
num_worlds = 1000;
resolution = 0.005; %map resolution
env_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_4/environments/');

%% Wall with gaps
width = 0.15;
gap_height = 0.1;
xbounds = [0.2 0.8];
gap_bounds = [0.2 0.8];

%% Create world
for i = 1:num_worlds
    i
    shape_array = [];
    % Sample a config
    x  = unifrnd(xbounds(1), xbounds(2));
    shape_array = [shape_array get_wall_with_shifting_gaps( bbox, x, width, gap_height, gap_bounds )];
    
    map = convert_rectangle_shape_array_to_map( shape_array, bbox, resolution );

%     figure(1);
%     visualize_map(map);
%     axis(bbox);
%     pause;
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    save(filename, 'map');
end
