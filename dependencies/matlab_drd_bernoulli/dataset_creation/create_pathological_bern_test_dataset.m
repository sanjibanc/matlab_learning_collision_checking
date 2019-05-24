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
foldername = strcat(getenv('collision_checking_dataset_folder'), '/dataset_bern_test_5/');
save_data = true;
region_type = 1;

%% Each scenario varies the number of regions
switch region_type
    case 1
        N = 10;
    case 2
        N = 50;
    case 3
        N = 100;
end

%% Create region_test
theta_1 = 0.9;
eps_theta = 0.01;
theta_2 = (theta_1 + eps_theta)^(1/N);
region_test = logical([1 zeros(1, N);
    0 ones(1, N)]);
test_bias = [theta_1 theta_2*ones(1,N)];
test_cost = ones(1, N+1);
test_outcomes = logical(binornd(1, test_bias));

num_region = 2;  %How many regions (paths are there)
num_test = size(region_test,2); %How many tests (edges are there)

num_datapoints = 100; %100; % How many test data

%% Create outcome sets
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
fprintf('Average alive regions %f \n', mean(alive_status));
if (save_data)
    save(strcat(foldername, 'test_set', num2str(region_type),'.mat'), 'test_outcome_set', 'test_bias', 'test_cost', 'region_test');
end

