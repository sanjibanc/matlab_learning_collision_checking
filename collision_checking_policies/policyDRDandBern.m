%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyDRDandBern < CollisionCheckPolicy
    %POLICYDRD Vanilla DRD method to decide which policy to collision check
    % If test world is not from train world, this policy will not guarantee
    % that it will find a path should it exist. Refer to other extended
    % policies in such case
    properties
        active_hyp
        hyp_region
        hyp_test
        test_cost
        selected_test_outcome
        region_test
        test_bias
        mixing %0 means use only prior ... 1 means use 0.5
        update_posterior
        switch_thresh
    end
    
    methods
        function self = policyDRDandBern(hyp_region, hyp_test, test_cost, path_edgeid_map, mixing, update_posterior, switch_thresh)
            self.active_hyp = 1:size(hyp_region, 1);
            self.hyp_region = hyp_region;
            self.hyp_test = hyp_test;
            self.test_cost = test_cost;
            self.selected_test_outcome = [];
            
            self.mixing = mixing;
            self.update_posterior = update_posterior;
            self.switch_thresh = switch_thresh;
            self.region_test = false(length(path_edgeid_map), length(test_cost));
            for i = 1:length(path_edgeid_map)
                for e = path_edgeid_map{i}
                    self.region_test(i, e) = true;
                end
            end
            
            test_count = (1/size(self.hyp_test,1))*sum(self.hyp_test(self.active_hyp,:), 1);
            self.test_bias = (1 - self.mixing)*test_count + self.mixing*0.5*ones(1, length(self.test_cost));
        end
        
        function edgeid = getEdgeToCheck(self) % Interface function
            % update bias
            if (length(self.active_hyp) >= 1)
                test_count = (1/length(self.active_hyp))*sum(self.hyp_test(self.active_hyp,:), 1);
            else
                test_count = 0.5*ones(1, length(self.test_cost));
            end
            
            self.test_bias = (1 - self.mixing)*test_count + self.mixing*0.5*ones(1, length(self.test_cost));
            
            if (self.active_prob() > self.switch_thresh)
                edgeid = direct_drd_onevall( self.active_hyp, self.hyp_region, self.hyp_test, self.test_cost );
            else
                edgeid = direct_drd_bern(  self.selected_test_outcome, self.region_test, self.test_bias, self.test_cost, 1 );
            end
        end
        
        function setOutcome(self, selected_edge, outcome) %Interface function
            if (self.active_prob() > self.switch_thresh || self.update_posterior)
                self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
            end
            self.selected_test_outcome = [self.selected_test_outcome; selected_edge outcome];
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
            % plot stuff
        end
        
        function printDebug(self)
            % Print anything for debugging
            self.active_prob()
            if (self.active_prob > self.switch_thresh)
                membership = get_region_membership( self.active_hyp, self.hyp_region )
            end
        end
        
        function prob = active_prob(self)
            prob = length(self.active_hyp)/size(self.hyp_region,1);
        end
    end
    
end

