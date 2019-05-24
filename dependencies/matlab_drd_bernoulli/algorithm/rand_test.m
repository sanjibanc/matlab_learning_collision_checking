%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function [ selected_test ] = rand_test( selected_test_outcome, region_test, test_bias, option )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if (~isempty(selected_test_outcome))
    candidate_test_set = setdiff(find(sum(region_test, 1)), selected_test_outcome(:,1)');
else
    candidate_test_set = find(sum(region_test, 1));
end

if (option == 1)
    region_status = get_region_status( selected_test_outcome, region_test, test_bias );
    [~, region_idx] = max(region_status);
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
elseif (option == 2)
    region_status = get_region_status( selected_test_outcome, region_test, test_bias );
    region_test = region_test(region_status > 0, :);
    region_status = region_status(region_status > 0);
    
    weight = exp(100*region_status);
    region_idx = find(mnrnd(1, weight/sum(weight), 1));
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
elseif (option == 3)
    region_status = get_region_status( selected_test_outcome, region_test, ones(1, size(region_test, 2)) );
    alive_regions = find(region_status > 0);
    region_idx = alive_regions(1);
    candidate_test_set =  intersect( find( region_test(region_idx, :) ), candidate_test_set);
end


selected_test = candidate_test_set(randi(length(candidate_test_set)));

end

