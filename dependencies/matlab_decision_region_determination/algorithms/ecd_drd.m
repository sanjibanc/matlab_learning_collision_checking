%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [selected_test, selected_gain, marginal_gain] = ecd_drd( active_hyp, hyp_region, hyp_test, test_cost )
%ECD Summary of this function goes here
%   Detailed explanation goes here

if (isempty(active_hyp))
    error('no active hypothesis');
end

current_weight = weight_ec( active_hyp, hyp_region ); %w(RixRj)

if (current_weight == 0)
    selected_test = []; 
    selected_gain = 0;
    marginal_gain = [];
    return;
end

marginal_gain = zeros(1, length(test_cost));
for t = 1:length(test_cost)
    gain = 0;
    for xt = [true false]
        cond_active_hyp = prune_hyp( active_hyp, hyp_test, t, xt );
        prob = length(cond_active_hyp) / length(active_hyp);
        weight_new = weight_ec(cond_active_hyp, hyp_region);
        gain = gain + prob*(current_weight - weight_new);
    end
    marginal_gain(t) = gain / test_cost(t);
end
[selected_gain, selected_test] = max(marginal_gain);

if (selected_gain == 0)
    selected_test = []; 
    marginal_gain = [];
    return;
end

end

