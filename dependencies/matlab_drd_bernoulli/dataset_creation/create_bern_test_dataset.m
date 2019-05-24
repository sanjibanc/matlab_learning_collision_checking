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
foldername = strcat(getenv('collision_checking_dataset_folder'), '/dataset_bern_test_3/');
region_type = 3;
save_data = true;

num_test = 100;
min_test_in_region = round(0.05*num_test);
max_test_in_region = round(0.10*num_test);
num_datapoints = 100;

%% Each scenario varies the number of regions
switch region_type
    case 1
        num_region = num_test;
    case 2
        num_region = 5*num_test;
    case 3
        num_region = 10*num_test;
end

%% Create region_test
region_test = false(num_region, num_test);
for i = 1:num_region
    num_test_in_region = randi([min_test_in_region, max_test_in_region]);
    region_test(i, randperm(num_test, num_test_in_region)) = true;
end

%% Create outcome sets
for problem_type = 1:3
    switch problem_type
        case 1
            test_bias = 0.5*ones(1, num_test);
            test_cost = ones(1, num_test);
        case 2
            test_bias = 0.1 + 0.8*rand(1, num_test);
            test_cost = ones(1, num_test);
        case 3
            test_bias = 0.1 + 0.8*rand(1, num_test);
            test_cost = rand(1, num_test);
    end
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
        save(strcat(foldername, 'test_set', num2str(problem_type),'.mat'), 'test_outcome_set', 'test_bias', 'test_cost', 'region_test');
    end
end
