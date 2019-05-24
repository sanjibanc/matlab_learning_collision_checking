%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = f_drd_bern(  selected_test_outcome, region_test, test_bias)
%F_DRD_BERN Summary of this function goes here
%   Detailed explanation goes here

actual_test_bias = test_bias;
mult = 1;
if (~isempty(selected_test_outcome))
    actual_test_bias(selected_test_outcome(:,1)) = selected_test_outcome(:,2)';
    
    for i = 1:size(selected_test_outcome, 1)
        test = selected_test_outcome(i,1);
        outcome = selected_test_outcome(i,2);
        mult = mult*( ((( test_bias(test)^outcome )*(( 1 - test_bias(test))^(~outcome))))^(2*sum(region_test(:, test), 1)) );
    end
    %mult = mult^(2*size(region_test,1));
end

val = 1;
for i = 1:size(region_test,1)
    denom = 1 - prod(test_bias(region_test(i,:)));
    num = 1 - prod(actual_test_bias(region_test(i,:)));
    val = val*(num / denom);
end

val = mult*val;
end

