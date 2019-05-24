clc;
clear;
close all;

%% World
rng(1);
num_worlds = 1000;
set_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_7/');
env_dataset = strcat(set_dataset,'environments/');

%% Create graph
bbox = [0 1 0 1];
N = 200;
eta = 0.75;
[ G, coord_set ] = rgg( bbox, N, eta);

%% Start and goal
[~, start_idx] = min(pdist2([0 0], coord_set), [], 2);
[~, goal_idx] = min(pdist2([1 1], coord_set), [], 2);
G(start_idx, goal_idx) = norm(coord_set(start_idx, :) - coord_set(goal_idx, :));
G(goal_idx, start_idx) = G(start_idx, goal_idx);

%% 
figure(1);
view_graph( G, coord_set );

save_graph( strcat(set_dataset, 'graph.txt'), G );
save(strcat(set_dataset, 'coord_set.mat'), 'coord_set');
save(strcat(set_dataset, 'start_goal.mat'), 'start_idx', 'goal_idx');
