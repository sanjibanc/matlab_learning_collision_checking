%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_library = get_kshortestpaths_dataset( coll_check_results, G, start_idx, goal_idx, k )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

path_library = [];
for i = 1:size(coll_check_results,1)
    i
    status = G;
    status(find(status)) = status(find(status)).*transpose(coll_check_results(i,:));
    %    status(find(status)) = transpose(coll_check_results(i,:));
    [~, path_set] = graphkshortestpaths(status, start_idx, goal_idx, k);
    if(~isempty(path_set))
        path_library = merge_pathsets( path_library, path_set );
        length(path_library)
    end
end

end

