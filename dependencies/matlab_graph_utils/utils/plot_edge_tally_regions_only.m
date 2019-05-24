%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

function plot_edge_tally_regions_only( graph, coord_set, region_test )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

tally = sum(region_test, 1);
relevant_test = find(sum(region_test, 1) > 0);
% plot stuff
candidate_tests = find(tally > 1e-3);
candidate_tests = intersect(candidate_tests, relevant_test);
 cmap = flipud(cool);
% cmap = cmap(0.5*size(cmap,1):end, :);
%cmap = spring;
if (~isempty(candidate_tests))
    candidate_gain = tally / max(tally);    
    for t = candidate_tests
        v = candidate_gain(t);
        plot_edgeid( t, graph, coord_set, get_color_interp(cmap, v), 1+4*v );
    end
end

end
