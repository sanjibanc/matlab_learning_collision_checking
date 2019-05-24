%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_edgeid_map = get_path_edgeid_map( path_library, G )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

edges = find(G);
edge_id_lookup = sparse(size(G,1), size(G,2));
edge_id_lookup(edges) = transpose(1:length(edges));
for i = 1:length(path_library)
    path = path_library{i};
    path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
    test_set = full(edge_id_lookup(path_edges));
    path_edgeid_map{i} = test_set;
end

end

