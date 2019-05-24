%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_library_pruned = greedily_prune_library( path_library, coll_check_results, G, num_library )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 3 || num_library > length(path_library))
    num_library = length(path_library);
end
world_library_assignment = get_world_library_assignment( path_library, coll_check_results, G );
for i = 1:num_library
    [~, idx] = max(sum(world_library_assignment));
    if (nnz(world_library_assignment(:, idx)==1) == 0)
        break; % no point adding paths
    end 
    path_library_pruned{i} = path_library{idx};
    world_library_assignment(world_library_assignment(:, idx)==1,:) = [];
end

end

