%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function save_graph( filename, G )
%SAVE_GRAPH Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(filename, 'w');
fprintf(fid, 'NumVertices: %d\n', size(G,1));
fprintf(fid, 'NumEdges: %d\n', nnz(G));
[p, c] = ind2sub(size(G), find(G));
for i = 1:nnz(G)
    fprintf(fid, '%d %d %d %f\n', i, p(i), c(i), full(G(p(i), c(i))));
end
fclose(fid);
end

