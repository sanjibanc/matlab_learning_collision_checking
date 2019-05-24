%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_library = get_greedpaths_dataset( coll_check_results, G, start_idx, goal_idx, max_size  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 4)
    max_size = Inf;
end

path_library = [];
for i = 1:size(coll_check_results,1)
    status = G;
    status(find(status)) = status(find(status)).*transpose(coll_check_results(i,:));
    if(~path_set_feasible( status, path_library ))
        [~, path] = graphshortestpath(status, start_idx, goal_idx);
        if (~isempty(path))
            path_library{length(path_library)+1} = path;
        end
    end
    if (length(path_library) >= max_size)
        break;
    end
end
end

