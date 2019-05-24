%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

clc;
clear;
close all;

%% Load data
set_dataset = strcat(getenv('collision_checking_dataset_folder'), '/dataset_2d_1/');

G = load_graph( strcat(set_dataset,'graph.txt') );
load(strcat(set_dataset, 'world_library_assignment.mat'), 'world_library_assignment');
load(strcat(set_dataset, 'path_library.mat'), 'path_library');
load( strcat(set_dataset, 'coll_check_results.mat'), 'coll_check_results' );

%% Extract relevant info
world_library_assignment = logical(world_library_assignment);
coll_check_results = logical(coll_check_results);
edge_check_cost = ones(1, size(coll_check_results,2)); %transpose(full(G(find(G)))); %ones(1, size(coll_check_results,2));
%edge_check_cost = transpose(full(G(find(G)))); %ones(1, size(coll_check_results,2));

path_edgeid_map = get_path_edgeid_map( path_library, G );

%% Do a dimensionality reduction
if(isequal(tril(G), triu(G)))
    % Then its undirected and we assume the path forward is the path back
    % and can just check lower triangle of G leading to huge savings
    [ G, coll_check_results, edge_check_cost, path_edgeid_map ] = remove_redundant_edges( G,coll_check_results, edge_check_cost, path_edgeid_map  );
end

%% Load train test id
load(strcat(set_dataset, 'train_id.mat'), 'train_id');
load(strcat(set_dataset, 'test_id.mat'), 'test_id');

train_world_library_assignment = world_library_assignment(train_id, :);
train_coll_check_results = coll_check_results(train_id, :);

%% Create a policy set
set = 1;
policy_set = {};
switch set
    case 1
        % LazySP
        policy_set{length(policy_set)+1} = @() policyLazySP(path_edgeid_map, train_world_library_assignment, train_coll_check_results, G, 0.01, 0);
        % LazySP + MaxProbReg
        policy_set{length(policy_set)+1} = @() policyLazySP(path_edgeid_map, train_world_library_assignment, train_coll_check_results, G, 0.01, 1);
        % Random
        policy_set{length(policy_set)+1} = @() policyRandomEdge(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false, 0);
        % Random + MaxProbReg
        policy_set{length(policy_set)+1} = @() policyRandomEdge(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false, 1);
        % MaxTally
        policy_set{length(policy_set)+1} = @() policyMaxTallyEdge(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false, 0);
        % MaxTally + MaxProbReg
        policy_set{length(policy_set)+1} = @() policyMaxTallyEdge(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false, 1);
        % MaxSetCover
        policy_set{length(policy_set)+1} = @() policyMaxSetCover(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false, 0);
        % MaxSetCover + MaxProbReg
        policy_set{length(policy_set)+1} = @() policyMaxSetCover(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false, 1);
        % MVOI
        policy_set{length(policy_set)+1} = @() policyMaxMVOI(path_edgeid_map, train_world_library_assignment, train_coll_check_results, 0.01, false);
        % BISECT
        policy_set{length(policy_set)+1} = @() policyDRDBernoulli(path_edgeid_map, edge_check_cost, train_world_library_assignment, train_coll_check_results, 0.01, false, 0); 
        % BISECT + MaxProbReg
        policy_set{length(policy_set)+1} = @() policyDRDBernoulli(path_edgeid_map, edge_check_cost, train_world_library_assignment, train_coll_check_results, 0.01, false, 1); 
    case 2
        % DIRECT + BISECT
        load(strcat(set_dataset, 'saved_decision_trees/drd_decision_tree_data.mat'), 'decision_tree_data');
        policy_set{length(policy_set)+1} = @() policyDecisionTreeandBern(decision_tree_data, path_edgeid_map, edge_check_cost, 0.01, false, 0.2);
end

%% Perform stuff
cumulative_cost_set = zeros(length(policy_set), length(test_id));
for i = 1:length(policy_set)
    parfor j = 1:length(test_id)
        policy_fn = policy_set{i};
        policy = policy_fn();
        test_world = test_id(j);
        selected_edge_outcome_matrix = [];
        while (1)
            selected_edge = policy.getEdgeToCheck(); % Call policy to select edge
            if (isempty(selected_edge))
                error('No valid selection made'); % Invalid selection made
            end
            
            outcome = coll_check_results(test_world, selected_edge); %Observe outcome
            policy.setOutcome(selected_edge, outcome); %Set outcome to policy
            selected_edge_outcome_matrix = [selected_edge_outcome_matrix; selected_edge outcome]; %Update event matrixx
            
            if (any_path_feasible( path_edgeid_map, selected_edge_outcome_matrix ))
                break;
            end
        end
        cumulative_cost_set(i, j) = sum(edge_check_cost(selected_edge_outcome_matrix(:,1)));
        fprintf('Policy: %d Test: %d Cost of check: %f \n', i, j, cumulative_cost_set(i, j));
    end
end
