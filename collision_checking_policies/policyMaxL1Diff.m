%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyMaxL1Diff < CollisionCheckPolicy
    %POLICYDRD Vanilla DRD method to decide which policy to collision check
    % If test world is not from train world, this policy will not guarantee
    % that it will find a path should it exist. Refer to other extended
    % policies in such case
    properties
        region_test
        test_bias
        selected_test_outcome
        hyp_region
        hyp_test
        active_hyp
        mixing %0 means use only prior ... 1 means use 0.5
        update_posterior %true (update using collected data)
        is_max_prob
    end
    
    methods
        function self = policyMaxL1Diff(path_edgeid_map,  hyp_region, hyp_test, mixing, update_posterior, is_max_prob)
            self.region_test = false(length(path_edgeid_map), size(hyp_test,2));
            for i = 1:length(path_edgeid_map)
                for e = path_edgeid_map{i}
                    self.region_test(i, e) = true;
                end
            end
            self.hyp_region = hyp_region;
            self.hyp_test = hyp_test;
            self.active_hyp = 1:size(hyp_region, 1);
            self.mixing = mixing;
            self.update_posterior = update_posterior;
            self.is_max_prob = is_max_prob;
            self.selected_test_outcome = [];
            
            test_count = (1/size(self.hyp_test,1))*sum(self.hyp_test(self.active_hyp,:), 1);
            self.test_bias = (1 - self.mixing)*test_count + self.mixing*0.5*ones(1, size(self.hyp_test,2));
        end
        
        function edgeid = getEdgeToCheck(self) % Interface function
            if (length(self.active_hyp) >= 1)
                test_count = (1/length(self.active_hyp))*sum(self.hyp_test(self.active_hyp,:), 1);
            else
                test_count = 0.5*ones(1, size(self.hyp_test,2));
            end
            self.test_bias = (1 - self.mixing)*test_count + self.mixing*0.5*ones(1, size(self.hyp_test,2));
            edgeid = max_l1_diff( self.selected_test_outcome, self.region_test, self.test_bias, self.is_max_prob );
        end
        
        function setOutcome(self, selected_edge, outcome) %Interface function
            if (self.update_posterior)
                self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
            end
            self.selected_test_outcome = [self.selected_test_outcome; selected_edge outcome];
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
            % plot stuff
        end
        
        function printDebug(self)
            % Print anything for debugging
        end
    end
end
