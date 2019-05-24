%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Load
type = 1;

load(strcat('../resources/explicit_graph_', num2str(type),'.mat'), 'G', 'edge_traj_list', 'start_idx', 'goal_idx');
%% Create world
if(1)
    bbox = [0 1 0 1]; %unit bounding box
    rectangle_array1 = get_wall_with_uniform_gaps( bbox, 0.3, 0.2, 0.1, [1 1 0 1] );
    rectangle_array2 = get_wall_with_uniform_gaps( bbox, 0.7, 0.2, 0.1, [1 0 1 1] );
    rectangle_array = [rectangle_array1 rectangle_array2];
    
    resolution = 0.001; %resolution of map
    map = convert_rectangle_shape_array_to_map( rectangle_array, bbox, resolution );
end
%% Collision check
connected_status = false(size(edge_traj_list,1), 1);
for i = 1:size(edge_traj_list,1)
    traj_2d = edge_traj_list(i).traj(:,1:2);
    connected = check_coll_wpset_map( traj_2d, map );
    connected_status(i) = connected;
end

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
visualize_map(map);
% plot_edge_traj_list( edge_traj_list );
for i = path_edges_idx
    plot(edge_traj_list(i).traj(:,1), edge_traj_list(i).traj(:,2), 'g');
end
