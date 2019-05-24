%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
%% Problem parameters
num_region = 1000;  %How many regions (paths are there)
num_test = 100; %How many tests (edges are there)
min_test_in_region = round(0.05*num_test); 
max_test_in_region = round(0.10*num_test);

test_bias = 0.1 + 0.8*rand(1, num_test); 
test_cost = ones(1, num_test);

num_datapoints = 1; %100; % How many test data
%% Create test to region allocation
region_test = false(num_region, num_test);
for i = 1:num_region
    num_test_in_region = randi([min_test_in_region, max_test_in_region]);
    region_test(i, randperm(num_test, num_test_in_region)) = true;
end

%% Create ground truth dataset
test_outcome_set = zeros(num_datapoints, num_test);
alive_status = zeros(num_datapoints, 1);
count = 1;
while (count <= num_datapoints)
    outcome = logical(binornd(1, test_bias));
    region_status = get_region_status( [], region_test, outcome );
    if (sum(region_status) == 0)
        continue;
    end
    test_outcome_set(count, :) = outcome;
    alive_status(count) = sum(region_status);
    count = count +1;
end

%% Policies
policy_type = 9;
switch policy_type
    case 1
        policy = @(selected_test_outcome) rand_test( selected_test_outcome, region_test, test_bias, 0 ); % Random test
    case 2
        policy = @(selected_test_outcome) rand_test( selected_test_outcome, region_test, test_bias, 1 ); % Random test + Max prob    
    case 3
        policy = @(selected_test_outcome) max_tally_test(  selected_test_outcome, region_test, test_bias, 0 ); % Max tally test 
    case 4
        policy = @(selected_test_outcome) max_tally_test(  selected_test_outcome, region_test, test_bias, 1 ); % Max tally test + Max prob
    case 5
        policy = @(selected_test_outcome) max_mvoi(  selected_test_outcome, region_test, test_bias ); % Max MVOI
    case 6
        policy = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, 0 ); % SetCover
    case 7
        policy = @(selected_test_outcome) max_set_cover(  selected_test_outcome, region_test, test_bias, 1 ); % SetCover + Max prob
    case 8
        policy = @(selected_test_outcome) direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 0 ); % Unconstrained Direct
    case 9
        policy = @(selected_test_outcome) direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, 1 ); % Direct constrained
end

%% Simulation
cumulative_cost_set = zeros(1, size(test_outcome_set, 1));
for i = 1:size(test_outcome_set, 1)
    test_outcomes = test_outcome_set(i, :);
    selected_test_outcome = [];
    while (1)
        selected_test = policy(selected_test_outcome);

        outcome = test_outcomes(selected_test);
        selected_test_outcome = [selected_test_outcome; selected_test outcome];
        fprintf('Selected test: %d Outcome: %d\n', selected_test, outcome);

        region_status = get_region_status( selected_test_outcome, region_test, test_bias ); %validity of regions
        if (any(region_status == 1) || ~any(region_status > 0)) % a region solved or no valid exists
            break;
        end
    end
    cum_cost = sum(test_cost(selected_test_outcome(:,1)));
    fprintf('Datapoint: %d Cumulative cost: %f\n', i, cum_cost );
    cumulative_cost_set(i) = cum_cost;
end

fprintf('Mean cost over dataset: %f\n', mean(cumulative_cost_set) );