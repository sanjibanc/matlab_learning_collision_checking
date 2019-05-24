%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [decision_tree, child_node] = add_child_to_decision_tree( decision_tree, parent_node, outcome, child_data )
%ADD_CHILD_TO_DECISION_TREE Summary of this function goes here
%   Detailed explanation goes here

if (parent_node <=0 || parent_node > size(decision_tree.tree, 1))
    error('adding child to a non-existent parent');
elseif (outcome <=0 || outcome > size(decision_tree.tree, 2))
    error('outcome is invalid');
end
% Update tree
decision_tree.tree = [decision_tree.tree; zeros(1, size(decision_tree.tree,2))];
child_node = size(decision_tree.tree, 1);
decision_tree.tree(parent_node, outcome) = child_node;
% Update data
decision_tree.data(child_node) = child_data;
end

