%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);

load illustrative_graph_test.mat
%% Plot graph
%plot_path_set( path_library, coord_set );
figure(1);
cla;
axis(bbox);
plot_edge_likelihood_regions_only( test_bias, G, coord_set, region_test );
axis off
pause;
%% Policies
policy_type = 1;
switch policy_type
    case 1
        policy = @(selected_test_outcome) direct_drd_bern_max_prob(  selected_test_outcome, region_test, test_bias, test_cost );
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
    %cla;
    %axis(bbox);
    %     for i = active_region
    %         plot_path( path_library{i}, coord_set );
    %     end
    %view_graph( G, coord_set );
    %plot_edge_likelihood_regions_only( test_bias, G, coord_set, region_test );

    for i = 1:size(selected_test_outcome,1)
        if ( selected_test_outcome(i,2) )
            plot_edgeid( selected_test_outcome(i,1), G, coord_set, [0 1 0],6 );
        else
            plot_edgeid( selected_test_outcome(i,1), G, coord_set, [1 0 0],6 );
        end
    end
    pause;
    
    if (any(region_status == 1) || ~any(region_status > 0))
        break;
    end
end