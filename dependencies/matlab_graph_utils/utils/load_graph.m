%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function G = load_graph( filename )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(filename, 'r');
num_vertices = textscan(fid, 'NumVertices: %d');
num_edges = textscan(fid, 'NumEdges: %d');
G = sparse(double(num_vertices{1}), double(num_vertices{1}));
raw_graph = textscan(fid,'%d %d %d %f\n');
for i = 1:double(num_edges{1})
    G(double(raw_graph{2}(i)), double(raw_graph{3}(i))) = raw_graph{4}(i);
end
fclose(fid);

end

