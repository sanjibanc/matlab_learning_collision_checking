%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

%% Manually create a decision tree and plot it
clc;
clear;
close all;

%% Create a binary decision tree
decision_tree = initialize_decision_tree (0.5, 2);
decision_tree = add_child_to_decision_tree( decision_tree, 1, 1, 0.4 );
decision_tree = add_child_to_decision_tree( decision_tree, 1, 2, 0.3 );
decision_tree = add_child_to_decision_tree( decision_tree, 2, 1, 0.15 );
decision_tree = add_child_to_decision_tree( decision_tree, 2, 2, 0.19 );
decision_tree = add_child_to_decision_tree( decision_tree, 4, 1, 0.07 );
decision_tree = add_child_to_decision_tree( decision_tree, 5, 1, 0.07 );
decision_tree = add_child_to_decision_tree( decision_tree, 3, 1, 0.11 );
decision_tree = add_child_to_decision_tree( decision_tree, 3, 2, 0.05 );
decision_tree = add_child_to_decision_tree( decision_tree, 6, 2, 0.02 );
decision_tree = add_child_to_decision_tree( decision_tree, 7, 1, 0.03 );
decision_tree = add_child_to_decision_tree( decision_tree, 7, 2, 0.04 );
decision_tree = add_child_to_decision_tree( decision_tree, 9, 2, 0.01 );

%% Plot 
figure;
plot_decision_tree(decision_tree);

%% Prune it
is_leaf_node_fn= @(data) data < 0.1;
pruned_decision_tree = prune_decision_tree_by_criteria( decision_tree, is_leaf_node_fn );
figure;
plot_decision_tree(pruned_decision_tree);

%% Get decision stream
outcome_stream = [1 2 1 2 1];
node = 1; %start at root
counter = 1;
decision_trace = [];
while (node ~= 0 && counter <= length(outcome_stream))
    decision_trace = [decision_trace; node];
    outcome = outcome_stream(counter);
    child_node = get_decision( decision_tree, node, outcome );
    fprintf('Node: %d Data: %f Outcome: %d NextNode: %d \n', node, get_data_from_decision_tree(node, decision_tree), outcome, child_node);
    node = child_node;
    counter  = counter + 1;
end

figure;
plot_decision_trace_and_tree( decision_trace, decision_tree );