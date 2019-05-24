clc;
clear;
close all;

%% World
rng(1);
bbox = [0 1 0 1]; %unit bounding box
num_worlds = 1000;
resolution = 0.005; %map resolution
env_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_xyh_5/environments/');

%% Wall with gaps
wall_width = 0.05;
back_length = 0.5;
side_length = 0.35;

%% Forest
square_side = 0.05;
num_squares = 6; % number of rectangles


%% Create world
for i = 1:num_worlds
    i
    shape_array = [];
    
    orient = 1;
        x_cnt = unifrnd(0.3, 0.7);
        y_cnt = unifrnd(0.2, 0.8);

    shape_array = [shape_array get_rectangle_bugtrap( x_cnt, y_cnt, orient, wall_width, back_length, side_length)];
    
    shape_array = [shape_array get_square_poisson_forest( bbox, square_side, num_squares )];
    
    map = convert_rectangle_shape_array_to_map( shape_array, bbox, resolution );

%     figure(1);
%     visualize_map(map);
%     axis(bbox);
%     pause;
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    save(filename, 'map');
end