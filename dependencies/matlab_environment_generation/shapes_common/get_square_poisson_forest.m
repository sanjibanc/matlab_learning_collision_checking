%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function square_array = get_square_poisson_forest( bbox, side, num_squares )
%GET_SQUARE_POISSON_FOREST Creates a poisson forest of squares
%   bbox: bbox of the environment
%   side: side of vbox
%   num_squares: number of squares

init_n = poissrnd(num_squares);
points = repmat([bbox(1) bbox(3)], init_n, 1) + repmat([bbox(2)-bbox(1) bbox(4)-bbox(3)], init_n, 1).*rand(init_n,2);
square_array = [];
%% Pad around start to goal
for i = 1:init_n
    square_array = [square_array get_rectangle_shape(points(i,1)-side*0.5, points(i,2)-side*0.5, side, side)];
end

end

