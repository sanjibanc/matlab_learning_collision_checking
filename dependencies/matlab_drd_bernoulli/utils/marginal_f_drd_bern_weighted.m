%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = marginal_f_drd_bern_weighted(  test, outcome, selected_test_outcome, region_test, test_bias)
%F_DRD_BERN Summary of this function goes here
%   Detailed explanation goes here

region_status_old = get_region_status( selected_test_outcome, region_test, test_bias );

test_bias_init = test_bias;
if (~isempty(selected_test_outcome))
    test_bias_init(selected_test_outcome(:,1)) = selected_test_outcome(:,2)';
end

test_bias_final = test_bias_init;
test_bias_final(test) = outcome;

val1 = 1;
for i = 1:size(region_test,1)
    reg_val = (1 - prod(test_bias_init(region_test(i,:))));
    val1 = val1*reg_val*region_status_old(i);
end

val2 = 1;
for i = 1:size(region_test,1)
    reg_val = (1 - prod(test_bias_final(region_test(i,:))));
    val2 = val2*reg_val*region_status_old(i);
end

mult = ((( test_bias(test)^outcome )*(( 1 - test_bias(test))^(~outcome))))^(2*sum(region_test(:, test), 1));
val = val1 - val2*mult;

end
