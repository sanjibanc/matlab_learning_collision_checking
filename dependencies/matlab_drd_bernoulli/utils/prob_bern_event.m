%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function val = prob_bern_event( bias_vec, outcome_vec )
%PROB_BERN_EVENT Summary of this function goes here
%   Detailed explanation goes here

val = prod((bias_vec.^outcome_vec).*(1 - bias_vec).^(1-outcome_vec));

end

