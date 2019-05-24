%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function print_report( cumulative_cost_set, policy_set )
%PRINT_REPORT Summary of this function goes here
%   Detailed explanation goes here

% if (size(cumulative_cost_set, 2) == 100)
%     prc_lb = 40;
%     prc_med = 50;
%     prc_ub = 60;
% else
%     error('Have to determine lb ub');
% end
% 
% fprintf('Confidence Intervals \n');
% for i = 1:size(cumulative_cost_set, 1)
%     name = func2str(policy_set{i});
%     fprintf('Policy: %s \n', name);
%     lb = prctile(cumulative_cost_set(i,:), prc_lb);
%     med = prctile(cumulative_cost_set(i,:), prc_med);
%     ub = prctile(cumulative_cost_set(i,:), prc_ub);
%     fprintf('Values: %f %f \n', lb, ub);
% end

for i = 1:size(cumulative_cost_set, 1)
    if (~isempty(policy_set))
        name = func2str(policy_set{i});
        fprintf('Policy: %s \n', name);
    end
    mean_val = mean(cumulative_cost_set(i,:));
    std_val = std(cumulative_cost_set(i,:));
    fprintf('Values: %f +- %f \n', mean_val, std_val);
end

end

