%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_edgeid( edge_id, G, coord_set, col, lw )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 3)
    col = [0 1 0];
end
if (nargin <= 4)
    lw = 2;
end

hold on;
[ ~, p, c ] = get_edge_from_edgeid( edge_id, G );
plot(coord_set([p c], 1), coord_set([p c], 2), 'Color', col, 'LineWidth', lw);
end


