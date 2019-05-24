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
env_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_3/environments/');

%% Wall with gaps
wall_width = 0.02;
gap_clearance = 0.1;
min_seg_length = 0.8;
num_segs = 5;
is_left_right = true;

%% Create world
for i = 1:num_worlds
    i
    
    shape_array = [];
    % Sample a config
    if (is_left_right)
        while true
            vertical_disp = transpose(cumsum(randfixedsum(num_segs, 1, 1.0, -min_seg_length, min_seg_length)));
            if(is_valid_left_right_tunnel( vertical_disp, bbox, gap_clearance))
                break;
            end
        end
        shape_array = [shape_array get_left_right_tunnel( bbox, vertical_disp, wall_width, gap_clearance);];
    end
    
    map = convert_rectangle_shape_array_to_map( shape_array, bbox, resolution );
    
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    save(filename, 'map');
end
