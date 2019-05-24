%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function idx = world_line_to_grid( p_start, p_end, map )
%WORLD_LINE_TO_GRID Converts a line to grid ids by sampling at resolution
%   p_start: 1x2 start position 
%   p_end: 1x2 end position
%   map: map struct (refer to get_blank_map.m)
%   idx: NX2 set of grid indices where N is defined by map resolution

alpha = linspace(0, 1, 2 + floor(norm(p_end - p_start)/map.resolution))';
traj = repmat(p_start, [length(alpha), 1]).*repmat(alpha, [1 length(p_start)]) + repmat(p_end, [length(alpha), 1]).*repmat(1-alpha, [1 length(p_end)]);
idx = round((traj-repmat(map.origin, [size(traj,1) 1]))/map.resolution);

idx(:,1) = min(size(map.table,1), max(1, idx(:,1)));
idx(:,2) = min(size(map.table,2), max(1, idx(:,2)));

end

