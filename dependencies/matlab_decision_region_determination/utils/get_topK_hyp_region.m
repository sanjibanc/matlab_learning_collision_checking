%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function top_regions = get_topK_hyp_region( hyp_region, k )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

top_regions = [];
for i = 1:k
    [~, idx] = max(sum(hyp_region));
    if (nnz(hyp_region(:, idx)==1) == 0)
        break; % no point adding paths
    end 
    top_regions = [top_regions idx];
    hyp_region(hyp_region(:, idx)==1,:) = [];
end

end

