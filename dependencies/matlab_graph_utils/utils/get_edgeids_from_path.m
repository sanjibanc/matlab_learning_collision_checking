%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function edge_ids = get_edgeids_from_path( path, G )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

edges = find(G);
edge_id_lookup = sparse(size(G,1), size(G,2));
edge_id_lookup(edges) = transpose(1:length(edges));

path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
edge_ids = full(edge_id_lookup(path_edges));


end

