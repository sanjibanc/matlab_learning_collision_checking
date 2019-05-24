%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function path = get_dubins_path( start, goal, radius, res )
%GET_DUBINS_TRAJ Summary of this function goes here
%   Detailed explanation goes here

path = dubins_curve(start, goal, radius, res);

end

