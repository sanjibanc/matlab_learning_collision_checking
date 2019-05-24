%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ selected_test, selected_gain, marginal_gain] = max_weighted_region_status(  selected_test_outcome, region_test, test_bias )
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

current_val = 0; %put in right val

marginal_gain = zeros(1, num_test);
marginal_gain_relev = zeros(1, length(candidate_test_set));
for i = 1:length(candidate_test_set)
    t = candidate_test_set(i);
    gain = 0;
    for xt = [true false]
        prob = ( test_bias(t)^xt )*(( 1 - test_bias(t))^(~xt));
        region_status_new = get_region_status( [selected_test_outcome; t xt], region_test, test_bias );
        region_outcome_weight_new = get_region_outcome_weight( [selected_test_outcome; t xt], region_test, test_bias );
        val = max( 1 - (1-region_status_new).*region_outcome_weight_new ); 
        gain = gain + prob*(val - current_val);
    end
    
    prob = test_bias(t);
    marginal_gain(t) = (1 - prob)*( max(region_status_new) );
    marginal_gain_relev(i) = marginal_gain(t);
end

[selected_gain, selected_test_idx] = max(marginal_gain_relev);
selected_test = candidate_test_set(selected_test_idx);
end

