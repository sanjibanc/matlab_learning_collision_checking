%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_decision_tree( decision_tree )
%PLOT_DECISION_TREE Summary of this function goes here
%   Detailed explanation goes here

hold on;
parent_pointer = extract_parent_pointer( decision_tree );
treeplot(parent_pointer);

end

