%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function connected = check_coll_wpset_map( wpset, map )
%CHECK_COLL_WPSET_MAP Check collision of a wpset on a map
%   wpset: Nx2 waypoint set, N is number of waypoints
%   map: default map struct
%   connected: 1 if free, 0 if not
c = value_wpset_map( wpset, map );

if (any(~c))
    connected = 0;
else
    connected = 1;
end


end

