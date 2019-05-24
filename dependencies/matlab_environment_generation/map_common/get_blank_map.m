%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ map ] = get_blank_map()
%GET_BLANK_MAP Defines a simple map structure but it contains nothing
%   map is a struct with the following fields
%   :   table - MXN table where (x,y) is (rows, column)
%   :   resolution - 1 pixel equals resolution world distance
%   :   origin - 1X2 storing the x,y world coord corresponding to [1, 1]
map = struct('table', [], 'resolution', 0, 'origin', [0 0]);



end

