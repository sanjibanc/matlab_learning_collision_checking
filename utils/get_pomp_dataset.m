%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_library = get_pomp_dataset( coll_check_results, G, start_idx, goal_idx, k )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

prob_free = max(0.1, transpose(sum(coll_check_results)/size(coll_check_results,1)));
negLogP = -log(prob_free);
lambda = linspace(0, 10, k);
path_library = [];
for i = 1:k
    i
    status = G;
    status(find(status)) = 1 + lambda(i)*negLogP;
    %    status(find(status)) = transpose(coll_check_results(i,:));
    [~, path_set] = graphkshortestpaths(status, start_idx, goal_idx, 2);
    if(~isempty(path_set))
        path_library = merge_pathsets( path_library, path_set );
        length(path_library)
    end
end

end

