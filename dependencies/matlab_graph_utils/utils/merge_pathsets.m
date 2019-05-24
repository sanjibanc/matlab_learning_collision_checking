%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path_set = merge_pathsets( path_set_1, path_set_2 )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

path_set = path_set_1;
for i = 1:length(path_set_2)
    if (isempty(path_set_2{i}))
        continue;
    end
    is_new = 1;
    for j = 1:length(path_set)
        if (isequal(path_set_2{i}, path_set{j}))
            is_new = 0;
            break;
        end
    end
    if (is_new)
        path_set{length(path_set)+1} = path_set_2{i};
    end
end

end

