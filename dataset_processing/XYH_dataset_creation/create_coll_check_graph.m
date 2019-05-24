clc;
clear;
close all;

%% World
rng(1);
num_worlds = 1000;
dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_xyh_5/');
set_dataset = dataset;
env_dataset = strcat(dataset,'environments/');

%% Create graph
type = 1;

switch type
    case 1
        bbox = [0 1 0 1];
        lattice_type = 2;
        radius = 0.1;
        path_res = 0.01;
        state_lattice = XYHAnalyticLattice(lattice_type, radius, path_res, [0 0]);
        start = [0.05 0.5 0];
        goal = [0.95 0.5 0];
        hash_size = [200 200 8];
    case 2
        bbox = [0 1 0 1];
        lattice_type = 3;
        radius = 0.075;
        path_res = 0.01;
        state_lattice = XYHAnalyticLattice(lattice_type, radius, path_res, [0 0]);
        start = [0.05 0.5 0];
        goal = [0.95 0.5 0];
        hash_size = [200 200 8];
    case 3
        bbox = [0 1 0 1];
        lattice_type = 4;
        radius = 0.1;
        path_res = 0.01;
        state_lattice = XYHAnalyticLattice(lattice_type, radius, path_res, [0 0]);
        start = [0.05 0.5 0];
        goal = [0.95 0.5 0];
        hash_size = [200 200 8];
    case 4
        bbox = [0 1 0 1];
        lattice_type = 1;
        radius = 0.1;
        path_res = 0.01;
        state_lattice = XYHAnalyticLattice(lattice_type, radius, path_res, [0 0]);
        start = [0.05 0.5 0];
        goal = [0.95 0.5 0];
        hash_size = [200 200 4];
end

[ G, edge_traj_list, start_idx, goal_idx ] = create_explicit_graph( state_lattice, start, goal, bbox, hash_size );

if (0)
    save(strcat('../resources/explicit_graph_', num2str(type),'.mat'), 'G', 'edge_traj_list', 'start_idx', 'goal_idx');
end
if (0)
    figure;
    plot_edge_traj_list( edge_traj_list );
end

%% Save stuff
save_graph( strcat(set_dataset, 'graph.txt'), G );
save(strcat(set_dataset, 'start_goal.mat'), 'start_idx', 'goal_idx');
save(strcat(set_dataset, 'edge_traj_list.mat'), 'edge_traj_list');

%% Create world
edges = find(G);
coll_check_results = false(num_worlds, length(edges));

map_set = [];
for i = 1:num_worlds
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    load(filename, 'map');
    map_set{i} = map;
end

parfor i = 1:num_worlds
    i
    % Filename
    filename = strcat(env_dataset, 'world_',num2str(i),'.mat');
    map = map_set{i};
    % Collision check
    status = sparse(G);
    for j = 1:size(edge_traj_list,1)
        traj_2d = edge_traj_list(j).traj(:,1:2);
        connected = check_coll_wpset_map( traj_2d, map );
        status(edge_traj_list(j).id1, edge_traj_list(j).id2) = connected;
    end
    
    coll_check_results(i, :) = transpose(full(status(edges)));
end
%dlmwrite( strcat(set_dataset, 'coll_check_results.txt'), coll_check_results );
coll_check_results = logical(coll_check_results);
save(strcat(set_dataset, 'coll_check_results.mat'), 'coll_check_results');