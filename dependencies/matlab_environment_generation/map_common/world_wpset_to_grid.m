%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function idx = world_wpset_to_grid( wpset, map )
%WORLD_WPSET_TO_GRID Convert waypoint trajectory to idx set
%   wpset: Nx2 waypoint set, N is number of waypoints
%   map: default map struct
%   idx: Nx2 set of grid indices

idx = round((wpset-repmat(map.origin, [size(wpset,1) 1]))/map.resolution);
idx(:,1) = min(size(map.table,1), max(1, idx(:,1)));
idx(:,2) = min(size(map.table,2), max(1, idx(:,2)));

end

