%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = marginal_f_drd( active_hyp, hyp_subregion_set )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

val = 1;
for i = 1:length(hyp_subregion_set)
    val = val * (1 - f_ec(active_hyp, hyp_subregion_set{i}));
end


end
