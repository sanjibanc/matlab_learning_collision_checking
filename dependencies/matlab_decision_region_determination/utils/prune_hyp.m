%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function active_hyp = prune_hyp( active_hyp, hyp_test, test, outcome )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
active_hyp = active_hyp(hyp_test(active_hyp,test) == outcome);

end

