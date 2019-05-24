%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ region_outcome_weight ] = get_region_outcome_weight( selected_test_outcome, region_test, test_bias )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

outcome_weight = ones(size(test_bias));
if (~isempty(selected_test_outcome))
    candidate_tests = selected_test_outcome(:,1)';
    candidate_tests_true = candidate_tests(selected_test_outcome(:,2)' == 1);
    candidate_tests_false = candidate_tests(selected_test_outcome(:,2)' == 1);
    outcome_weight(candidate_tests_true) = test_bias(candidate_tests_true);
    outcome_weight(candidate_tests_false) = 1 - test_bias(candidate_tests_false);
end

region_status = zeros(size(region_test,1),1);
for i = 1:size(region_test,1)
    region_status(i) = prod(outcome_weight(region_test(i,:)));
end

end


