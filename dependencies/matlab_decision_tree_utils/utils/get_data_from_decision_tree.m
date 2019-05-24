%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function data = get_data_from_decision_tree( node, decision_tree )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

data = decision_tree.data(node);

end

