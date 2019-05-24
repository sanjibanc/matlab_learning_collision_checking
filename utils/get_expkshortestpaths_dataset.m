%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_library = get_expkshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, num_library  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

edges = find(G);
cost = full(G(edges));
edge_id_lookup = sparse(size(G,1), size(G,2));
edge_id_lookup(edges) = transpose(1:length(edges));
penalization_cost = 10; %tunable parameter

path_library = [];
for i = 1:num_library
    prob_free = transpose(sum(coll_check_results)/size(coll_check_results,1));
    expected_cost = prob_free.*cost + (1-prob_free)*penalization_cost;
    G(edges) = expected_cost;
    
    [~, path_set] = graphkshortestpaths(G, start_idx, goal_idx, num_library*10);
    for j = 1:length(path_set)
        is_path_new = 1;
        for k = 1:length(path_library)
            if (isequal(path_set{j}, path_library{k}))
                is_path_new = 0;
                break;
            end
        end
        if (is_path_new)
            path = path_set{j};
            % Lets prune
            path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
            cidx = full(edge_id_lookup(path_edges));
            sub_res = coll_check_results(:, cidx);
            coll_check_results = coll_check_results(any(~sub_res,2),:);
            
            if(nnz(~any(~sub_res,2)) == 0)
                continue;
            end
            if (~isempty(path))
                path_library{length(path_library)+1} = path;
                break;
            end
        end
    end
end
end

