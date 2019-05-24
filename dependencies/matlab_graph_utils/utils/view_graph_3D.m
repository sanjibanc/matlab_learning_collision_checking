%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function view_graph_3D( G, coord_set )
%VIEW_GRAPH Summary of this function goes here
%   Detailed explanation goes here

G = tril(G);
[p, c] = ind2sub(size(G), find(G));
hold on;
plot3([coord_set(p,1)'; coord_set(c,1)'], [coord_set(p,2)'; coord_set(c,2)'], [coord_set(p,3)'; coord_set(c,3)'], 'color', [0.4 0.4 0.4]); 
%scatter3(coord_set(:,1), coord_set(:,2),  coord_set(:,3), 30,'k', 'filled');
end
