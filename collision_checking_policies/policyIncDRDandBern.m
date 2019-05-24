%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyIncDRDandBern < CollisionCheckPolicy
    %POLICYDRD Vanilla DRD method to decide which policy to collision check
    % If test world is not from train world, this policy will not guarantee
    % that it will find a path should it exist. Refer to other extended
    % policies in such case
    properties
        active_hyp
        hyp_region
        hyp_subregion_set
        hyp_test
        test_cost
        num_active_region
        active_region
        selected_test_outcome
        region_test
        test_bias
        mixing %0 means use only prior ... 1 means use 0.5
        update_posterior
        switch_thresh
        test_gain
    end
    
    methods
        function self = policyIncDRDandBern(hyp_region, hyp_test, test_cost, k, path_edgeid_map, mixing, update_posterior, switch_thresh)
            self.active_hyp = 1:size(hyp_region, 1);
            self.hyp_region = hyp_region;
            self.hyp_test = hyp_test;
            self.test_cost = test_cost;
            self.selected_test_outcome = [];
            
            self.num_active_region = k;
            self.active_region = get_topK_hyp_region( self.hyp_region, self.num_active_region);
            self.hyp_subregion_set = create_subregion_set_direct( self.hyp_region(:, self.active_region) );
            
            self.mixing = mixing;
            self.update_posterior = update_posterior;
            self.switch_thresh = switch_thresh;
            self.region_test = false(length(path_edgeid_map), length(test_cost));
            for i = 1:length(path_edgeid_map)
                for e = path_edgeid_map{i}
                    self.region_test(i, e) = true;
                end
            end
            self.test_gain = zeros(1, size(self.hyp_test,2));
            
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
                [edgeid, ~, self.test_gain] = direct_drd( self.active_hyp, self.hyp_subregion_set, self.hyp_test, self.test_cost );
            else
                [edgeid, ~, self.test_gain] = direct_drd_bern(  self.selected_test_outcome, self.region_test, self.test_bias, self.test_cost, 1 );
            end
        end
        
        function setOutcome(self, selected_edge, outcome) %Interface function
            if (self.active_prob() > self.switch_thresh || self.update_posterior)
                self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
            end
            self.selected_test_outcome = [self.selected_test_outcome; selected_edge outcome];
            
            if (sum(sum(self.hyp_region(self.active_hyp, self.active_region), 1)) == 0)
                % No more active regions, get them agaion
                self.active_region = get_topK_hyp_region( self.hyp_region(self.active_hyp, :), self.num_active_region);
                if (~isempty(self.active_region))
                    self.hyp_subregion_set = create_subregion_set_direct( self.hyp_region(:, self.active_region) );
                end
            end
            
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
            % plot stuff
            if (self.active_prob() > self.switch_thresh)
                edge_likelihood = (1/length(self.active_hyp))*sum(self.hyp_test(self.active_hyp, :),1);
                plot_edge_likelihood(edge_likelihood, graph, coord_set);
            else
                plot_edge_utility(self.test_gain, graph, coord_set);
            end
            
        end
        
        function printDebug(self)
            % Print anything for debugging
            self.active_prob()
            if (self.active_prob > self.switch_thresh)
                membership = get_region_membership( self.active_hyp, self.hyp_region(:, self.active_region) )
            end
        end
        
        function prob = active_prob(self)
            prob = length(self.active_hyp)/size(self.hyp_region,1);
        end
    end
    
end

