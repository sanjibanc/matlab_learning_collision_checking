%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function membership = get_region_membership( active_hyp, hyp_region)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

membership =  [sum(hyp_region(active_hyp, :), 1) sum(~any(hyp_region(active_hyp, :), 2))];
end

