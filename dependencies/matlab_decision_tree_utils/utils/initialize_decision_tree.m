%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function decision_tree = initialize_decision_tree( root_data, num_outcomes )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

decision_tree.data(1) = root_data;
decision_tree.tree = zeros(1, num_outcomes);

end

