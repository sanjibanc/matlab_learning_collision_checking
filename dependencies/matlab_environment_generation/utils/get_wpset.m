%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function xi = get_wpset( p_start, p_goal, n )
%GET_WPSET Create a discretized waypoint trajectory between two points 
%   p_start: 1xN set of waypoints denoting start
%   p_goa: 1xN set of waypoints denoting end
%   n: number of waypoints

d = norm(p_goal - p_start);
di = linspace(0,d,n);
xi = interp1([0 d],[p_start; p_goal],di);

end

