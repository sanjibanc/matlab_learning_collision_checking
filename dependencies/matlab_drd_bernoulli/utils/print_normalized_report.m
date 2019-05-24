%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function print_normalized_report( cumulative_cost_set, policy_set, mvp_idx, base_idx, print_median )
%PRINT_REPORT Summary of this function goes here
%   1x9 vector

if (nargin <= 2)
    mvp_idx = [4 6 7 9];
    base_idx = 9;
end
if (nargin <= 4)
    print_median = false;
end

prc_lb = 40;
prc_ub = 60;

if (~isempty(mvp_idx))
    valid_id = any(diff(cumulative_cost_set(mvp_idx, :)), 1);
    cumulative_cost_set = cumulative_cost_set(:,valid_id);
end
cumulative_cost_set_new = cumulative_cost_set;
for i = 1:size(cumulative_cost_set, 1)
    cumulative_cost_set_new(i,:) = (cumulative_cost_set(i,:) - cumulative_cost_set(base_idx,:))./cumulative_cost_set(base_idx,:);
end
cumulative_cost_set = cumulative_cost_set_new;

fprintf('Confidence Intervals \n');
for i = 1:size(cumulative_cost_set, 1)
    if (~isempty(policy_set))
        name = func2str(policy_set{i});
        fprintf('Policy: %s \n', name);
    end
    lb = prctile(cumulative_cost_set(i,:), prc_lb);
    ub = prctile(cumulative_cost_set(i,:), prc_ub);
    fprintf('Values: %f %f \n', lb, ub);
end

fprintf('Median \n');
if (print_median)
for i = 1:size(cumulative_cost_set, 1)
    if (~isempty(policy_set))
        name = func2str(policy_set{i});
        fprintf('Policy: %s \n', name);
    end
    lb = prctile(cumulative_cost_set(i,:), prc_lb);
    ub = prctile(cumulative_cost_set(i,:), prc_ub);
    med = prctile(cumulative_cost_set(i,:), 50);
    fprintf('Values: %f %f %f \n', lb, med, ub);
end

end


% fprintf('Mean \n');
% if (print_mean)
%     for i = 1:size(cumulative_cost_set, 1)
%         if (~isempty(policy_set))
%             name = func2str(policy_set{i});
%             fprintf('Policy: %s \n', name);
%         end
%         mean_val = mean(cumulative_cost_set(i,:));
%         std_val = std(cumulative_cost_set(i,:));
%         fprintf('Values: %f +- %f \n', mean_val, std_val);
%     end
% end

end