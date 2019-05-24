%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function visualize_shapes( shape_array )
%VISUALIZE_SHAPES Visualize the shape array

hold on;
for shape = shape_array
    switch shape.name
        case 'rectangle'
            rectangle('Position',shape.data,'FaceColor','k');
        otherwise
            disp('invalid shape!!!');
    end
end

end

