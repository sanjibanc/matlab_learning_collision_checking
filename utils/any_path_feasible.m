%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [is_valid, path_id] = any_path_feasible( path_edgeid_map, selected_edge_outcome_matrix )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
is_valid = 0;
path_id = [];
valid_discovered_edges = selected_edge_outcome_matrix(logical(selected_edge_outcome_matrix(:,2)), 1);
for i = 1:length(path_edgeid_map)
    if (isempty(setdiff(path_edgeid_map{i}, valid_discovered_edges)))
        is_valid = 1;
        path_id = i;
        break;
    end
end

end

