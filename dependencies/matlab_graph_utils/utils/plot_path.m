%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_path( path, coord_set, col, lw )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if(nargin <= 2)
    col = 'b';
end
if(nargin <= 3)
    lw = 2;
end
hold on;
plot(coord_set(path, 1), coord_set(path, 2), 'Color', col, 'LineWidth', lw);
end

