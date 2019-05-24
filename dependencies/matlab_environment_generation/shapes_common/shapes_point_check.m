%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function [ in_collision, min_distance, grad ] = shapes_point_check( point, shape_array )
%SHAPES_POINT_CHECK Checks whether a point is inside an array of shapes
%   point: 1xN coordinate for a query point
%   shape_array: array of shapes
%   in_collision: 0 if point is not in shape, 1 if it is in the shape
%   min_distance: distance to the shape (negative if inside)
%   grad: gradient to the closest side

in_collision = 0;
min_distance = Inf;
grad = zeros(size(point));
for shape = shape_array
    switch shape.name
       case 'rectangle'
           poly_x = [shape.data(1) shape.data(1)+shape.data(3) shape.data(1)+shape.data(3) shape.data(1)];
           poly_y = [shape.data(2) shape.data(2) shape.data(2)+shape.data(4) shape.data(2)+shape.data(4)];
           [dis, x_poly,y_poly] = p_poly_dist(point(1), point(2), poly_x, poly_y);
           if (dis == 0)
               point = point + eps*ones(size(point));
               [dis, x_poly,y_poly] = p_poly_dist(point(1), point(2), poly_x, poly_y);
           end
           if (dis < min_distance)
               min_distance = dis;
               grad(1) = sign(dis)*(point(1) - x_poly)/max(eps, abs(dis));
               grad(2) = sign(dis)*(point(2) - y_poly)/max(eps, abs(dis));
           end
           if (dis < 0)
               in_collision = 1;
           end
       case 'hypercube_axis_aligned'
           % data is 2xdim: 1st row is lower bound, 2nd row is width
           dis_all = [shape.data(1,:) - point; point - sum(shape.data(:,:))];
           [~,idx] = min(abs(dis_all));
           [dis, dim_idx] = max(dis_all(sub2ind(size(dis_all),idx,1:size(dis_all,2))));
           if (dis < min_distance)
               min_distance = dis;
               grad = zeros(size(point));
               grad(1, dim_idx) = 2*(idx(dim_idx) - 1.5);
           end
           if (dis < 0)
               in_collision = 1;
           end
       otherwise
        disp('invalid shape!!!');
    end
end


end

