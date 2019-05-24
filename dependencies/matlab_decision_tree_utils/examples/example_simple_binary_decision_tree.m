%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Create a simple binary decision tree and plot it
clc;
clear;
close all;
rng(5);
%% Create simple binary decision tree
depth = 5;
decision_tree = get_simple_binary_tree(depth);

%% Plot 
figure;
plot_decision_tree(decision_tree);

%% Get decision stream
outcome_stream = randi(2, 1, 10); % get a outcome stream of 10 depth
node = 1; %start at root
counter = 1;
decision_trace = [];
while (node ~= 0)
    decision_trace = [decision_trace; node];
    outcome = outcome_stream(counter);
    child_node = get_decision( decision_tree, node, outcome );
    fprintf('Node: %d Outcome: %d NextNode: %d \n', node, outcome, child_node);
    node = child_node;
    counter  = counter + 1;
end

figure;
plot_decision_trace_and_tree( decision_trace, decision_tree );