%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ mult_tot ] = drd_mult_factor( selected_test_outcome, test_bias, region_test )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

mult_tot = 1;
for i = 1:size(selected_test_outcome,1)
    test = selected_test_outcome(i,1);
    outcome = selected_test_outcome(i,2);
    mult = ((( test_bias(test)^outcome )*(( 1 - test_bias(test))^(~outcome))))^(2*sum(region_test(:, test), 1));
    mult_tot = mult_tot * mult;
end

end

