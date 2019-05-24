%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function hyp_subregion_set = create_subregion_set_direct( hyp_region )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

count = 1;
for i = 1:size(hyp_region,2)
    reg_assign = hyp_region(:,i);
    if(any(reg_assign))
        % non zero memebership to region, worth adding
        pruned_hyp_region = hyp_region;
        pruned_hyp_region(reg_assign, 1:size(hyp_region,2) ~= i) = 0;
        hyp_subregion = sub_region_assignment( pruned_hyp_region );
        hyp_subregion_set{count} = hyp_subregion;
        count = count+1;
    end
end

% For null membership
no_reg_assign = (sum(hyp_region, 2) == 0);
if(any(no_reg_assign))
    hyp_subregion = sub_region_assignment( hyp_region );
    hyp_subregion_set{count} = hyp_subregion;
    count = count+1;
end

