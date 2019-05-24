%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ traj, traj_fn, poly ] = get_cubic_interp( bvp )
%GET_CUBIC_INTERP Summary of this function goes here
%   Detailed explanation goes here

A = [0 0 0 1;
     0 0 1 0;
     1 1 1 1;
     3 2 1 0];

poly = A \ bvp;

traj_fn = @(s) poly'*[s.^3; s.^2; s; ones(size(s))];

traj = traj_fn(linspace(0, 1, 100));

end

