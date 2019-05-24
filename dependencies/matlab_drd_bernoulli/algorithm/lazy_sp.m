%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ selected_test ] = lazy_sp( selected_test_outcome, region_test, test_bias, region_weight, option )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (~isempty(selected_test_outcome))
    candidate_test_set = setdiff(find(sum(region_test, 1)), selected_test_outcome(:,1)');
else
    candidate_test_set = find(sum(region_test, 1));
end

region_status = get_region_status( selected_test_outcome, region_test, test_bias );
weighted_region_test = repmat(region_status, [1 size(region_test,2)]).*region_test;

region_test = region_test(region_status > 0, :);
region_weight = region_weight(region_status > 0);
region_status = region_status(region_status > 0);

[~, region_idx] = min(region_weight);
candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);

if (option == 0)
    selected_test = candidate_test_set(randi(length(candidate_test_set)));
elseif (option == 1)
    tally = sum(weighted_region_test(:,candidate_test_set), 1);
    idx = find(tally == max(tally));
    selected_test = candidate_test_set(idx(randi(length(idx))));
else
    error('invalid option')
    selected_test = 0;
end


end