%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Load data
set_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_herb_1/');

G = load_graph( strcat(set_dataset,'graph.txt') );
load(strcat(set_dataset, 'world_library_assignment.mat'), 'world_library_assignment');
load(strcat(set_dataset, 'path_library.mat'), 'path_library');
%coll_check_results = dlmread( strcat(set_dataset, 'coll_check_results.txt') );
load( strcat(set_dataset, 'coll_check_results.mat'), 'coll_check_results' );

%% Extract relevant info
world_library_assignment = logical(world_library_assignment);
coll_check_results = logical(coll_check_results);
edge_check_cost = ones(1, size(coll_check_results,2)); %transpose(full(G(find(G)))); %
path_edgeid_map = get_path_edgeid_map( path_library, G );

%% Do a dimensionality reduction
if(isequal(tril(G), triu(G)))
    % Then its undirected and we assume the path forward is the path back
    % and can just check lower triangle of G leading to huge savings
    [ G, coll_check_results, edge_check_cost, path_edgeid_map ] = remove_redundant_edges( G,coll_check_results, edge_check_cost, path_edgeid_map  );
end


%% Load train id
load(strcat(set_dataset, 'train_id.mat'), 'train_id');
train_id = 1:1000;
train_world_library_assignment = world_library_assignment(train_id, :);
train_coll_check_results = coll_check_results(train_id, :);

%% Select a policy to create DRD
drd_policy = policyIncDRD(train_world_library_assignment, train_coll_check_results, edge_check_cost, path_edgeid_map, 5);
decision_tree_thresh = 0.05;

%% Create decision tree
% Initialize decision tree
root_data = drd_policy.get_decision_tree_data();
decision_tree = initialize_decision_tree (root_data, 2);
policy_node_set = struct('policy', drd_policy, 'node', 1);

while (~isempty(policy_node_set))
    policy_node_set_new = [];
    for policy_node = policy_node_set
        parent_node = policy_node.node;
        parent_data = get_data_from_decision_tree(parent_node, decision_tree);
        for outcome_id = [1 2]
            if (outcome_id == 1)
                outcome = false;
            else
                outcome = true;
            end
            policy = copy(policy_node.policy);
            policy.setOutcome(parent_data.selected_edge, outcome);
            
            [decision_tree, child_node] = add_child_to_decision_tree( decision_tree, parent_node, outcome_id, policy.get_decision_tree_data() );
            if (policy.active_prob() >= decision_tree_thresh)
                fprintf('Adding node %d Prob %f \n', child_node, policy.active_prob());
                policy_node_set_new = [policy_node_set_new struct('policy', policy, 'node', child_node)];
            end
        end
    end
    policy_node_set = policy_node_set_new; 
end

decision_tree_data.hyp_test = train_coll_check_results;
decision_tree_data.hyp_region = world_library_assignment;
decision_tree_data.decision_tree = decision_tree;

%save drd_decision_tree_data.mat decision_tree_data;
save(strcat(set_dataset, 'saved_decision_trees/drd_decision_tree_data.mat'), 'decision_tree_data');

%% Plot decision tree
figure;
plot_decision_tree(decision_tree_data.decision_tree);

