%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function decision_tree = prune_decision_tree_by_criteria( decision_tree, is_leaf_node_fn )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

nodes_to_be_pruned = [];
for i = 1:size(decision_tree.tree,1)
    if (is_leaf_node_fn(decision_tree.data(i)))
        nodes_to_be_pruned = union(nodes_to_be_pruned, decision_tree.tree(i, :));
        decision_tree.tree(i,:) = zeros(1, size(decision_tree.tree,2));
    end
end

nodes_to_be_pruned = setdiff(nodes_to_be_pruned, 0);
decision_tree.tree(nodes_to_be_pruned, :) = [];
decision_tree.data(nodes_to_be_pruned) = [];

end

