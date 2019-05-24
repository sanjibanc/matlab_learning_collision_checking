%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function parent_pointer = extract_parent_pointer( decision_tree )
%EXTRACT_PARENT_POINTER Summary of this function goes here
%   Detailed explanation goes here

parent_pointer = zeros(1, size(decision_tree, 1));
for k = 1:size(decision_tree.tree, 2)
    child_vec = decision_tree.tree(:,k);
    id = find(child_vec > 0);
    parent_pointer(child_vec(id)) = id;
end

end

