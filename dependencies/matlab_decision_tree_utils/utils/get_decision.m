%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ child_node, child_data ] = get_decision( decision_tree, parent_node, outcome )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if (parent_node <=0 || parent_node > size(decision_tree.tree, 1))
    error('non-existent parent');
elseif (outcome <=0 || outcome > size(decision_tree.tree, 2))
    error('outcome is invalid');
end

child_node = decision_tree.tree(parent_node, outcome);
if (child_node == 0)
    child_data = [];
else
    child_data = decision_tree.data(child_node);
end

end

