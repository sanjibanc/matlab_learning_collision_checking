%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ selected_test ] = weighted_max_tally_test( selected_test_outcome, region_test, test_bias, option )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


if (~isempty(selected_test_outcome))
    candidate_test_set = setdiff(find(sum(region_test, 1)), selected_test_outcome(:,1)');
else
    candidate_test_set = find(sum(region_test, 1));
end

region_status = get_region_status( selected_test_outcome, region_test, test_bias );
weighted_region_test = repmat(region_status, [1 size(region_test,2)]).*region_test;

if (option == 1)
    [~, region_idx] = max(region_status);
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
elseif (option == 2)
    region_test = region_test(region_status > 0, :);
    region_status = region_status(region_status > 0);
    
    weight = exp(100*region_status);
    region_idx = find(mnrnd(1, weight/sum(weight), 1));
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
end

tally = sum(weighted_region_test(:,candidate_test_set), 1);
idx = find(tally == max(tally));
selected_test = candidate_test_set(idx(randi(length(idx))));
end