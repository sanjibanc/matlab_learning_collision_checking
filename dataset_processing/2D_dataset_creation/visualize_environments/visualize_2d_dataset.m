clc;
clear;
close all;

%% World
rng(1);
num_worlds = 1000;
dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_7/');
env_dataset = strcat(dataset,'environments/');
set_dataset = dataset;

%% Load graph
G = load_graph( strcat(set_dataset,'graph.txt') );
load( strcat(set_dataset, 'coord_set.mat'), 'coord_set'); %Optional
load(strcat(set_dataset, 'start_goal.mat'), 'start_idx', 'goal_idx');
%% Create world
edges = find(G);
coll_check_results = zeros(num_worlds, length(edges));
for i = 1:num_worlds
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    load(filename, 'map');
    % Collision check
    line_coll_check_fn = @(parent, child) check_coll_line_map( parent, child, map );
    pt_coll_check_fn = @(pt) check_coll_wpset_map( pt, map ); 
    status = collision_check_2d_graph( G, coord_set, line_coll_check_fn, pt_coll_check_fn );
        
    figure(1);
    cla;
    visualize_map(map);
    view_graph( status, coord_set );
    pause
end
