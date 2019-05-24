%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = marginal_drd_onevall( active_hyp, hyp_region )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
val = 1;
for i = 1:size(hyp_region, 2)
    val = val * (1 - f_ec_onevall(active_hyp, hyp_region(:,i)));
end
end

function val = f_ec_onevall( active_hyp, hyp_region_vec )
val = 1 - weight_ec_onevall(active_hyp, hyp_region_vec)/weight_ec_onevall(1:size(hyp_region_vec,1), hyp_region_vec);
end

function val = weight_ec_onevall( active_hyp, hyp_region_vec )
if (isempty(active_hyp))
    val = 0;
    return;
end
num_hyp = size(hyp_region_vec,1);
hyp_region_vec = hyp_region_vec(active_hyp, :);
a = sum(hyp_region_vec, 1);
b = length(active_hyp) - a;
val = (1/num_hyp^2)*0.5*((a+b)^2 - a^2 - b);
end

