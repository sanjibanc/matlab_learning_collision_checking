%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function edgeid = get_edgeid_from_edge( edge, G )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

edges = find(G);
edge_id_lookup = sparse(size(G,1), size(G,2));
edge_id_lookup(edges) = transpose(1:length(edges));
edgeid = full(edge_id_lookup(edge));


end