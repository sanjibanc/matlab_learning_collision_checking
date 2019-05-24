%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ region_status ] = get_region_status( selected_test_outcome, region_test, test_bias )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

actual_test_bias = test_bias;
if (~isempty(selected_test_outcome))
    actual_test_bias(selected_test_outcome(:,1)) = selected_test_outcome(:,2)';
end
region_status = zeros(size(region_test,1),1);
for i = 1:size(region_test,1)
    region_status(i) = prod(actual_test_bias(region_test(i,:)));
end

end

