%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

rng(1);
%% Load stuff
dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_7/');
set_dataset = dataset;
load(strcat(set_dataset, 'world_library_assignment.mat'), 'world_library_assignment');
type = 3;

switch type
    case 1
        %% Train test id
        all_id = 1:size(world_library_assignment, 1);
        train_id = all_id;
        
        valid_region_id = all_id(any(world_library_assignment, 2));
        num_test = 100;
        test_id = valid_region_id(randperm(length(valid_region_id), num_test));
    case 2
        num_train = 500;

        all_id = 1:size(world_library_assignment, 1);
        train_id = all_id(1:num_train);
        
        test_id = setdiff(all_id, train_id);
        valid_region_id = intersect(test_id, all_id(any(world_library_assignment, 2)));
        num_test = 100;
        test_id = valid_region_id(randperm(length(valid_region_id), num_test));
    case 3
        test_perc = 0.1;
        
        num_test = round(test_perc * size(world_library_assignment, 1));
        all_id = 1:size(world_library_assignment, 1);
        valid_region_id = all_id(any(world_library_assignment, 2));
        test_id = valid_region_id(randperm(length(valid_region_id), num_test));

        train_id = setdiff(all_id, test_id);
    case 4
        test_id = 1;
        all_id = 1:size(world_library_assignment, 1);
        train_id = setdiff(all_id, test_id);
end
%% Save ids
save(strcat(set_dataset, 'train_id.mat'), 'train_id');
save(strcat(set_dataset, 'test_id.mat'), 'test_id');