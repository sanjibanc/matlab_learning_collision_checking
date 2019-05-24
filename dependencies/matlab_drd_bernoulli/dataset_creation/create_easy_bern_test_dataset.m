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
foldername = strcat(getenv('collision_checking_dataset_folder'), '/dataset_bern_test_4/');
region_type = 1;
save_data = true;

num_test = 1000;
min_test_in_region = 75;
max_test_in_region = 150;
num_datapoints = 100;

%% Each scenario varies the number of regions
switch region_type
    case 1
        num_region = 10;
    case 2
        num_region = 50;
    case 3
        num_region = 100;
end

%% Create region_test
region_test = false(num_region, num_test);
for i = 1:num_region
    num_test_in_region = randi([min_test_in_region, max_test_in_region]);
    region_test(i, randperm(num_test, num_test_in_region)) = true;
end

%% Create outcome sets
test_bias = 0.95 + 0.05*rand(1, num_test);
test_cost = ones(1, num_test);

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
