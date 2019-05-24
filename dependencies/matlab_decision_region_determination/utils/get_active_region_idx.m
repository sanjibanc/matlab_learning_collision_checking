%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function active_region_idx = get_active_region_idx( active_hyp, hyp_region)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

region_idx = 1:size(hyp_region,2);
active_region_idx = region_idx(sum(hyp_region(active_hyp, :), 1) > 0);

end

