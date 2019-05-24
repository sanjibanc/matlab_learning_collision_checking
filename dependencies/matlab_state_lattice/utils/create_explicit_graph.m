%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ G, edge_traj_list, start_idx, goal_idx ] = create_explicit_graph( state_lattice, start, goal, bbox, hash_size )
%CREATE_EXPLICIT_GRAPH Summary of this function goes here
%   Detailed explanation goes here

start_node = state_lattice.stateToNode(start);
goal_node = state_lattice.stateToNode(goal);

%% Process
expanded_list = false(hash_size);
if (length(start) == 3)
    node_to_idx = @(node) sub2ind(size(expanded_list), mod(node(1), size(expanded_list,1))+1, mod(node(2), size(expanded_list,2))+1, mod(node(3), size(expanded_list,3))+1);
elseif (length(start) == 4)
    node_to_idx = @(node) sub2ind(size(expanded_list), mod(node(1), size(expanded_list,1))+1, mod(node(2), size(expanded_list,2))+1, mod(node(3), size(expanded_list,3))+1,  mod(node(4), size(expanded_list,4))+1);
end    
open_list = start_node;

if(length(start)<4)
    cost_fn = @(traj)  sum(sqrt(sum(diff(traj(:,1:2)).^2, 2)), 1);
else
    cost_fn = @(traj)  sum(sqrt(sum(diff(traj(:,[1 2 4])).^2, 2)), 1);
end
%%
id_node = zeros(size(expanded_list));
id = 1;
edge_traj_list = [];
while ~isempty(open_list)
    node_to_pop = open_list(1,:);
    expanded_list(node_to_idx(node_to_pop)) = true;
    open_list(1,:) = [];
    [succ_node, succ_traj] = state_lattice.getSuccessors(node_to_pop);
    for i = 1:size(succ_node,1)
        state = state_lattice.nodeToState(succ_node(i,:));
        if (length(bbox) == 4)
            if (state(1) < bbox(1) || state(1) > bbox(2) || state(2) < bbox(3) || state(2) > bbox(4))
                continue;
            end
        elseif (length(bbox) == 6)
            if (state(1) < bbox(1) || state(1) > bbox(2) || state(2) < bbox(3) || state(2) > bbox(4) || state(4) < bbox(5) || state(4) > bbox(6))
                continue;
            end
        end
        
        id1 = id_node(node_to_idx(node_to_pop));
        if (id1 == 0)
            id1 = id;
            id_node(node_to_idx(node_to_pop)) = id1;
            id = id +1;
        end
        
        id2 = id_node(node_to_idx(succ_node(i,:)));
        if (id2 == 0)
            id2 = id;
            id_node(node_to_idx(succ_node(i,:))) = id2;
            id = id +1;
        end
        
        traj = succ_traj{i};
        cost = cost_fn(traj);
        G(id1, id2) = cost;
        edge_traj_obj.id1 = id1;
        edge_traj_obj.id2 = id2;
        edge_traj_obj.cost = cost;
        edge_traj_obj.traj = traj;
        edge_traj_list = [edge_traj_list;edge_traj_obj];
        
        if (~expanded_list(node_to_idx(succ_node(i,:))))
            open_list = union(open_list, succ_node(i,:), 'rows');
        end
    end
end
G = sparse(G);

%% Trim of stuff
N = min(size(G));
parent_child_list = [[edge_traj_list.id1]' [edge_traj_list.id2]'];

edge_traj_list (parent_child_list(:,1) > N | parent_child_list(:,2) > N) = [];
G = G(1:N, 1:N);

%% Save
start_idx = id_node(node_to_idx(start_node));
goal_idx = id_node(node_to_idx(goal_node));

end

