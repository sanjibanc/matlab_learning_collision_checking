%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
%% Load data
filename = '/Volumes/NO NAME/matlab_learning_collision_checking_dataset/dataset_graph_bern_test_2/path_library.mat';
load(filename, 'G', 'bbox', 'coord_set', 'path_library');
policy_type = 1;

%% Create regions and test
edges = find(G);
edge_id_lookup = sparse(size(G,1), size(G,2));
edge_id_lookup(edges) = transpose(1:length(edges));

test_bias = 0.5*ones(1, length(edges));
test_cost = ones(1, length(edges)); %transpose(full(G(edges)));
region_test = false(length(path_library), length(edges));

for i = 1:length(path_library)
    path = path_library{i};
    path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
    cidx = full(edge_id_lookup(path_edges));
    region_test(i, cidx) = true;
end

while true
    test_outcomes = logical(binornd(1, test_bias));
    region_status = get_region_status( [], region_test, test_outcomes );
    if (nnz(region_status > 0))
        break;
    end 
end
%% Policies
switch policy_type
    case 1
        policy = @(selected_test_outcome) direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost );
    case 2
        policy = @(selected_test_outcome) max_tally_test( selected_test_outcome, region_test );
    case 3
        policy = @(selected_test_outcome) rand_test( selected_test_outcome, region_test );
    case 4
        policy = @(selected_test_outcome) rand_region_rand_test( selected_test_outcome, region_test );
    case 5
        policy = @(selected_test_outcome) max_prob_region_rand_test( selected_test_outcome, region_test, test_bias );
    case 6
        policy = @(selected_test_outcome) max_prob_region_max_tally_test( selected_test_outcome, region_test, test_bias );
    case 7
        policy = @(selected_test_outcome) prob_weighted_max_tally_test( selected_test_outcome, region_test, test_bias );
end

%% Simulation
selected_test_outcome = [];
while (1)
    selected_test = policy(selected_test_outcome);

    outcome = test_outcomes(selected_test);
    selected_test_outcome = [selected_test_outcome; selected_test outcome];
    fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);
    
    region_status = get_region_status( selected_test_outcome, region_test, test_bias );
    active_region = transpose(find(region_status > 0));
            
    figure(1);
    cla;
    axis(bbox);
    for i = active_region
        plot_path( path_library{i}, coord_set );
    end
    %view_graph( G, coord_set );
    for i = 1:size(selected_test_outcome,1)
        plot_edgeid( selected_test_outcome(i,1), selected_test_outcome(i,2), G, coord_set );
    end
    pause;
    
    if (any(region_status == 1) || ~any(region_status > 0))
        break;
    end
end

fprintf('Number of tests: %d Cumulative cost: %f\n', size(selected_test_outcome,1), sum(test_cost(selected_test_outcome(:,1))) );