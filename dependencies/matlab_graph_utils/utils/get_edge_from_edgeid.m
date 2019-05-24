%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ edge, p, c ] = get_edge_from_edgeid( edge_id, G )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

edges = find(G);
edge = edges(edge_id);
[p, c] = ind2sub(size(G), edge);

end

