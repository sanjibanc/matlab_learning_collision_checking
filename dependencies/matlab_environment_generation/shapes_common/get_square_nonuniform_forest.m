%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function square_array = get_square_nonuniform_forest( bbox, side, num_squares, pdf )
%GET_SQUARE_NONUINFORM_FOREST Creates a nonuniform forest of squares
%   bbox: bbox of the environment
%   side: side of vbox
%   num_squares: number of squares
%   pdf: probability distribution

square_array = [];
while(length(square_array) < num_squares)
    pt = random(pdf);
    if (pt(1) < bbox(1) || pt(1) > bbox(2) || pt(2) < bbox(3) || pt(2) > bbox(4))
        continue;
    end
    square_array = [square_array get_rectangle_shape(pt(1)-side*0.5, pt(2)-side*0.5, side, side)];
end

end