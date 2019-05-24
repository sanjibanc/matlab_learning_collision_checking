%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function shape = get_rectangle_shape(x,y,w,h)
%GET_RECTANGLE_SHAPE Creates a rectangle shape
%   x: x coordinate of lower corner
%   y: y coordinate of lower corner
%   w: xsize
%   h: ysize
%   shape: struct containing rectangle

shape = get_blank_shape();
shape.name = 'rectangle';
shape.data = [x y w h];

end

