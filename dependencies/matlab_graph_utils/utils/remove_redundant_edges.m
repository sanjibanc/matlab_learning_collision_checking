%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ Gnew, coll_check_results_new, edge_check_cost_new, path_edgeid_map_new, region_test_new ] = remove_redundant_edges( G,coll_check_results, edge_check_cost, path_edgeid_map, region_test  )
%UNTITLED22 Summary of this function goes here
%   Detailed explanation goes here

Gnew = tril(G);
old2new_edge_map = full_to_tril_edge_map( G );
% change coll_check_results, edge_check_cost, path_edgeid_map

coll_check_results_new = false(size(coll_check_results, 1), full(max(old2new_edge_map)));
for i = 1:size(coll_check_results, 1)
    coll_check_results_new(i, old2new_edge_map(coll_check_results(i, :))) = true;
end

edge_check_cost_new = zeros(1, full(max(old2new_edge_map)));
edge_check_cost_new(old2new_edge_map) = edge_check_cost;

for i = 1:length(path_edgeid_map)
    path_edgeid_map_new{i} = transpose(full(old2new_edge_map(path_edgeid_map{i})));
end

if (nargin > 4)
    region_test_new = false(size(region_test, 1), full(max(old2new_edge_map)));
    for i = 1:size(region_test, 1)
        region_test_new(i, old2new_edge_map(region_test(i, :))) = true;
    end    
end

end

