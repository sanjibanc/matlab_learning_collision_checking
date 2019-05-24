%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [selected_test, selected_gain, marginal_gain] = direct_drd( active_hyp, hyp_subregion_set, hyp_test, test_cost )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (isempty(active_hyp))
    error('no active hypothesis');
end

current_m = marginal_f_drd( active_hyp, hyp_subregion_set );

if (current_m == 0)
    selected_test = [];
    selected_gain = 0;
    marginal_gain = [];
    return;
end

marginal_gain = ones(1, length(test_cost));
for t = 1:length(test_cost)
    if (all(hyp_test(active_hyp, t)) || all(~hyp_test(active_hyp, t)))
        continue;
    end
    gain = 0;
    for xt = [true false]
        cond_active_hyp = prune_hyp( active_hyp, hyp_test, t, xt );
        prob = length(cond_active_hyp) / length(active_hyp);
        m_new = marginal_f_drd(cond_active_hyp, hyp_subregion_set);
        gain = gain + prob*(m_new);
    end
    marginal_gain(t) = gain / test_cost(t);
end
[selected_gain, selected_test] = min(marginal_gain);


end

