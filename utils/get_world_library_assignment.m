%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function world_library_assignment = get_world_library_assignment( path_library, coll_check_results, G )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

path_edgeid_map = get_path_edgeid_map( path_library, G );
world_library_assignment = false(size(coll_check_results, 1), length(path_edgeid_map));
for i = 1:size(world_library_assignment,2)
    world_library_assignment(:,i) = ~any(~coll_check_results(:,path_edgeid_map{i}),2);
end

end

