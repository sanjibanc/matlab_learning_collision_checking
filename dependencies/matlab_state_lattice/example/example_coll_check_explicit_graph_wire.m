%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Load
load(strcat('../resources/explicit_graph_3.mat'), 'G', 'edge_traj_list', 'start_idx', 'goal_idx');
results = dlmread('/Volumes/NO NAME/Content/datasets/matlab_learning_collision_checking_dataset/dataset_wire_1/real_data/17.txt');

%% Collision check
connected_status = logical(results);

%% Plan a path
id_list = sub2ind(size(G), [edge_traj_list.id1]', [edge_traj_list.id2]');
status = G;
status(id_list(~connected_status)) = 0;
%status(id_list) = connected_status;

[~, path] = graphshortestpath(status, start_idx, goal_idx);
path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
[~, path_edges_idx] = ismember(path_edges, id_list);

%% Visualize work
figure;
hold on;

for i = 1:size(edge_traj_list,1)
    if (~connected_status(i))
        col = 'r';
    else
        col = 'b';
    end
    plot3(edge_traj_list(i).traj(:,1), edge_traj_list(i).traj(:,2), edge_traj_list(i).traj(:,4), 'Color', col, 'LineWidth', 0.25);
end

for i = path_edges_idx
    plot3(edge_traj_list(i).traj(:,1), edge_traj_list(i).traj(:,2), edge_traj_list(i).traj(:,4),'g', 'LineWidth', 3);
end