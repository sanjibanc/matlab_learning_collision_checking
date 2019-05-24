%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = weight_ec( active_hyp, hyp_region )
%WEIGHT_EC Summary of this function goes here
%   Detailed explanation goes here

if (isempty(active_hyp))
    val = 0;
    return;
end
num_hyp = size(hyp_region,1);
hyp_region = hyp_region(active_hyp, :);
p_region = sum(hyp_region, 1);
p_region = p_region / num_hyp;

val = 0.5*(sum(p_region)^2 - sum(p_region.^2));

end

