%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function visualize_cost_map( map )
%VISUALIZE_MAP Visualize a cost map (where high values are expensive)
%   map: map struct

colormap(flipud(gray))
imagesc([map.origin(1) map.origin(1)+map.resolution*size(map.table,1)], [map.origin(2) map.origin(2)+map.resolution*size(map.table,2)], map.table');
axis xy;

end

