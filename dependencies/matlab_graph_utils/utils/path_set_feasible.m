%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function any_feasible = path_set_feasible( G, path_set )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

any_feasible = 0;
for i = 1:length(path_set)
    path = path_set{i};
    path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
    if(all(full(G(path_edges))))
        any_feasible = 1;
        break;
    end
end

end

