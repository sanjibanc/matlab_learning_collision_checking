%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ selected_test, selected_gain, marginal_gain] = max_mvoi(  selected_test_outcome, region_test, test_bias )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

num_test = size(region_test,2);
if (~isempty(selected_test_outcome))
    candidate_test_set = setdiff(find(sum(region_test, 1)), selected_test_outcome(:,1)');
else
    candidate_test_set = find(sum(region_test, 1));
end
region_status = get_region_status( selected_test_outcome, region_test, test_bias );

if (isempty(candidate_test_set) || any(region_status == 1) || ~any(region_status > 0))
    selected_test = [];
    selected_gain = 0;
    marginal_gain = [];
    return;
end

% prune regions since drd will fail to eliminate them
region_test = region_test(region_status > 0, :);
region_status = region_status(region_status > 0);
candidate_test_set = intersect(candidate_test_set, find(sum(region_test, 1)));

all_region_idx = find(region_status == max(region_status));
candidate_test_set =  intersect(  find(sum(region_test(all_region_idx, :), 1) > 0) , candidate_test_set);

marginal_gain = zeros(1, num_test);
marginal_gain_relev = zeros(1, length(candidate_test_set));
for i = 1:length(candidate_test_set)
    t = candidate_test_set(i);
    gain = 0;
    prob = test_bias(t);
    region_status_new = get_region_status( [selected_test_outcome; t false], region_test, test_bias );
    marginal_gain(t) = (1 - prob)*( max(region_status_new) );
    marginal_gain_relev(i) = marginal_gain(t);
end

[selected_gain, selected_test_idx] = max(marginal_gain_relev);
selected_test = candidate_test_set(selected_test_idx);
end

