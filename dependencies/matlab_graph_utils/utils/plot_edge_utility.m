%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_edge_utility( edge_utility, graph, coord_set )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% plot stuff
candidate_tests = find(edge_utility > 0);
if (~isempty(candidate_tests))
    candidate_gain = edge_utility;
    candidate_gain(candidate_tests) = candidate_gain(candidate_tests) - min(candidate_gain(candidate_tests));
    if (max(candidate_gain) > min(candidate_gain))
        candidate_gain = candidate_gain / max(candidate_gain);
    else
        candidate_gain(candidate_tests) = 1.0;
    end
    
    for t = candidate_tests
        v = candidate_gain(t);
        plot_edgeid( t, graph, coord_set, get_color_interp(copper, v), 4 + v*4 );
    end
end

end

