%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_map_graph_edge_outcome( map, G, coord_set, selected_edge_outcome_matrix )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% visualize_map(map);
% view_graph( G, coord_set );
for i = 1:size(selected_edge_outcome_matrix,1)
    if (selected_edge_outcome_matrix(i,2)==1)
        col = [0 1 0];
    else
        col = [1 0 0];
    end
    plot_edgeid( selected_edge_outcome_matrix(i,1), G, coord_set, col, 4 );
end
end

