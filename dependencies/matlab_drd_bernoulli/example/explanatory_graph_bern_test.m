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
scenario = 1;

switch scenario
    case 1
        
        coord_set = ...
            [0.00 0.5;
            0.33 0.0;
            0.33 0.5;
            0.66 0.0;
            0.66 0.5;
            0.66 1.0;
            1.0 0.5];
        
        G = sparse(7,7);
        G(1,2) = 1;
        G(1,3) = 1;
        G(2,4) = 1;
        G(3,5) = 1;
        G(3,6) = 1;
        G(4,7) = 1;
        G(5,7) = 1;
        G(6,7) = 1;
        
        bbox = [0 1 0 1];
        path_library{1} = [1 3 6 7];
        path_library{2} = [1 3 5 7];
        path_library{3} = [1 2 4 7];
        
        Gres = sparse(7,7);
        Gres(1,2) = 1;
        Gres(1,3) = 1;
        Gres(2,4) = 1;
        Gres(3,5) = 1;
        Gres(3,6) = 1;
        Gres(4,7) = 1;
        Gres(5,7) = 1;
        Gres(6,7) = 1;
        
        test_outcomes = transpose(logical(full(Gres(find(G)))));
        
    case 2
        
        coord_set = ...
            [0.00 0.5;
            0.5 0.0;
            0.5 1.0;
            1.0 0.5];
        
        G = sparse(4,4);
        G(1,2) = 1;
        G(1,3) = 1;
        G(2,4) = 1;
        G(3,4) = 1;
        
        bbox = [0 1 0 1];
        path_library{1} = [1 2 4];
        path_library{2} = [1 3 4];
        
        Gres = sparse(4,4);
        Gres(1,2) = 1;
        Gres(1,3) = 1;
        Gres(2,4) = 1;
        Gres(3,4) = 1;
        test_outcomes = transpose(logical(full(Gres(find(G)))));
        
    case 3
        
        coord_set = ...
            [0.00 0.5;
            0.33 0.0;
            0.33 1.0;
            0.66 0.0;
            0.66 1.0;
            1.0 0.5];
        
        G = sparse(6,6);
        G(1,2) = 1;
        G(1,3) = 1;
        G(2,4) = 1;
        G(3,5) = 1;
        G(4,6) = 1;
        G(5,6) = 1;
        
        bbox = [0 1 0 1];
        path_library{1} = [1 2 4 6];
        path_library{2} = [1 3 5 6];
        
        Gres = sparse(6,6);
        Gres(1,2) = 1;
        Gres(1,3) = 1;
        Gres(2,4) = 1;
        Gres(3,5) = 1;
        Gres(4,6) = 1;
        Gres(5,6) = 1;
        test_outcomes = transpose(logical(full(Gres(find(G)))));
        
    case 4
        
        coord_set = ...
            [0.00 0.5;
            0.5 0.0;
            0.5 0.5;
            0.5 1.0;
            1.0 0.5];
        
        G = sparse(5,5);
        G(1,2) = 1;
        G(1,3) = 1;
        G(1,4) = 1;
        G(2,5) = 1;
        G(3,5) = 1;
        G(4,5) = 1;
        
        bbox = [0 1 0 1];
        path_library{1} = [1 2 5];
        path_library{2} = [1 3 5];
        path_library{3} = [1 4 5];
        
        Gres = sparse(5,5);
        Gres(1,2) = 1;
        Gres(1,3) = 1;
        Gres(1,4) = 1;
        Gres(2,5) = 1;
        Gres(3,5) = 1;
        Gres(4,5) = 1;
        test_outcomes = transpose(logical(full(Gres(find(G)))));
end

%%
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
        if ( selected_test_outcome(i,2) )
            plot_edgeid( selected_test_outcome(i,1), G, coord_set, [0 1 0] );
        else
            plot_edgeid( selected_test_outcome(i,1), G, coord_set, [1 0 0] );
        end
    end
    pause;
    
    if (any(region_status == 1) || ~any(region_status > 0))
        break;
    end
end

fprintf('Number of tests: %d Cumulative cost: %f\n', size(selected_test_outcome,1), sum(test_cost(selected_test_outcome(:,1))) );