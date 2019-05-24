%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyDRD < CollisionCheckPolicy
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
        region_test
        performed_test_set
        flag_done
        latched_region
    end
    
    methods
        function self = policyDRD(hyp_region, hyp_test, test_cost, region_test)
            self.active_hyp = 1:size(hyp_region, 1);
            self.hyp_region = hyp_region;
            self.hyp_subregion_set = create_subregion_set_direct( hyp_region );
            self.hyp_test = hyp_test;
            self.test_cost = test_cost;
            self.region_test = region_test;
            self.performed_test_set = [];
            self.flag_done = 0;
            self.latched_region = [];
        end
        
        function edgeid = getEdgeToCheck(self) % Interface function
            edgeid = [];
            if (~self.flag_done)
                edgeid = direct_drd( self.active_hyp, self.hyp_subregion_set, self.hyp_test, self.test_cost );
                if (isempty(edgeid))
                    self.setLatchedRegion();
                end
            end
            
            if (self.flag_done)
                edgeid = self.getEdgeFromLatchedRegion();
            end
        end
        
        function setOutcome(self, selected_edge, outcome) %Interface function
            self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
            %membership = get_region_membership( self.active_hyp, self.hyp_region)
            self.performed_test_set = [self.performed_test_set selected_edge];
        end
        
        function setLatchedRegion(self)
            self.flag_done = 1;
            self.latched_region = find(sum(self.hyp_region(self.active_hyp,:), 1), 1); % pick the first one
        end
        
        function edgeid = getEdgeFromLatchedRegion(self)
            edgeid = [];
            if (~isempty(self.latched_region))
                available_choices = setdiff( self.region_test{self.latched_region}, self.performed_test_set);
                if(~isempty(available_choices))
                    edgeid = available_choices(1);
                end
            end
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
        % plot stuff
        end
        
        function printDebug(self)
        % Print anything for debugging
        end
        
    end
    
end

