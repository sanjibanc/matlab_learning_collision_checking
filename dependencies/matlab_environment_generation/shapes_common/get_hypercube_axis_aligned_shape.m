%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function shape = get_hypercube_axis_aligned_shape(lb,width)
%GET_HYPERCUBE_AXIS_ALIGNED_SHAPE Creates a hypercube which is axis aligned
%   lb: 1xN coordinate of lower corner 
%   width: 1xN with of size of each dimension
%   shape: struct containing hypercube

shape = get_blank_shape();
shape.name = 'hypercube_axis_aligned';
shape.data = [lb; width];

end
