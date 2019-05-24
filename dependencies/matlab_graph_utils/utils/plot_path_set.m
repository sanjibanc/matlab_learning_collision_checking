%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_path_set( path_set, coord_set )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hold on;
cc = hsv(length(path_set));
for i = 1:length(path_set)
    plot(coord_set(path_set{i}, 1), coord_set(path_set{i}, 2), 'color', cc(i,:), 'LineWidth', 2);
end

end

