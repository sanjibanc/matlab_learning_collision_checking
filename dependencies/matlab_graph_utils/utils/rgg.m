%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ G, coord_set ] = rgg( bbox, N, eta )
%RGG A 2D RGG graph
%   G: is the (sparse) graph (NxN)
%   state_set: is (Nx2) set of 2d coord
%   bbox: [xmin xmax ymin ymax]
%   N: number of vertices

if (nargin <=2 )
    eta = 1;
end

radius = 2 * eta * ((1+0.5)^0.5) * (( (bbox(2) - bbox(1))*(bbox(4)-bbox(3))/pi )^0.5) * (( log(N) / N )^0.5);
coord_set = repmat([bbox(1) bbox(3)], [N, 1]) + rand(N,2).*repmat([bbox(2)-bbox(1) bbox(4)-bbox(3)],[N,1]);
G = squareform(pdist(coord_set));
G(G > radius) = 0;
G = sparse(G);
end

