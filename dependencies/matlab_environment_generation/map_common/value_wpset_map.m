%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function value = value_wpset_map( wpset, map )
%VALUE_WPSET_MAP Get set of values at a set of waypoints
%   wpset: Nx2 waypoint set, N is number of waypoints
%   map: default map struct
%   value: NX1 set of values
if (isempty(wpset))
    value = [];
    return
end
idx = world_wpset_to_grid( wpset, map );
value = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));

end

