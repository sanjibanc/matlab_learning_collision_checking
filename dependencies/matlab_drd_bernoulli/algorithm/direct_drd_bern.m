%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ selected_test, selected_gain, marginal_gain] = direct_drd_bern(  selected_test_outcome, region_test, test_bias, test_cost, option )
%DIRECT_DRD_BERN Summary of this function goes here
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
%region_test_init = region_test;

region_test = region_test(region_status > 0, :);
region_status = region_status(region_status > 0);
candidate_test_set = intersect(candidate_test_set, find(sum(region_test, 1)));

if (option == 1)
    [~, region_idx] = max(region_status);
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
elseif (option == 2)
    weight = exp(100*region_status);
    region_idx = find(mnrnd(1, weight/sum(weight), 1));
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
end

marginal_gain = zeros(1, num_test);
marginal_gain_relev = zeros(1, length(candidate_test_set));
for i = 1:length(candidate_test_set)
    t = candidate_test_set(i);
    gain = 0;
    for xt = [true false]
        prob = ( test_bias(t)^xt )*(( 1 - test_bias(t))^(~xt));
        marg = marginal_f_drd_bern(  t, xt, selected_test_outcome, region_test, test_bias);
        gain = gain + prob*marg;
    end
    marginal_gain(t) = gain / test_cost(t);
    marginal_gain_relev(i) = marginal_gain(t);
end
[selected_gain, selected_test_idx] = max(marginal_gain_relev);
selected_test = candidate_test_set(selected_test_idx);

% check if tie breaking necessary
[~, region_idx] = max(region_status);
max_prob_region_tests = find( region_test(region_idx, :) );
[v, idx] = max(marginal_gain(max_prob_region_tests));
if (v == selected_gain)
    selected_gain = v;
    selected_test = max_prob_region_tests(idx);
end

%marginal_gain = drd_mult_factor( selected_test_outcome, test_bias, region_test_init )*marginal_gain;


end

