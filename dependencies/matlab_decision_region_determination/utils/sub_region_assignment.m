%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function hyp_sub_region = sub_region_assignment( hyp_region )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hyp_sub_region = zeros(size(hyp_region, 1), 2^(size(hyp_region, 2)));
hyp_sub_region(sub2ind(size(hyp_sub_region), 1:size(hyp_region,1), transpose(1+bi2de(hyp_region)))) = 1;
hyp_sub_region( :, ~any(hyp_sub_region,1) ) = [];  %columns

end

