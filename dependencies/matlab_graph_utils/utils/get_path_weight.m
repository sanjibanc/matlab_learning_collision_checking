%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ path_weight ] = get_path_weight( G, path_edgeid_map )
%GET_PATH_WEIGHT Summary of this function goes here
%   Detailed explanation goes here

path_weight = zeros(1, length(path_edgeid_map));

for i = 1:length(path_edgeid_map)
    edges = get_edge_from_edgeid( path_edgeid_map{i}, G );
    path_weight(i) = sum(G(edges));
end

end

