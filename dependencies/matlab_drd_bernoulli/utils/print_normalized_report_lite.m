%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function print_normalized_report_lite( cumulative_cost_set, policy_set )
%PRINT_REPORT Summary of this function goes here
%   1x9 vector

prc_lb = 40;
prc_ub = 60;

mvp_idx = [1 2 3 4];
valid_id = any(diff(cumulative_cost_set(mvp_idx, :)));
cumulative_cost_set = cumulative_cost_set(:,valid_id);
cumulative_cost_set_new = cumulative_cost_set;
for i = 1:size(cumulative_cost_set, 1)
    cumulative_cost_set_new(i,:) = (cumulative_cost_set(i,:) - cumulative_cost_set(4,:))./cumulative_cost_set(4,:);
end
cumulative_cost_set = cumulative_cost_set_new;

fprintf('Confidence Intervals \n');
for i = 1:size(cumulative_cost_set, 1)
    name = func2str(policy_set{i});
    fprintf('Policy: %s \n', name);
    lb = prctile(cumulative_cost_set(i,:), prc_lb);
    ub = prctile(cumulative_cost_set(i,:), prc_ub);
    fprintf('Values: %f %f \n', lb, ub);
end

for i = 1:size(cumulative_cost_set, 1)
    name = func2str(policy_set{i});
    fprintf('Policy: %s \n', name);
    mean_val = mean(cumulative_cost_set(i,:));
    std_val = std(cumulative_cost_set(i,:));
    fprintf('Values: %f +- %f \n', mean_val, std_val);
end

end