%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ decision_tree ] = get_simple_binary_tree( depth )
%GET_SIMPLE_BINARY_TREE Summary of this function goes here
%   Detailed explanation goes here

data_packet = struct;
for i = 1:(2^depth-1)
    decision_tree.data(i) = data_packet;
end

decision_tree.tree = zeros(2^depth-1, 2);
decision_tree.tree(1:(2^(depth-1)-1),1) =  2*(1:(2^(depth-1)-1));
decision_tree.tree(1:(2^(depth-1)-1),2) = decision_tree.tree(1:(2^(depth-1)-1),1) + 1;
end

