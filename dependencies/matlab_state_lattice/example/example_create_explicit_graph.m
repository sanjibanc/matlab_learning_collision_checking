%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Lattice
type = 4;

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
        bbox = [-100.0 600.0 -250.0 250.0 -10.0 50.0];
        lattice_type = 5;
        radius = 100.0;
        path_res = 5.0;
        z_set = [0 1];
        state_lattice = XYHZAnalyticLattice(lattice_type, radius, 0.1, path_res, z_set, [0 0 0]);
        start = [0      0   0   0];
        goal =  [500.0  0   0   30.0];
        hash_size = [200 200 8 100];  
    case 4
        bbox = [-100.0 700.0 -260.0 260.0 -36.0 1.0];
        lattice_type = 5;
        radius = 100.0;
        path_res = 5.0;
        z_set = [0 -1 1];
        state_lattice = XYHZAnalyticLattice(lattice_type, radius, 0.1, path_res, z_set, [0 0 0]);
        start = [0      0   0   0];
        goal =  [700.0  0   0   0.0];
        hash_size = [200 200 8 100];  
end

%% Get explicit graph
tic
[ G, edge_traj_list, start_idx, goal_idx ] = create_explicit_graph( state_lattice, start, goal, bbox, hash_size );
toc

%% Save
if (1)
    save(strcat('../resources/explicit_graph_', num2str(type),'.mat'), 'G', 'edge_traj_list', 'start_idx', 'goal_idx');
end

%% Plot
if (1)
    figure;
    if (length(bbox) == 6)
        plot_edge_traj_list_3d( edge_traj_list );
    elseif (length(bbox) == 4)
        plot_edge_traj_list( edge_traj_list );
    end
end