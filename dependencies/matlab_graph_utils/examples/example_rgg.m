%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Example RGG
clc;
clear;
close all;

%% Create graph
rng(1);
bbox = [0 1 0 1];
N = 100;

[ G, coord_set ] = rgg( bbox, N);
G = tril(G);
figure;
axis(bbox);
view_graph( G, coord_set );

%% Start and goal
[~, start_idx] = min(pdist2([0 0], coord_set), [], 2);
[~, goal_idx] = min(pdist2([1 1], coord_set), [], 2);


%% Path
% [~, path] = graphshortestpath(G, start_idx, goal_idx, 'directed', false);
% plot_path( path, coord_set );

%% K-Shortest paths
G1 = G + tril(G, -1)';
[~, path_set] = graphkshortestpaths(G1, start_idx, goal_idx, 10);
plot_path_set( path_set, coord_set );

%% Save graph
save_graph( '../resources/test.txt', G );

%% Load graph
% clear G;
% G = load_graph( '../resources/test.txt');
% % reconfirm graph
% figure;
% axis(bbox);
% view_graph( G, coord_set );
% [~, path] = graphshortestpath(G, start_idx, goal_idx);
% plot_path( path, coord_set );

%% Lets collision check
% load ../resources/world.mat;
% 
% line_coll_check_fn = @(parent, child) check_coll_line_map( parent, child, map );
% pt_coll_check_fn = @(pt) check_coll_wpset_map( pt, map ); 
% status = collision_check_2d_graph( G, coord_set, line_coll_check_fn, pt_coll_check_fn );
% figure;
% axis(bbox);
% visualize_map(map);
% view_graph( status, coord_set );