%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function in_collision = shapes_coll_line_check( start, stop, shape_array )
%SHAPES_COLL_LINE_CHECK Check if a line is in collision with a shape
%   start: 1xN dimension point where line starts
%   stop: 1xN dimension point where line stops
%   shape_array: array of shapes
%   in_collision: 0 if line is free, 1 is in collision

in_collision = 0;
for shape = shape_array
    switch shape.name
       case 'rectangle'
           poly_x = [shape.data(1) shape.data(1)+shape.data(3) shape.data(1)+shape.data(3) shape.data(1)];
           poly_y = [shape.data(2) shape.data(2) shape.data(2)+shape.data(4) shape.data(2)+shape.data(4)];
           if (inpolygon(start(1), start(2), poly_x, poly_y) || inpolygon(stop(1), stop(2),poly_x, poly_y))
               in_collision = 1;
           else
              [xi, ~] = polyxpoly([start(1) stop(1)],[start(2) stop(2)], poly_x, poly_y);
              in_collision = ~isempty(xi);
           end
       otherwise
        disp('invalid shape!!!');
    end
    if (in_collision)
        break;
    end
end

end

