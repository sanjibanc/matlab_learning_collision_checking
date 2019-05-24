%% 
% Copyright (c) 2017 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%

classdef policyIncDRD < CollisionCheckPolicy
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
        flag_latched
        latched_region
        num_active_region
        active_region
        flag_running
    end
    
    methods
        function self = policyIncDRD(hyp_region, hyp_test, test_cost, region_test, k)
            self.active_hyp = 1:size(hyp_region, 1);
            self.hyp_region = hyp_region;
            self.hyp_test = hyp_test;
            self.test_cost = test_cost;
            self.region_test = region_test;
            self.performed_test_set = [];
            self.flag_latched = 0;
            self.latched_region = [];
            
            self.num_active_region = k;
            self.active_region = get_topK_hyp_region( self.hyp_region, self.num_active_region);
            if (~isempty(self.active_region))
                self.hyp_subregion_set = create_subregion_set_direct( self.hyp_region(:, self.active_region) );
                self.flag_running = 1;
            else
                self.flag_running = 0;
            end
        end
        
        function edgeid = getEdgeToCheck(self) % Interface function
            edgeid = [];
            if (self.flag_running)
                if (~self.flag_latched)
                    edgeid = direct_drd( self.active_hyp, self.hyp_subregion_set, self.hyp_test, self.test_cost );
                    if (isempty(edgeid))
                        self.setLatchedRegion();
                    end
                end
                
                if (self.flag_latched)
                    edgeid = self.getEdgeFromLatchedRegion();
                end
            end
        end
        
        function setOutcome(self, selected_edge, outcome) %Interface function
            self.active_hyp = prune_hyp( self.active_hyp, self.hyp_test, selected_edge, outcome );
            self.performed_test_set = [self.performed_test_set selected_edge];
            
            if (sum(sum(self.hyp_region(self.active_hyp, self.active_region), 1)) == 0)
                % No more active regions, get them agaion
                self.active_region = get_topK_hyp_region( self.hyp_region(self.active_hyp, :), self.num_active_region);
                if (~isempty(self.active_region))
                    self.hyp_subregion_set = create_subregion_set_direct( self.hyp_region(:, self.active_region) );
                else
                    self.flag_running = 0;
                end
            end
        end
        
        function setLatchedRegion(self)
            latched_region_id = find(sum(self.hyp_region(self.active_hyp, self.active_region), 1), 1); % pick the first one
            if (~isempty(latched_region_id))
                self.flag_latched = 1;
                self.latched_region = self.active_region(latched_region_id);
            else
                self.flag_running = 0; % if latched region is empty, giveup
            end
        end
        
        function edgeid = getEdgeFromLatchedRegion(self)
            edgeid = [];
            available_choices = setdiff( self.region_test{self.latched_region}, self.performed_test_set);
            if(~isempty(available_choices))
                edgeid = available_choices(1);
            else
                self.flag_running = 0;
            end
        end
        
        function plotDebug2D(self, graph, coord_set, path_library)
            if(~isempty(self.active_region))
                for i = self.active_region
                    plot_path(path_library{i}, coord_set, 'y', 1);
                end
            end
        end
        
        function printDebug(self)
            % Print anything for debugging
            if(~self.flag_running)
                fprintf('Not running \n');
            end
            if(self.flag_latched)
                fprintf('Latched to region: %d \n', self.latched_region);
            end
            self.active_region
            membership = get_region_membership( self.active_hyp, self.hyp_region(:, self.active_region) )
        end
        
        function prob = active_prob(self)
            prob = length(self.active_hyp)/size(self.hyp_region,1);
        end
        
        function data = get_decision_tree_data(self)
            data.selected_edge = self.getEdgeToCheck();
            data.active_prob = self.active_prob();
            data.active_hyp = self.active_hyp;
        end
    end
    
end


