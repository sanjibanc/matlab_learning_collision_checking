%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function visualize_value( map, clim, cmap )
%VISUALIZE_VALUE Visualize a value function
%   map: map containing values
%   clim: refer to imagesc
%   cmap: refer to imagesc

colormap(jet)
if (nargin < 2)
    colormap(jet);
    imagesc([map.origin(1) map.resolution*size(map.table,1)], [map.origin(2) map.resolution*size(map.table,2)], map.table');
else
    colormap(cmap);
    imagesc([map.origin(1) map.resolution*size(map.table,1)], [map.origin(2) map.resolution*size(map.table,2)], map.table', clim);
end
axis xy;

end

