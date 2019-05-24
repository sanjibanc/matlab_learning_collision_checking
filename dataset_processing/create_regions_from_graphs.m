%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Create regions from graphs and coll check results
% Reads a graph
clc;
clear;
close all;

%% Load stuff
dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_7/');
set_dataset = dataset;

G = load_graph( strcat(set_dataset,'graph.txt') );

%coll_check_results = dlmread( strcat(set_dataset, 'coll_check_results.txt') );
load( strcat(set_dataset, 'coll_check_results.mat'), 'coll_check_results' );
load(strcat(set_dataset, 'start_goal.mat'), 'start_idx', 'goal_idx');
%% Create a path set
option_library_generation = 4;
warm_start_big_library = false;
load_library = false;
if (load_library)
    load(strcat(set_dataset, 'path_library.mat'), 'path_library');
else
    switch(option_library_generation)
        case 1
            % Greedily create library by getting the best expected path, adding
            % it to library, pruning solved problems and repeating. Some hacks
            % to work around the fact that expectation of edges in collision
            % requires soft constraints.
            if (~warm_start_big_library)
                num_library = 10;
                path_library_big = get_expkshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, num_library  );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            path_library = path_library_big;
        case 2
            % Greedily go through dataset and see if existing library can solve
            % the problem. If not add path to dataset and proceed.
            if (~warm_start_big_library)
                path_library_big = get_greedpaths_dataset( coll_check_results, G, start_idx, goal_idx, 2 );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            fprintf('Num library set: %d \n',length(path_library_big));
            % Apply conseqopt to prune library to desired quantity
            %         num_library = 10;
            %         path_library = greedily_prune_library( path_library_big, coll_check_results, G, num_library );
            path_library = path_library_big;
        case 3
            % Create k shortest paths from each world and take union
            k = 5; %5
            if (~warm_start_big_library)
                path_library_big = get_kshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, k );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            fprintf('Num library set before pruning: %d \n',length(path_library_big));
            % Apply conseqopt to prune library to desired quantity
            num_library = Inf; %10;
            path_library = greedily_prune_library( path_library_big, coll_check_results, G, num_library );
            fprintf('Num library set after pruning: %d \n',length(path_library));
        case 4
            % Create k shortest paths from each world and take union
            k = 5;
            if (~warm_start_big_library)
                path_library_big = get_kshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, k );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            fprintf('Num library set before pruning: %d \n',length(path_library_big));
            % Apply conseqopt to prune library to desired quantity
            num_library = min(500, length(path_library_big));
            idx = randperm(length(path_library_big), num_library);
            for i = 1:num_library
                path_library_pruned{i} = path_library_big{idx(i)};
            end
            path_library = path_library_pruned;
            fprintf('Num library set after pruning: %d \n',length(path_library));
        case 5
            % Create k shortest paths from each world and take union
            k = 1000;
            if (~warm_start_big_library)
                path_library_big = get_kshortestpaths_dataset( coll_check_results(1,:), G, start_idx, goal_idx, k );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            world_library_assignment = get_world_library_assignment( path_library_big, coll_check_results, G );
            membership = (sum(world_library_assignment,1))/size(world_library_assignment, 1);
            candidate_paths = find(membership > 0.25 & membership < 0.75);
            [~, ia] = unique(world_library_assignment', 'rows');
            candidate_paths = intersect(candidate_paths, ia);
            path_library = path_library(candidate_paths);
        case 6
            % Create k shortest paths from each world and take union
            k = 1;
            if (~warm_start_big_library)
                path_library_big = get_kshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, k );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            fprintf('Num library set before pruning: %d \n',length(path_library_big));
            % Apply conseqopt to prune library to desired quantity
            num_library = Inf; %10;
            path_library = greedily_prune_library( path_library_big, coll_check_results, G, num_library );
            fprintf('Num library set after pruning: %d \n',length(path_library));
        case 7
            % Create k shortest paths from each world and take union
            k = 1;
            if (~warm_start_big_library)
                path_library_big = get_kshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, k );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            fprintf('Num library set before pruning: %d \n',length(path_library_big));
            path_library = path_library_big;
            fprintf('Num library set after pruning: %d \n',length(path_library));
        case 8
            % Create k shortest paths from each world and take union
            k = 1000;
            if (~warm_start_big_library)
                path_library_big = get_pomp_dataset( coll_check_results, G, start_idx, goal_idx, k );
            else
                load(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
            end
            fprintf('Num library set before pruning: %d \n',length(path_library_big));
            path_library = path_library_big;
            fprintf('Num library set after pruning: %d \n',length(path_library));
    end
end
if (0)
    figure;
    load( strcat(set_dataset, 'coord_set.mat'), 'coord_set'); %Optional
    view_graph( G, coord_set );
    plot_path_set( path_library, coord_set );
end

%% Create a hyp_region matrix that can be used by decision region determination algorithm
world_library_assignment = get_world_library_assignment( path_library, coll_check_results, G );
fprintf('Num regions: %d Num unsolved worlds: %d \n', size(world_library_assignment, 2), nnz(~any(world_library_assignment,2)));

%% Save path library and hyp region
if (~load_library)
    save(strcat(set_dataset, 'path_library.mat'), 'path_library');
    save(strcat(set_dataset, 'path_library_big.mat'), 'path_library_big');
end
save(strcat(set_dataset, 'world_library_assignment.mat'), 'world_library_assignment');