%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function feasibility_vector = path_set_feasible_vector( G, path_set )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

feasibility_vector = zeros(1, length(path_set));
for i = 1:length(path_set)
    path = path_set{i};
    path_edges = sub2ind(size(G), path(1:(end-1)), path(2:end));
    feasibility_vector(i) = all(full(G(path_edges)));
end

end