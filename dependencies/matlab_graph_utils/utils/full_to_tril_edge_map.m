%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ old2new_edge_map ] = full_to_tril_edge_map( G )
%UNTITLED21 Summary of this function goes here
%   Detailed explanation goes here

G1 = tril(G);
edges = find(G1);
edge_id_lookup = sparse(size(G1,1), size(G1,2));
edge_id_lookup(edges) = transpose(1:length(edges));

[r, c] = ind2sub(size(G), find(G));
r1 = max(r,c);
c1 = min(r,c);
old2new_edge_map = edge_id_lookup(sub2ind(size(G1), r1, c1));

end

