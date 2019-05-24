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
theta_1 = 0.5;
eps_theta = 0.01;
N = 10;
theta_2 = (theta_1 + eps_theta)^(1/N);
region_test = logical([1 zeros(1, N);
    0 ones(1, N)]);
test_bias = [theta_1 theta_2*ones(1,N)];
test_cost = ones(1, N+1);
test_outcomes = logical(binornd(1, test_bias));

num_region = 2;  %How many regions (paths are there)
num_test = size(region_test,2); %How many tests (edges are there)

num_datapoints = 100; %100; % How many test data
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