%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function view_graph( G, coord_set )
%VIEW_GRAPH Summary of this function goes here
%   Detailed explanation goes here

G = tril(G);
[p, c] = ind2sub(size(G), find(G));
hold on;
plot([coord_set(p,1)'; coord_set(c,1)'], [coord_set(p,2)'; coord_set(c,2)'], 'color', [0.8 0.8 0.8]); 
scatter(coord_set(:,1), coord_set(:,2),30,'k', 'filled');
end

