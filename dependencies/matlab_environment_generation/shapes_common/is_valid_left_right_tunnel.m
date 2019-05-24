%% 
% Copyright (c) 2016 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%
function is_valid = is_valid_left_right_tunnel( vertical_disp, bbox, gap_clearance)
%GET_WALL_WITH_UNIFORM_GAP Creates a wall with uniform gaps

is_valid = vertical_disp(end) == (bbox(4)-bbox(3)) & ...
            all(vertical_disp(1:(end-1)) >= 0.51*gap_clearance ) & ...
            all(vertical_disp(1:(end-1)) <= 1- 0.51*gap_clearance ) & ...
            all(abs(diff(vertical_disp)) > 0.1*(bbox(4)-bbox(3)));
end