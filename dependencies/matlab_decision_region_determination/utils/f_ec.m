%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = f_ec( active_hyp, hyp_region )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

val = 1 - weight_ec(active_hyp, hyp_region)/weight_ec(1:size(hyp_region,1), hyp_region);
%val = weight_ec(1:size(hyp_region,1), hyp_region) - weight_ec(active_hyp, hyp_region);
end

