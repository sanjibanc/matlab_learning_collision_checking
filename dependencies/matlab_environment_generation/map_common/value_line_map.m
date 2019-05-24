%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function value = value_line_map( p_start, p_end, map )
%VALUE_LINE_MAP Returns values along a line sampled along the map
%resolution
%   p_start: 1x2 start position 
%   p_end: 1x2 end position
%   map: map struct (refer to get_blank_map.m)
%   value: NX1 set of values where N is defined by map resolution

idx = world_line_to_grid( p_start, p_end, map );
value = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));

end

