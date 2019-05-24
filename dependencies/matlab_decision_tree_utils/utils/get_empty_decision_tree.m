%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ decision_tree ] = get_empty_decision_tree( N )
%GET_EMPTY_DECISION_TREE Summary of this function goes here
%   Returns an empty datastructure for interpretation purposes
%   N: number of nodes
%   struct containing two fields
%   data: 1xN struct array of data where data(node) gives the data-packet
%   for that node
%   tree: Nxk array representing the tree. tree(parent_node, outcome) returns the
%   child node when at parent_node and observing outcome. k is the number
%   of outcomes. No decision means an entry of 0. A leaf node has all 0
%   entries.


data_packet = struct;
for i = 1:N
    decision_tree.data(i) = data_packet;
end

decision_tree.tree = zeros(N, 2);

end

