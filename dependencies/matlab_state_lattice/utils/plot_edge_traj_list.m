%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_edge_traj_list( edge_traj_list, col )
%PLOT_EDGE_TRAJ_LIST Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 1)
    col = [0 0 1];
end
hold on;
for i = 1:size(edge_traj_list,1)
    plot(edge_traj_list(i).traj(:,1), edge_traj_list(i).traj(:,2), 'Color', col, 'LineWidth', 0.25);
end
end

