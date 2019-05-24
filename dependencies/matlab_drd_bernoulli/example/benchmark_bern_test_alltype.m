%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
%% Dataset
foldername = strcat(getenv('collision_checking_dataset_folder'), '/dataset_bern_test_1/');
load(strcat(foldername, 'test_set2.mat'));

if(exist('G', 'var'))
    test_outcome_set = logical(test_outcome_set);
    [ G, test_outcome_set, test_cost, path_library, region_test ] = remove_redundant_edges( G, test_outcome_set, test_cost, path_library, region_test  );
end

%% Create a policy set
set = 2;
policy_set = {};
switch set
    case 1 % FOR paper
        policy_set{length(policy_set)+1} = @(selected_test_outcome) rand_test( selected_test_outcome, region_test );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_prob_region_rand_test( selected_test_outcome, region_test, test_bias );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_l1_diff(  selected_test_outcome, region_test, test_bias, false );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_l1_diff(  selected_test_outcome, region_test, test_bias, true );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) prob_weighted_max_tally_test(  selected_test_outcome, region_test, test_bias, false );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) prob_weighted_max_tally_test(  selected_test_outcome, region_test, test_bias, true );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, false );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, true );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) direct_drd_bern_max_prob(  selected_test_outcome, region_test, test_bias, test_cost );
    case 2 % FOR paper
        policy_set{length(policy_set)+1} = @(selected_test_outcome) rand_test( selected_test_outcome, region_test, test_bias, 0 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) rand_test( selected_test_outcome, region_test, test_bias, 1 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_tally_test(  selected_test_outcome, region_test, test_bias, 0 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_tally_test(  selected_test_outcome, region_test, test_bias, 1 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, 0 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, 1 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_mvoi(  selected_test_outcome, region_test, test_bias );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 0 ); 
        policy_set{length(policy_set)+1} = @(selected_test_outcome) direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 1 ); 
    case 3
        policy_set{length(policy_set)+1} = @(selected_test_outcome) rand_test( selected_test_outcome, region_test, test_bias, 1 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_tally_test(  selected_test_outcome, region_test, test_bias, 0 );
        %policy_set{length(policy_set)+1} = @(selected_test_outcome) max_tally_test(  selected_test_outcome, region_test, test_bias, 1 );
        %policy_set{length(policy_set)+1} = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, 0 );
        %policy_set{length(policy_set)+1} = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, 1 );
        policy_set{length(policy_set)+1} = @(selected_test_outcome) max_mvoi(  selected_test_outcome, region_test, test_bias );
        %policy_set{length(policy_set)+1} = @(selected_test_outcome) direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 0 );
    case 4
        %policy_set{length(policy_set)+1} = @(selected_test_outcome) direct_drd_bern_lite(  selected_test_outcome, region_test, test_bias,test_cost, 0 );  
        policy_set{length(policy_set)+1} = @(selected_test_outcome) direct_drd_bern_lite(  selected_test_outcome, region_test, test_bias,test_cost, 1 );  
end

%% Perform stuff
cumulative_cost_set = zeros(length(policy_set), size(test_outcome_set, 1));
for i = 1:length(policy_set)
    policy = policy_set{i};
    parfor j = 1:size(test_outcome_set, 1)
        test_outcomes = test_outcome_set(j, :);
        selected_test_outcome = [];
        while (1)
            selected_test = policy(selected_test_outcome);
            
            outcome = test_outcomes(selected_test);
            selected_test_outcome = [selected_test_outcome; selected_test outcome];
            
            region_status = get_region_status( selected_test_outcome, region_test, test_bias );
            if (any(region_status == 1) || ~any(region_status > 0))
                break;
            end
        end
        cum_cost = sum(test_cost(selected_test_outcome(:,1)));
        fprintf('Policy: %d Test: %d Cumulative cost: %f\n', i, j, cum_cost );
        cumulative_cost_set(i, j) = cum_cost;
    end
end
