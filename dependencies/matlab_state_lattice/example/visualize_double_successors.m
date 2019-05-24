%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Visualize cells
clc;
clear;
close all;

%% Select lattice
type = 2;

switch type
    case 1
        state_lattice = XYHAnalyticLattice(1, 2.0, 0.1, [0 0]);
    case 2
        state_lattice = XYHAnalyticLattice(2, 2.0, 0.1, [0 0]);
    case 3
        state_lattice = XYHAnalyticLattice(3, 0.075, 0.01, [0 0]);
end

%% Get edge list
[succ_node, edge_list] = state_lattice.getSuccessors([0 0 2]);

for i = 1:size(succ_node,1)
    node = succ_node(i,:);
    [~, new_edges] = state_lattice.getSuccessors(node);
    edge_list = [edge_list new_edges];
end

%% Plot all
figure;
hold on;
for i = 1:length(edge_list)
    plot(edge_list{i}(:,1), edge_list{i}(:,2));
end
